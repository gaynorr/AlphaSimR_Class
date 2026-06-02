# Simulate a population with an AG trait and H2=1
founderPop = quickHaplo(100, 10, 100)

SP = SimParam$new(founderPop)

SP$addTraitAG(nQtlPerChr = 100, varGxE = 2)
SP$setVarE(varE=0)

pop = newPop(founderPop)

# Show how a p-value is used to pass a covariate value
pop = setPheno(pop, p=0.5)
cor(gv(pop), pheno(pop))

pop = setPheno(pop, p=0.25)
qnorm(0.25)
cor(gv(pop), pheno(pop))

pop = setPheno(pop)
cor(gv(pop), pheno(pop))


# Plot GV vs p-value using matplot
p = seq(from=0.1, to=0.9, by=0.1)
p

X = matrix(0, nrow=nInd(pop), ncol=length(p))

for(i in 1:length(p)){
  X[,i] = setPheno(pop, p=p[i], onlyPheno=TRUE)
}

matplot(x=p, y=t(X), type="l")

SP = SimParam$new(founderPop)

SP$addTraitAG(nQtlPerChr = 100, varGxE = 2, varEnv = 7)
SP$setVarE(varE=4)

pop = newPop(founderPop)

p = seq(from=0.1, to=0.9, by=0.1)
p

X = matrix(0, nrow=nInd(pop), ncol=length(p))

for(i in 1:length(p)){
  X[,i] = setPheno(pop, p=p[i], onlyPheno=TRUE)
}

matplot(x=p, y=t(X), type="l")



# Multiple trait can serve as multiple environments



# See FieldSimR for an extreme example
# https://crwerner.github.io/fieldsimr/

