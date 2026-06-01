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
  # Crossing
  Parents = c(EYT2,EYT1,AYT)
  F1 = randCross(Parents,100)
  # Report results and update training population
  output$mean[year] = meanG(PYT)
  output$var[year] = varG(PYT)
  output$genicVar[year] = genicVarG(PYT)
  trainPop = c(trainPop,PYT,AYT,EYT1,EYT2)
}

saveRDS(output,paste0("Base",REP,".rds"))
