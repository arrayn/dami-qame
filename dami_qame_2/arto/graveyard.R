
arto.apriori.gen.old <- function(Fk_1, debug=FALSE){
  out.list <- list()
  count.generated <- 0
  mat <- items(Fk_1)
  m <- nrow(mat)
  n <- ncol(mat)
  idx.list <- LIST(mat, decode=FALSE)
  k_1 <- length(idx.list[[1]])
  idx.mat <- sapply(idx.list, identity) # note! it's transposed
  if(debug) print(dim(idx.mat))
  for(i in 1:m){
    ouridxs <- idx.list[[i]]
    ourj <- ouridxs[k_1]
    k2match <- rep(TRUE,m)
    if(k_1>=2){
      k2match <- colSums(idx.mat[1:(k_1-1), ,drop=F] == ouridxs[1:(k_1-1)])
      k2match <- k2match == (k_1-1)
    }
    tempsizes <- size(mat[, (ourj):n])
    for(ti in 1:m){
      if(k2match[ti] & tempsizes[ti]>0 & ti!=i){
        theiridxs <- idx.list[[ti]]
        candi <- c(ouridxs, theiridxs[length(theiridxs)])
        count.generated <- count.generated + 1
        # pruning-step: split to (k-1)-subsets and check that they are frequent
        subsetfreqsum <- 0
        if(k_1>=2){
          for(j in 1:length(candi)){
            subo <- candi[-j]
            k1match <- colSums(idx.mat == subo)
            k1match <- k1match == k_1
            if(sum(k1match)>0) subsetfreqsum <- subsetfreqsum+1
          }
        }else{subsetfreqsum <- k_1+1}
        if(subsetfreqsum==k_1+1) out.list <- c(out.list, list(candi))
      }
    }
  }
  ret <- encode(out.list, itemLabels=itemLabels(Fk_1), itemMatrix=TRUE)
  ret <- new("itemsets", items=ret)
  # returning:
  list(Ck=ret, counts=c(count.generated, length(ret)))
}



# for comparison performance
arto.ruleCandidates  <- function(fisets_list){
  antece.list <- list()
  conseq.list <- list()
  for(i in 1:length(fisets_list)){
    onerow <- fisets_list[[i]]
    # print(onerow)
    for(j in 1:length(onerow)){
      antece.list <- c(antece.list, list(onerow[-j]))
      conseq.list <- c(conseq.list, list(onerow[j]))
      # cat(antece.list[[length(antece.list)]], "-->", conseq.list[[length(conseq.list)]], "\n")
    }
  }
  list(antece.list=antece.list, conseq.list=conseq.list)
}


