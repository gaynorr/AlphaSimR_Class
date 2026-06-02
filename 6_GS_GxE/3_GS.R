library(AlphaSimR)

# Create an initial population of DH lines for evaluation 
founderPop = runMacs(nInd=50, nChr=10, segSites=2000, inbred=TRUE)

SP = SimParam$new(founderPop)$
  addTraitA(1000, mean=100, var=10)$
  addSnpChip(1000)$
  setVarE(h2=0.3)

parents = newPop(founderPop)

F1 = randCross(parents, nCrosses=100)

DH = makeDH(F1, nDH=10)

# Manually run GS with AlphaSimR solver
# This could be done with any external solver
M = pullSnpGeno(DH) # Genotypes
y = pheno(DH) # Phenotypes
X = matrix(1, nrow=nInd(DH)) # Intercept

sol = solveRRBLUP(y, X, M)
str(sol)

# Observe accuracy
cor(pheno(DH), gv(DH))
cor(M %*% sol$u, gv(DH))


# Using the built-in GS model for populations
gsModel = RRBLUP(DH)

# Set EBVs (default is value="gv")
DH = setEBV(DH, gsModel)

head(ebv(DH))

# Set EBVs with actual EBVs
DH = setEBV(DH, gsModel, value="bv")

head(ebv(DH))

# Estimated marker effects for value="gv" and value="bv" are the same
head(gsModel@gv[[1]]@addEff)
head(gsModel@bv[[1]]@addEff)

# Fixed effects differ for value="gv" and value="bv
head(gsModel@gv[[1]]@intercept)
head(gsModel@bv[[1]]@intercept)

# Estimated variance components
gsModel@Vu # Marker

# Genetic variance
M = pullSnpGeno(DH)
p = colMeans(M) / 2

estGenVar = 4*sum(p*(1-p))*gsModel@Vu

varG(DH)

# Residual variance
gsModel@Ve
SP$varE
popVar(pheno(DH) - gv(DH))

# Heritability
estGenVar / (estGenVar+gsModel@Ve)

varG(DH) / varP(DH)


# Fixed effects and GxE ----
SP = SimParam$new(founderPop)$
  addTraitAG(1000, mean=100, var=10, varGxE=40)$
  addSnpChip(1000)$
  setVarE(h2=0.3)

parents = newPop(founderPop)

F1 = randCross(parents, nCrosses=100)

DH = makeDH(F1, nDH=10)

# Split DHs into 4 trials
# Note that they are not being randomly split
trial1 = setPheno( DH[1:250] )
trial2 = setPheno( DH[251:500] )
trial3 = setPheno( DH[501:750] )
trial4 = setPheno( DH[751:1000] )

trainPop = c(trial1, trial2, trial3, trial4)

naiveModel = RRBLUP(trainPop)

DH = setEBV(DH, naiveModel)
cor(ebv(DH), gv(DH))


# Add appropriate fixed effects
trainPop@fixEff = rep(1:4, each=250)

betterModel = RRBLUP(trainPop)

DH = setEBV(DH, betterModel)
cor(ebv(DH), gv(DH))

# How this should be done when setting the phenotype
trial1 = setPheno(DH[1:250], fixEff=1)
trial2 = setPheno(DH[251:500], fixEff=2)
trial3 = setPheno(DH[501:750], fixEff=3)
trial4 = setPheno(DH[751:1000], fixEff=4)
trainPop = c(trial1, trial2, trial3, trial4)
table(trainPop@fixEff)


# Typical usage is to use the GxE trait for genotype-by-year interactions
# Fixed effects assigned for trial and year
AYT = setPheno(AYT, fixEff=year)
PYT = setPheno(PYT, fixEff=year+40)

