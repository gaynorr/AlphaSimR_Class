rm(list=ls())

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


# Running simulation in 5 replications
for(REP in 1:5){
  # Generate initial haplotypes
  founderPop = quickHaplo(nInd=70, 
                          nChr=21, 
                          segSites=100,
                          inbred=TRUE)
  
  # Set simulation parameters
  SP = SimParam$new(founderPop)
  SP$addTraitA(100, mean=4, var=0.1)
  SP$setVarE(varE=0.4)
  
  # Create parents
  Parents = newPop(founderPop)
  
  #Set initial yield trials with unique individuals
  for(year in 1:7){
    # Crossing
    F1 = randCross(Parents,nCrosses)
    
    if(year<7){
      # DH
      DH = makeDH(F1, nDH)
    }
    
    if(year<6){
      # HDRW
      HDRW = setPheno(DH, reps=repHDRW)
    }
    
    if(year<5){
      # PYT
      PYT = selectWithinFam(HDRW, famMax)
      PYT = selectInd(PYT, nPYT)
      PYT = setPheno(PYT, reps=repPYT)
    }
    
    if(year<4){
      # AYT
      AYT = selectInd(PYT, nAYT)
      AYT = setPheno(AYT, reps=repAYT)
    }
    
    if(year<3){
      # EYT1
      EYT1 = selectInd(AYT, nEYT)
      EYT1 = setPheno(EYT1, reps=repEYT)
    }
    
    if(year<2){
      # EYT2 and select variety
      EYT2 = setPheno(EYT1, reps=repEYT)
    }
  }
  
  # data.frame for saving mean and variance of PYT stage
  output = data.frame(Year=1:40,
                      PYT_mean=numeric(40),
                      PYT_var=numeric(40))
  
  # Cycle years 
  for(year in 1:20){ 
    # Advance breeding program by 1 year
    # Works backwards through pipeline to avoid copying data
    
    # EYT2 and select variety
    EYT2 = setPheno(EYT1, reps=repEYT)
    
    # EYT1
    EYT1 = selectInd(AYT, nEYT)
    EYT1 = setPheno(EYT1, reps=repEYT)
    
    # AYT
    AYT = selectInd(PYT, nAYT)
    AYT = setPheno(AYT, reps=repAYT)
    
    # PYT
    PYT = selectWithinFam(HDRW, famMax)
    PYT = selectInd(PYT, nPYT)
    PYT = setPheno(PYT, reps=repPYT)
    
    # HDRW
    HDRW = setPheno(DH, reps=repHDRW)
    
    # DH
    DH = makeDH(F1, nDH)
    
    # Crossing
    Parents = c(EYT2,EYT1,AYT)
    F1 = randCross(Parents, nCrosses)
    
    # Report results
    output$PYT_mean[year] = meanG(PYT)
    output$PYT_var[year] = varG(PYT)
  }
  
  save.image(paste0("Burnin",REP,".RData"))
}

