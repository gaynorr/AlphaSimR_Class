# This script runs the per-se breeding program 
# Using AdvanceYearAlt.R instead of AdvanceYear.R
library(AlphaSimR)

scenarioName = "PERSE"

# Number of replications
nReps = 10 

# Loop through replications
for(REP in 1:nReps){
  cat("Working on rep:",REP,"\n")
  
  # Load burn-in information
  load(paste0("BURNIN_",REP,".rda"))
  
  # Cycle through new years
  for(year in (burninYears+1):(burninYears+futureYears)){ 
    cat("  Working on year:",year,"\n")
    p = P[year]
    source("UpdateParents.R") #Pick new parents based on last year's data
    source("UpdateTesters.R") #Pick new testers and hybrid parents
    source("AdvanceYearAlt.R") #Advances yield trials by a year
    source("UpdateResults.R") #Track summary data
  }
  
  # Save results
  output = list(rep=REP,
                year = 1:(burninYears+futureYears),
                scenario = rep(scenarioName, burninYears+futureYears),
                inbredMean = inbredMean,
                inbredVar = inbredVar,
                hybridMean = hybridMean,
                hybridVar = hybridVar,
                hybridCorr = hybridCorr)
  
  saveRDS(output, paste0(scenarioName,"_", REP,".rds"))
}