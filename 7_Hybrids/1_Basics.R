# Splitting MaCS output to create two heterotic pools (A and B) ----
founderPop = runMacs(nInd=200, nChr=10, segSites=300, inbred=TRUE,  species="MAIZE")

A = founderPop[1:100]
B = founderPop[101:200]

# Look at PCA plot 
M = pullSegSiteGeno(founderPop)
pca = prcomp(M, rank. = 2)
plot(pca$x[,1], pca$x[,2], pch=16)
points(pca$x[1:100,1], pca$x[1:100,2], col=2, pch=16)



# Creating heterotic pools using "split" argument in MaCS ----
founderPop = runMacs(nInd=200, nChr=10, segSites=300, inbred=TRUE,  species="MAIZE", split=100)


# Look at PCA plot 
M = pullSegSiteGeno(founderPop)
pca = prcomp(M, rank. = 2)
plot(pca$x[,1], pca$x[,2], pch=16)
points(pca$x[1:100,1], pca$x[1:100,2], col=2, pch=16)



# Making test crosses ----

# setPhenoGCA, hybridCross

# calcGCA



# Genomic selection models ----

# Test cross model, RRBLUP

# RRBLUP_D

# RRBLUP_GCA

# RRBLUP_SCA


