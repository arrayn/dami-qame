arto.convert.sequences.to.list <- function(s){
  # flatten the idx-list because we are only interested in 1-item elements
  temp <- LIST(s, decode=TRUE)
  idx.list  <- vector("list", length(temp))
  for(i in 1:length(temp)){idx.list[[i]] <- unlist(temp[[i]])}
  idx.list
}


# Fk_1 <- Fk.list[[1]]
arto.sequence.apriori.gen <- function(Fk_1){
  idx.list <- arto.convert.sequences.to.list(Fk_1)

  # prepare for combining
  m  <- length(idx.list)
  k_1 <- length(idx.list[[1]])
  temp.mat <- matrix("", m, k_1)
  for(i in 1:m){
    tr  <- idx.list[[i]]
    print(tr)
    temp.mat[i,1:k_1] <- tr
  }
  if(k_1==1){
    lefts <- rights <- matrix(0,m,1)
  }else{
    lefts  <- temp.mat[,2:k_1, drop=F]
    rights <- temp.mat[,1:(k_1-1), drop=F]
  }
  
  # for matching middles combine lefts and rights
  out.list <- list()
  library(gtools)
  idxs <- permutations(m, 2, repeats.allowed=T)
  for(i in 1:nrow(idxs)){
    if(identical(lefts[idxs[i,1]], rights[idxs[i,2]])){
      tempvec <- c(temp.mat[idxs[i,1],1] , temp.mat[idxs[i,2],])
      out.list <- append(out.list, list(tempvec))
    }
  }
  
  ret <- as(out.list, "sequences") 
  count.generated <- nrow(idxs);
  # returning:
  list(Ck=ret, counts=c(count.generated, length(ret)))
}




arto.sequence.support <- function(Ck, data.str){
  cand.list <- arto.convert.sequences.to.list(Ck)
  nc        <- length(cand.list)
  supports  <- rep(0L, nc) # returned
  data.list <- arto.convert.sequences.to.list(data.str)
  seq.ids   <- as(data.str, "data.frame")[,1] 
  m <- length(data.str)

  begseq=1; endseq=1; current.seqid=-1; # begin, end of index of sequence
  for(h in 1:m){
    if((h %% 1000) == 0) cat(h,"")
    if(h == endseq){ # new sequence started
      begseq=h; endseq=h+1;
      current.seqid <- seq.ids[h]
      while(endseq <= m && seq.ids[endseq] == current.seqid){ endseq <- endseq+1;}
      # cat("new seq started: ", current.seqid, begseq, endseq, "\n")
      for(i in 1:nc){
        candi <- cand.list[[i]]
        n <- length(candi)
        j <- 1 # which event of the candidate are we trying to match
        for(hh in begseq:(endseq-1)){
          if(candi[j] %in% data.list[[hh]]){
            j <- j+1 # move on to matching next event
            if(j>n) break;
          }
        }
        if(j>n) supports[i] <- supports[i]+1
      }
    } 
  }
  
  supports/length(unique(seq.ids))
}




# data.str <- courses.str
arto.sequence.apriori <- function(data.str, parameter){
  Fk.list <- list()
  counts.list <- list()
  k <- 1 # line 1

  # line 2: Find all frequent 1-subsequences
  paratemp <- parameter; paratemp$maxlen <- 1 ; paratemp$mingap <- 1
  temp <- cspade(data.str, paratemp)
  if(length(temp)==0) stop("no frequent 1-itemsets")
  Fk.list[[k]] <- temp
  counts.list[[k]] <- c(NA,NA,length(Fk.list[[k]]))
  cont <- TRUE # line 3: repeat
  while(cont){ 
    k <- k+1   # line 4
    ret <- arto.sequence.apriori.gen(Fk.list[[k-1]]) # line 5: generate candidate itemsets
    Ck <-ret$Ck
    counts <- ret$counts
    if(length(Ck)==0) cont <- FALSE
    #lines 6-11: calculate supports for candidates
    supports <- arto.sequence.support(Ck, data.str)
    quality(Ck) <- data.frame(support=supports)    
    Fk.list[k] <- Ck[supports >= parameter$support,] # line 12
    # Fk.list[[k]] <- Ck # TEMP HACK
    counts.list[[k]] <- c(counts, length(Fk.list[[k]]))
    # line 13: until
    if (k >= ncol(data.str) || k>=parameter$maxlen || length(Fk.list[[k]])==0 ) cont <- FALSE   
  }
  # line 14, return the union of Fks
  ret <- Fk.list[[1]]
  for(i in 1:length(Fk.list)) {
    ret <- union(ret, Fk.list[[i]])
  }
  counts <- t(sapply(counts.list, identity))
  counts[counts==0] <- NA
  colnames(counts) <- c("generated_candidates", "after_pruning", "after_support_counting")
  # returning
  list(fisets=ret, counts=counts)
}