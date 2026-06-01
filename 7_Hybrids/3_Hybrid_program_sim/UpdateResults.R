#Track performance of parental per se performance
inbredMean[year] = (meanG(MaleInbredYT3)+meanG(FemaleInbredYT3)) / 2
inbredVar[year] = (varG(MaleInbredYT3)+varG(FemaleInbredYT3)) / 2

#Track performance of parental hybrid performance
tmp = hybridCross(FemaleInbredYT3, MaleInbredYT3,
                  returnHybridPop=TRUE) #Only use with DH parents
hybridMean[year] = meanG(tmp)
hybridVar[year] = varG(tmp)

#Track correlation between per se and GCA
tmp = calcGCA(tmp,use="gv")
hybridCorr[year] = (cor(tmp$GCAf[,2], FemaleInbredYT3@gv[,1])+ 
  cor(tmp$GCAm[,2], MaleInbredYT3@gv[,1])) / 2

rm(tmp)
