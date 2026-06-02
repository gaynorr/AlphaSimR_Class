library(AlphaSimR)

scenarioName = "BASELINE"

for(REP in 1:5){
  load(paste0("Burnin", REP, ".RData"))
  
  # Cycle years 
  for(year in 21:40){ 
    # Advance breeding program by 1 year
    # Works backwards through pipeline to avoid copying data
    
    
    ### Pick your parents here, so you don't use phenotypes that wouldn't 
    ### be available. You can have more than 1 parent population.
    Parents = c(EYT1, 
                selectInd(AYT, nEYT), 
                selectInd(PYT, nAYT))
    
    
    
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
    
    
    ## Make your crosses here so you don't overwrite F1 before it is needed.
    ## You can use any of the crossing functions. Use makeCross and makeCross2
    ## to manually assign crosses.
    F1 = randCross(Parents, nCrosses=nCrosses, nProgeny=nSeedlings)
    
    
    
    # Report results
    output$PYT_mean[year] = meanG(PYT)
    output$PYT_var[year] = varG(PYT)
  }
  
  saveRDS(output,paste0(scenarioName, REP, ".rds"))
}

