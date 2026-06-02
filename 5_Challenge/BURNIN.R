library(AlphaSimR)

# Number of crosses per year
nCrosses = 100

# DH lines produced per cross
nSeedlings = 10

# The maximum number of DH lines per cross to enter the PYT
# nPYT is nCrosses x nSeedlings
nAYT = 50
nEYT = 10

# Residual variance of the trait
varE = 4 # gives h2=0.2 with 1 replication

# Effective replication of yield trials
repPYT = 1 # Represent a yield trial a 1 location
repAYT = 4 # Represents a yield trial at 4 locations
repEYT = 8 # Represents a yield trial at 8 locations


# Running simulation in 5 replications
for(REP in 1:5){
  # Generate initial haplotypes
  founderPop = quickHaplo(nInd=70, 
                          nChr=10, 
                          segSites=1000)
  
  # Set simulation parameters
  SP = SimParam$new(founderPop)
  SP$addTraitA(1000, mean=0, var=1)
  SP$setTrackPed(TRUE)
  
  # Create parents
  Parents = newPop(founderPop)
  
  #Set initial yield trials with unique individuals
  for(year in 1:6){
    # Crossing
    F1 = randCross(Parents, nCrosses=nCrosses, nProgeny=nSeedlings)
    
    if(year<6){
      # INC, increase of F1s (no phenotype)
      INC = F1
    }
    
    if(year<5){
      # PYT
      PYT = setPheno(INC, reps=repPYT, varE=varE)
    }
    
    if(year<4){
      # AYT
      AYT = selectInd(PYT, nAYT)
      AYT = setPheno(AYT, reps=repAYT, varE=varE)
    }
    
    if(year<3){
      # EYT1
      EYT1 = selectInd(AYT, nEYT)
      EYT1 = setPheno(EYT1, reps=repEYT, varE=varE)
    }
    
    if(year<2){
      # EYT2 and select variety
      EYT2 = setPheno(EYT1, reps=repEYT, varE=varE)
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
    EYT2 = setPheno(EYT1, reps=repEYT, varE=varE)
    
    # EYT1
    EYT1 = selectInd(AYT, nEYT)
    EYT1 = setPheno(EYT1, reps=repEYT, varE=varE)
    
    # AYT
    AYT = selectInd(PYT, nAYT)
    AYT = setPheno(AYT, reps=repAYT, varE=varE)
    
    # PYT
    PYT = INC
    PYT = setPheno(PYT, reps=repPYT, varE=varE)
    
    # INC
    INC = F1
    
    # Crossing
    Parents = c(EYT2,EYT1,AYT)
    F1 = randCross(Parents, nCrosses=nCrosses, nProgeny=nSeedlings)
    
    # Report results
    output$PYT_mean[year] = meanG(PYT)
    output$PYT_var[year] = varG(PYT)
  }
  
  save.image(paste0("Burnin",REP,".RData"))
}

