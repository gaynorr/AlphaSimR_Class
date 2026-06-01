library(AlphaSimR)

scenarioName = "BASELINE"

for(REP in 1:5){
  load(paste0("Burnin", REP, ".RData"))
  
  # Cycle years 
  for(year in 21:40){ 
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
    PYT = setPheno(PYT, reps=repPYT, varE)
    
    # INC
    INC = F1
    
    # Crossing
    Parents = c(EYT2,EYT1,AYT)
    F1 = randCross(Parents, nCrosses=nCrosses, nProgeny=nSeedlings)
    
    # Report results
    output$PYT_mean[year] = meanG(PYT)
    output$PYT_var[year] = varG(PYT)
  }
  
  saveRDS(output,paste0(scenarioName, REP, ".rds"))
}

