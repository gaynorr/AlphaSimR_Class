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

# c() and []

# pheno, gv

# meanG, varG

# genParam



# Selection ----

# selectInd, selectWithinFam, selectFam



# Crossing ----

# randCross, randCross2, makeCross, makeCross2

# self, makeDH



