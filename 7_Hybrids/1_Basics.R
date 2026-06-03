# Splitting MaCS output to create two heterotic pools (A and B) ----
founderPop = runMacs(nInd=200, nChr=10, segSites=300, inbred=TRUE,  
                     species="MAIZE")

A = founderPop[1:100]
B = founderPop[101:200]

# Look at PCA plot 
M = pullSegSiteGeno(founderPop)
pca = prcomp(M, rank. = 2)
plot(pca$x[,1], pca$x[,2], pch=16)
points(pca$x[1:100,1], pca$x[1:100,2], col=2, pch=16)



# Creating heterotic pools using "split" argument in MaCS ----
founderPop = runMacs(nInd=200, nChr=10, segSites=300, inbred=TRUE,  
                     species="MAIZE", split=100)


# Look at PCA plot 
M = pullSegSiteGeno(founderPop)
pca = prcomp(M, rank. = 2)
plot(pca$x[,1], pca$x[,2], pch=16)
points(pca$x[1:100,1], pca$x[1:100,2], col=2, pch=16)



# Making test crosses ----

# setPhenoGCA, hybridCross

founderPop = runMacs(nInd=100, nChr=10, segSites=300, inbred=TRUE,
                     species="MAIZE", split=100)

SP = SimParam$new(founderPop[1:50])$
  addTraitAD(300, mean=70, var=20, meanDD=0.92, varDD=0.2)$
  setVarE(varE=270)

A = newPop(founderPop[1:50])
B = newPop(founderPop[51:100])

meanG(A)
meanG(B)

F1 = hybridCross(A, B, returnHybridPop=TRUE)

meanG(F1)

F1_alt = hybridCross(A, B, returnHybridPop=FALSE)


Testers = B[1:3]

A = setPhenoGCA(A, testers=Testers)

head(pheno(A))

# calcGCA

gca = calcGCA(F1)


# Genomic selection models ----
# https://acsess.onlinelibrary.wiley.com/doi/abs/10.1002/csc2.21105


# Test cross model, RRBLUP
# takes testcross phenotypes of inbreds (setPhenoGCA)

## Hybrid data directly
founderPop = runMacs(nInd=100, nChr=10, segSites=800, inbred=TRUE,
                     species="MAIZE", split=100)

SP = SimParam$new(founderPop[1:50])$
  addTraitAD(300, mean=70, var=20, meanDD=0.92, varDD=0.2)$
  setVarE(varE=270)$
  addSnpChip(500)

A = newPop(founderPop[1:50])
B = newPop(founderPop[51:100])

F1 = randCross2(A, B, nCrosses=500)


# RRBLUP_D
sol1 = RRBLUP_D(F1)

F1 = setEBV(F1, solution = sol1)

cor(ebv(F1), gv(F1))

# RRBLUP_GCA
sol2 = RRBLUP_GCA(F1)

A = setEBV(A, solution=sol2, value="female")
head(ebv(A))

B = setEBV(B, solution = sol2, value="male")
head(ebv(B))

F1_virtual = hybridCross(A,B)

gca_true = calcGCA(F1_virtual, use="gv")

cor(ebv(A), gca_true$GCAf[,2])

cor(ebv(B), gca_true$GCAm[,2])

# RRBLUP_SCA


