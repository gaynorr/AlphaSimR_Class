# This is the first script of the simulation that runs the burn-in
library(AlphaSimR)

# Number of replications
nReps = 10 

# Load global parameters
source("GlobalParameters.R")

# Loop through replications
for(REP in 1:nReps){
  cat("Working on rep:",REP,"\n")
  
  # Initialize variables for results
  hybridCorr = inbredMean = hybridMean = inbredVar = hybridVar =
    rep(NA_real_, burninYears+futureYears)
  
  # Create initial parents and set testers and hybrid parents
  source("CreateParents.R")

  # Fill breeding pipeline with unique individuals from initial parents
  source("FillPipeline.R")

  # p-values for GxY effects
  P = runif(burninYears+futureYears)

  # Cycle years
  for(year in 1:burninYears){
    cat("  Working on year:",year,"\n")
    p = P[year]
    source("UpdateParents.R") #Pick new parents based on last year's data
    source("UpdateTesters.R") #Pick new testers and hybrid parents
    source("AdvanceYear.R") #Advances yield trials by a year
    source("UpdateResults.R") #Track summary data
  }

  save.image(paste0("BURNIN_",REP,".rda"))
}

