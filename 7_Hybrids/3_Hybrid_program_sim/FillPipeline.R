#Set initial yield trials with unique individuals

for(year in 1:6){
  cat("  Fill pipeline year:",year,"\n")

  #Year 1, cross to DH
  MaleF1 = randCross(MaleParents, nCrosses)
  FemaleF1 = randCross(FemaleParents, nCrosses)

  MaleDH = makeDH(MaleF1, nDH)
  FemaleDH = makeDH(FemaleF1, nDH)

  #Year 2, first yield trial
  if(year<6){
    MaleYT1 = setPhenoGCA(MaleDH, FemaleTester1, reps=repYT1, inbred=TRUE)
    FemaleYT1 = setPhenoGCA(FemaleDH, MaleTester1, reps=repYT1, inbred=TRUE)
  }

  #Year 3, second yield trial
  if(year<5){
    MaleYT2 = selectInd(MaleYT1, nInbred2)
    FemaleYT2 = selectInd(FemaleYT1, nInbred2)

    MaleYT2 = setPhenoGCA(MaleYT2, FemaleTester2, reps=repYT2, inbred=TRUE)
    FemaleYT2 = setPhenoGCA(FemaleYT2, MaleTester2, reps=repYT2, inbred=TRUE)
  }

  #Year 4, third yield trial, start of hybrid selection
  if(year<4){
    # Selecting inbreds for trials
    MaleInbredYT3 = selectInd(MaleYT2, nInbred3)
    FemaleInbredYT3 = selectInd(FemaleYT2, nInbred3)
    
    # Creating hybrids as a separate populations
    MaleHybridYT3 = hybridCross(MaleInbredYT3, FemaleElite)
    FemaleHybridYT3 = hybridCross(FemaleInbredYT3, MaleElite)

    MaleHybridYT3 = setPheno(MaleHybridYT3, reps=repYT3)
    FemaleHybridYT3 = setPheno(FemaleHybridYT3, reps=repYT3)
  }

  #Year 5, fourth yield trial
  if(year<3){
    # Select best hybrids and phenotype
    MaleHybridYT4 = selectInd(MaleHybridYT3, nYT4)
    FemaleHybridYT4 = selectInd(FemaleHybridYT3, nYT4)

    MaleHybridYT4 = setPheno(MaleHybridYT4, reps=repYT4)
    FemaleHybridYT4 = setPheno(FemaleHybridYT4, reps=repYT4)
    
    # Retain inbreds for selected hybrids
    MaleInbredYT4 = MaleInbredYT3[
      MaleInbredYT3@id%in%MaleHybridYT4@mother
      ]
    FemaleInbredYT4 = FemaleInbredYT3[
      FemaleInbredYT3@id%in%FemaleHybridYT4@mother
      ]
  }

  #Year 6, fifth and final yield trial
  if(year<2){
    # Select best hybrids and phenotype
    MaleHybridYT5 = selectInd(MaleHybridYT4, nYT5)
    FemaleHybridYT5 = selectInd(FemaleHybridYT4, nYT5)

    MaleHybridYT5 = setPheno(MaleHybridYT5, reps=repYT5)
    FemaleHybridYT5 = setPheno(FemaleHybridYT5, reps=repYT5)
    
    # Retain inbreds for selected hybrids
    MaleInbredYT5 = MaleInbredYT4[
      MaleInbredYT4@id%in%MaleHybridYT5@mother
      ]
    FemaleInbredYT5 = FemaleInbredYT4[
      FemaleInbredYT4@id%in%FemaleHybridYT5@mother
      ]
  }

  #Year 7, release
}
