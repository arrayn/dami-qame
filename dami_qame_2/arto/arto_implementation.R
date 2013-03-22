# arto_implementation.R

arto.apriori.gen <- function(Fk_1){
  out.list <- list()
  count.generated <- 0
  mat <- items(Fk_1)
  m <- nrow(mat)
  n <- ncol(mat)
  idx.list <- LIST(mat, decode=FALSE)
  k_1 <- length(idx.list[[1]])
  idx.mat <- sapply(idx.list, identity) # note! it's transposed
  print(dim(idx.mat))
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


arto.apriori <- function(data.tr, minsup=0.4, mink=1, maxk=100){
  Fk.list <- list()
  counts.list <- list()
  k <- 1 # line 1
  # line 2: Find all frequent 1-itemsets
  temp.freq <- as.numeric(itemFrequency(data.tr))
  idxs <- which(temp.freq >= minsup)
  if(length(idxs)==0) stop("no frequent 1-itemsets")
  temp.mat <- matrix(0L, nrow=length(idxs), ncol=ncol(data.tr))
  colnames(temp.mat) <- colnames(data.tr)
  for(i in 1:length(idxs)){
    temp.mat[i,idxs[i]] <- 1L
  }
  temp.quality <- data.frame("support"=temp.freq[idxs])
  Fk.list[[k]] <- new("itemsets", items=as(temp.mat, 'itemMatrix'), 
                      quality=temp.quality)
  counts.list[[k]] <- c(NA,NA,length(Fk.list[[k]]))
  cont <- TRUE # line 3: repeat
  while(cont){ 
    k <- k+1   # line 4
    cat("k = ",k,"\n")
    ret <- arto.apriori.gen(Fk.list[[k-1]]) # line 5: generate candidate itemsets
    Ck <-ret$Ck
    counts <- ret$counts
    if(length(Ck)==0) {
      cont <- FALSE
    }else{
      cat("Ck=",k," image of candidates after pruning:\n")
      print(image(items(Ck), main="Ck candidates"))
    }
    #lines 6-11: calculate supports for candidates
    supports <- support(Ck, data.tr)
    quality(Ck) <- data.frame(support=supports)    
    Fk.list[k] <- Ck[supports>=minsup,] # line 12
    counts.list[[k]] <- c(counts, length(Fk.list[[k]]))
    # line 13: until
    if (k >= ncol(data.tr) || k>=maxk || length(Fk.list[[k]])==0 ) cont <- FALSE   
  }
  # line 14, return the union of Fks
  ret <- Fk.list[[mink]]
  for(i in (mink+1):length(Fk.list)) {
    ret <- union(ret, Fk.list[[i]])
  }
  counts <- t(sapply(counts.list, identity))
  counts[counts==0] <- NA
  colnames(counts) <- c("generated_candidates", "after_pruning", "after_support_counting")
  # returning
  list(fisets=ret, counts=counts)
}


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


arto.ruleInduction <- function(fisets, transactions, minconfidence){
  k2plus <- which(size(fisets) >= 2)
  fisets_list <- LIST(items(fisets)[k2plus], decode=FALSE)
  print(system.time( temp1 <- arto.ruleCandidates(fisets_list) ))
  print(system.time( temp1 <- artoCppRuleCandidates(fisets_list) ))
  antece.list <- temp1$antece.list
  conseq.list <- temp1$conseq.list
  antece.im <- encode(antece.list, itemLabels=itemLabels(fisets), itemMatrix=TRUE)
  conseq.im <- encode(conseq.list, itemLabels=itemLabels(fisets), itemMatrix=TRUE)
  myrules <- new("rules", lhs=antece.im, rhs=conseq.im)
  mysupport <- support(items(myrules), transactions)
  myantece.support  <- support(lhs(myrules), transactions)
  myconfidence <- mysupport/myantece.support
  myquality <- data.frame(support=mysupport, confidence=myconfidence)
  quality(myrules) <- myquality
  myrules <- subset(myrules, subset= confidence>=minconfidence)
  # print(as(temp, "data.frame"))
  myrules
}

