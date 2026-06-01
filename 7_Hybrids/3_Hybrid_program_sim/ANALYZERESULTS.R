library(data.table) # for rbindlist
library(dplyr)
library(ggplot2)

#Read in results and collapse to a single data.frame
scenarios = c("BASELINE", "PERSE")
reps = 1:10

allRuns = expand.grid(scenarios=scenarios, reps=reps)
output = vector("list", nrow(allRuns))

for(i in seq_len(nrow(allRuns))){
  output[[i]] = readRDS(paste0(allRuns$scenarios[i], "_", 
                               allRuns$reps[i], ".rds"))
}

output = rbindlist(output)

# Examine hybrid yield
hybridYield = output %>% 
  mutate(year = year-20) %>% # Setting year 1 to first year of new scenarios
  filter(year>=0) %>% # Removing burn-in (except last year)
  group_by(year, scenario) %>%
  summarise(mean = mean(hybridMean), stderr = sd(hybridMean)/sqrt(n()))

ggplot(hybridYield, aes(year, mean)) + 
  geom_ribbon(aes(ymin = mean-stderr, 
                  ymax = mean+stderr, fill=scenario), 
              alpha=0.2) +
  geom_line(aes(color=scenario), linewidth=1) +
  ggtitle("Hybrid yield")

# Examine inbred yield
inbredYield = output %>% 
  mutate(year = year-20) %>% # Setting year 1 to first year of new scenarios
  filter(year>=0) %>% # Removing burn-in (except last year)
  group_by(year, scenario) %>%
  summarise(mean = mean(inbredMean), stderr = sd(inbredMean)/sqrt(n()))

ggplot(inbredYield, aes(year, mean)) + 
  geom_ribbon(aes(ymin = mean-stderr, 
                  ymax = mean+stderr, fill=scenario), 
              alpha=0.2) +
  geom_line(aes(color=scenario), linewidth=1) +
  ggtitle("Inbred yield")

# Examine inbred-hybrid correlation, including burn-in
inbredHybridCorr = output %>% 
  mutate(year = year-20) %>% # Setting year 1 to first year of new scenarios
  group_by(year, scenario) %>%
  summarise(mean = mean(hybridCorr), stderr = sd(hybridCorr)/sqrt(n()))

ggplot(inbredHybridCorr, aes(year, mean)) + 
  geom_ribbon(aes(ymin = mean-stderr, 
                  ymax = mean+stderr, fill=scenario), 
              alpha=0.2) +
  geom_line(aes(color=scenario), linewidth=1) +
  ggtitle("Inbred-hybrid correlation")

