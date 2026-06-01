#!/exports/cmvm/eddie/eb/groups/tier2_hickey_group/Programs/R-4.0.0/bin/Rscript
#$ -cwd
#$ -R y
#$ -pe sharedmem 8
#$ -l h_vmem=3G
#$ -l h_rt=10:00:00
#$ -hold_jid BURNIN.R
#$ -l h=!node1f01.ecdf.ed.ac.uk&!node1f02.ecdf.ed.ac.uk&!node2j01.ecdf.ed.ac.uk&!node2j02.ecdf.ed.ac.uk&!node2j03.ecdf.ed.ac.uk&!node2j04.ecdf.ed.ac.uk
#$ -t 1-10
#$ -j y
#$ -V

library(AlphaSimR)
REP = Sys.getenv("SGE_TASK_ID")
load(paste0("Burnin",REP,".RData"))

# Cycle years to make more advanced parents
for(year in 21:40){ #Change to any number of desired years
  gsModel = RRBLUP(trainPop)
  source("AdvanceYearGS.R") #Advances yield trials by a year
  # Run population improvement
  # Assumes 3 generations per year
  if(year==21){ # First year after BURNIN
    # Gather initial parents
    Parents = c(EYT2,EYT1,AYT) # Inbred lines
    
    # Cycle 1, create F1s
    PopImprove = randCross(Parents, 100)
    # Cycle 2, create F2s by random crossing
    PopImprove = randCross(PopImprove, 1000)
    # Cycle 3
    PopImprove = setEBV(PopImprove, gsModel)
    PopImprove = selectInd(PopImprove, 1000, use="ebv") # Orders genotypes by EBV
    F1 = PopImprove[101:200] # Send 400 plants to product development (not the best 100)
    PopImprove = randCross(PopImprove[1:100], 1000) # Best 100 lines
  }else{ # All other years
    # Cycle 3+
    for(cycle in 1:3){
      PopImprove = setEBV(PopImprove, gsModel)
      if(cycle==3){
        PopImprove = selectInd(PopImprove, 1000, use="ebv") # Orders genotypes by EBV
        F1 = PopImprove[101:200] # Send 400 plants to product development (not the best 100)
        PopImprove = randCross(PopImprove[1:100], 1000) # Best 100 lines
      }else{
        PopImprove = selectInd(PopImprove, 100, use="ebv")
        PopImprove = randCross(PopImprove, 1000)
      }
    }
  }
  # Report results and update training population
  output$mean[year] = meanG(PYT)
  output$var[year] = varG(PYT)
  output$genicVar[year] = genicVarG(PYT)
  trainPop = c(trainPop,PYT,AYT,EYT1,EYT2)
}

saveRDS(output,paste0("2Part",REP,".rds"))
