library(data.table) # for rbindlist
library(dplyr)
library(ggplot2)

#Read in results and collapse to a single data.frame
scenarios = c("BASELINE", "AYTxEYT")
reps = 1:5

allRuns = expand.grid(scenarios=scenarios, reps=reps)
output = vector("list", nrow(allRuns))

for(i in seq_len(nrow(allRuns))){
  output[[i]] = readRDS(paste0(allRuns$scenarios[i], allRuns$reps[i], ".rds"))
  
  # Centering PYT_mean at 0 in the last year of the burn-in
  output[[i]]$PYT_mean = output[[i]]$PYT_mean - output[[i]]$PYT_mean[20]
  
  # Add rep and scenario information to data.frame
  output[[i]]$Rep = allRuns$reps[i]
  output[[i]]$Scenario = allRuns$scenarios[i]
}

output = rbindlist(output)

# Examine trait mean
yield = output %>% 
  mutate(Year = Year-20) %>% # Setting year 1 to first year of new scenarios
  filter(Year>=0) %>% # Removing burn-in (except last year)
  group_by(Year, Scenario) %>%
  summarise(Mean = mean(PYT_mean), Stderr = sd(PYT_mean)/sqrt(n()))

ggplot(yield, aes(Year, Mean)) + 
  geom_ribbon(aes(ymin = Mean-Stderr, 
                  ymax = Mean+Stderr, fill=Scenario), 
              alpha=0.2) +
  geom_line(aes(color=Scenario), linewidth=1) +
  ggtitle("Genetic Gain in PYT")

