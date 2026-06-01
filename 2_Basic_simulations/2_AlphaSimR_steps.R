library(AlphaSimR)

# The four main stages ----

# 1. Create founder haplotypes

founderPop = runMacs(nInd=100, nChr=10, segSites=100)

# 2. Setting simulation parameters

SP = SimParam$new(founderPop)
SP$addTraitA(nQtlPerChr = 100)
SP$setVarE(h2=0.5)

# 3. Modeling the breeding program

pop = newPop(founderPop)

pop_mean = numeric(1000)

for(i in 1:1000){
  pop = selectCross(pop, nInd=100, nCrosses = 1000)
  pop_mean[i] = meanG(pop)
}


# 4. Examining the results

plot(1:1000, pop_mean, type="l", xlab="Cycle", ylab="Mean GV")

