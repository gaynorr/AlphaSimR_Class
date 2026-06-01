# Write a script that does the following:

# Create 100 inbred individuals with quickHaplo that have 10 chromosomes and 100 segSites per chromosome
founderPop = quickHaplo(nInd=100, nChr = 10, segSites = 100, inbred=TRUE)

# Add an additive trait with 100 QTL per chromosome
# Set trait mean to 100 and variance to 10
SP = SimParam$new(founderPop)$addTraitA(100, mean=100, var=10)

# Set trait heritability (h2) to 0.3
SP$setVarE(h2=0.3)

# Use the founder haplotypes to create a population called "Parents"
Parents = newPop(founderPop)

# Make 100 random crosses between "Parents" to create a population called "F1"
# Produce 1 individual per cross
F1 = randCross(Parents, nCrosses = 100)

# Self "F1" to create a population called "F2"
# Produce 10 F2 plants for each F1
F2 = self(F1, nProgeny = 10)

# Make DH lines from "F2" and call them "DH"
# Produce 1 DH per F2
DH = makeDH(F2)

# Select the 5 best DH plants per family in "DH" and call the population "DH2"
DH2 = selectWithinFam(DH, nInd = 5)

# Select the 10 best DH plants in "DH2" and call the population "DH3"
DH3 = selectInd(DH2, 10)
