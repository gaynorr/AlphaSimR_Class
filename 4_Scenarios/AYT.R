library(AlphaSimR)

scenarioName = "AYT"

for(REP in 1:5){
  load(paste0("Burnin", REP, ".RData"))
  
  # Cycle years 
  for(year in 21:40){ 
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
    Parents = AYT
    F1 = randCross(Parents, nCrosses)
    
    # Report results
    output$PYT_mean[year] = meanG(PYT)
    output$PYT_var[year] = varG(PYT)
  }
  
  saveRDS(output,paste0(scenarioName, REP, ".rds"))
}

