# Creating founder haplotypes ----

# quickHaplo, runMacs, importInbredGeno, importHaplo
?quickHaplo

?importInbredGeno

geno = rbind(c(2,2,0,2,0),
             c(0,2,2,0,0))
colnames(geno) = letters[1:5]

genMap = data.frame(markerName=letters[1:5],
                    chromosome=c(1,1,1,2,2),
                    position=c(0,0.5,1,0.15,0.4))

ped = data.frame(id=c("a","b"),
                 mother=c(0,0),
                 father=c(0,0))

founderPop = importInbredGeno(geno=geno,
                              genMap=genMap,
                              ped=ped)

getGenMap(founderPop)

pullSegSiteGeno(founderPop)
pullSegSiteHaplo(founderPop)


?importHaplo


# getGenMap, pullSegSiteGeno, pullSegSiteHaplo

# inbred=TRUE or inbred=FALSE



# Traits ----

# Searching SimParam help document with "Find in Topic" (e.g. new())

# addTraitA, addTraitAD, addTraitADE, addTraitADEG

# Defining multiple traits correlated versus multiple calls

founderPop = quickHaplo(100, 10, 100)

# Two traits uncorrelated
SP = SimParam$new(founderPop)
SP$addTraitA(100)
SP$addTraitA(100)

# Two traits correlated
corA = diag(2)
corA[1,2] = corA[2,1] = 0.5
corA

SP = SimParam$new(founderPop)
SP$addTraitA(100, mean = c(0,0), var=c(1,1), corA=corA)

pop = newPop(founderPop)
cor( gv(pop) )


# Setting varE, h2, or H2
# See setVarE() in SimParam


# Neutral SNPs ----

# addSnpChip
# See in SimParam

# restrSegSite

# pullSnpGeno, pullSnpHaplo



# Working with populations ----

founderPop = quickHaplo(100, 10, 100)

SP = SimParam$
  new(founderPop)$
  addTraitA(100)$
  setVarE(h2=0.5)

pop = newPop(founderPop)

pop

# c() and []
c(pop, pop)
pop[1:10]

A = pop[1:10]
B = pop[11:20]
C = c(A,B)

# pheno, gv
pop@pheno
pheno(pop)

cor(gv(pop), pheno(pop))

# meanG, varG

meanG(pop)

varG(pop)

# genParam

gp = genParam(pop)
?genParam

# additive variance from genParam
varA(pop)



# Crossing ----

founderPop = quickHaplo(100, 10, 100)

SP = SimParam$
  new(founderPop)$
  addTraitA(100)$
  setVarE(h2=0.5)

pop = newPop(founderPop)

# randCross, randCross2, makeCross, makeCross2
F1 = randCross(pop, nCrosses=100)

TopCross = randCross2(females=F1, males=pop, nCrosses=100)

?makeCross

crossPlan = cbind(c(1, 1), c(2, 3))
crossPlan
A = makeCross(pop, crossPlan = crossPlan)
A
A@mother
A@father

# Alternative crossPlan using names
crossPlan = cbind(c("1", "1"), c("2", "3"))
B = makeCross(pop, crossPlan = crossPlan)
B@mother
B@father


# makeCross2
crossPlan = cbind(c(1,1), c(2,3))
C = makeCross2(females=pop, males=F1, crossPlan=crossPlan)
C@mother
C@father

# self, makeDH
F2 = self(F1, nProgeny=5)
head(pullQtlGeno(F2))

DH = makeDH(F1, nDH=5)
pullQtlGeno(DH)


# Selection ----

# selectInd, selectWithinFam, selectFam

?selectInd
selectInd(pop, nInd=10)

?selectWithinFam
F2
F2_selected = selectWithinFam(F2, nInd=1)

selectFam(F2, nFam=10)

