#!/exports/cmvm/eddie/eb/groups/tier2_hickey_group/Programs/R-4.0.0/bin/Rscript
#$ -cwd
#$ -R y
#$ -pe sharedmem 4
#$ -l h_vmem=2G
#$ -l h_rt=00:30:00
#$ -l h=!node1f01.ecdf.ed.ac.uk&!node1f02.ecdf.ed.ac.uk&!node2j01.ecdf.ed.ac.uk&!node2j02.ecdf.ed.ac.uk&!node2j03.ecdf.ed.ac.uk&!node2j04.ecdf.ed.ac.uk
#$ -j y
#$ -t 1-10
#$ -V

REP = Sys.getenv("SGE_TASK_ID")

library(AlphaSimR)

# Number of crosses per year
nCrosses = 100

# DH lines produced per cross
nDH = 100

# The maximum number of DH lines per cross to enter the PYT
# nCrosses*famMax must be greater than or equal to nPYT
famMax = 5

#Entries per yield trial
nPYT = 500
nAYT = 50
nEYT = 10

# Effective replication of yield trials
# Note that the error variance of the phenotype is varE/reps
# This means that partial replication increases error variance
repHDRW = 1/4 # h2=0.1, represents visual selection
repPYT = 1 # Represent a yield trial a 1 location
repAYT = 4 # Represents a yield trial at 4 locations
repEYT = 8 # Represents a yield trial at 8 locations

# Generate initial haplotypes
FOUNDERPOP = runMacs(nInd=70, 
                     nChr=21, 
                     segSites=600,
                     inbred=TRUE, 
                     species="WHEAT")

# Set simulation parameters
SP = SimParam$new(FOUNDERPOP)
SP$addSnpChip(500)
SP$addTraitADG(100, mean=4, var=0.1, varGxE=0.2, # tons/ha
               meanDD=0.1, varDD=0.1)
SP$setVarE(varE=0.4)

# Create parents
Parents = newPop(FOUNDERPOP)

#Set initial yield trials with unique individuals
P = runif(5)
for(year in 1:7){
  # Crossing
  F1 = randCross(Parents,nCrosses)
  if(year<7){
    # DH
    DH = makeDH(F1, nDH)
  }
  if(year<6){
    # HDRW
    HDRW = setPheno(DH, reps=repHDRW, p=P[year])
  }
  if(year<5){
    # PYT
    PYT = selectWithinFam(HDRW, famMax)
    PYT = selectInd(PYT, nPYT)
    PYT = setPheno(PYT, reps=repPYT, p=P[year+1L])
  }
  if(year<4){
    # AYT
    AYT = selectInd(PYT, nAYT)
    AYT = setPheno(AYT, reps=repAYT, p=P[year+2L])
  }
  if(year<3){
    # EYT1
    EYT1 = selectInd(AYT, nEYT)
    EYT1 = setPheno(EYT1, reps=repEYT, p=P[year+3L])
  }
  if(year<2){
    # EYT2 and select variety
    EYT2 = setPheno(EYT1, reps=repEYT, p=P[year+4L])
  }
}

output = data.frame(year=1:40,
                    rep=rep(REP,40),
                    mean=numeric(40),
                    var=numeric(40),
                    genicVar=numeric(40),
                    accDH=numeric(40))

# Cycle years 
P = runif(40)
for(year in 1:20){ 
  source("AdvanceYear.R") 
  # Crossing
  Parents = c(EYT2,EYT1,AYT)
  F1 = randCross(Parents, nCrosses)
  # Report results
  output$mean[year] = meanG(PYT)
  output$var[year] = varG(PYT)
  output$genicVar[year] = genicVarG(PYT)
  # Create training population
  if(year==16){
    trainPop = c(PYT,AYT,EYT1,EYT2)
  }else if(year>16){
    trainPop = c(trainPop,PYT,AYT,EYT1,EYT2)
  }
}

save.image(paste0("Burnin",REP,".RData"))

