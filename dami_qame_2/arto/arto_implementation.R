
# just a wrapper for C++ function
arto.apriori.gen <- function(Fk_1, debug=FALSE){
  idx.list <- LIST(items(Fk_1), decode=FALSE)
  if(debug) {
    print(system.time( temp <- artoCppAprioriGen(idx.list) ))
  }else{ temp <- artoCppAprioriGen(idx.list)}
  out.list <- temp$candidates;
  count.generated <- temp$generated;
  ret <- encode(out.list, itemLabels=itemLabels(Fk_1), itemMatrix=TRUE)
  ret <- new("itemsets", items=ret)
  # returning:
  list(Ck=ret, counts=c(count.generated, length(ret)))
}


arto.apriori <- function(data.tr, minsup=0.4, mink=1, maxk=100, debug=FALSE){
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
    if(debug) cat("k = ",k,"\n")
    ret <- arto.apriori.gen(Fk.list[[k-1]], debug) # line 5: generate candidate itemsets
    Ck <-ret$Ck
    counts <- ret$counts
    if(length(Ck)==0) {
      cont <- FALSE
    }else{
      if(debug){
        cat("Ck=",k," image of candidates after pruning:\n")
        print(image(items(Ck), main="Ck candidates"))
      }
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



arto.ruleInduction <- function(fisets, transactions, minconfidence){
  k2plus <- which(size(fisets) >= 2)
  fisets_list <- LIST(items(fisets)[k2plus], decode=FALSE)
  
  # rule-candidate generation c++ implementation is roughly 200 times faster
  # print(system.time( temp1 <- arto.ruleCandidates(fisets_list) ))
  print(system.time( temp1 <- artoCppRuleCandidates(fisets_list) ))
  antece.list <- temp1$antece.list
  conseq.list <- temp1$conseq.list
  
  # this conversion is slow ( 0.700 sec a piece), ok for now 
  print(system.time( antece.im <- encode(antece.list, itemLabels=itemLabels(fisets), itemMatrix=TRUE) ))
  print(system.time( conseq.im <- encode(conseq.list, itemLabels=itemLabels(fisets), itemMatrix=TRUE) ))
  myrules <- new("rules", lhs=antece.im, rhs=conseq.im)
  
  # counting the supports from fisets, not from data is 
  # 0.020 vs 0.568 secs (28 times faster)
  f <- function(){
    idx <- match(items(myrules), items(fisets))
    mysupport <- quality(fisets)[idx, "support"]
    idx <- match(lhs(myrules), items(fisets))
    myantece.support <- quality(fisets)[idx, "support"]
    idx <- match(rhs(myrules), items(fisets))
    myconseq.support <- quality(fisets)[idx, "support"]
    # mysupport <- support(items(myrules), transactions)
    # myantece.support  <- support(lhs(myrules), transactions)
    list(support=mysupport, antece.support=myantece.support, conseq.support=myconseq.support)
  }
  print(system.time( temp <- f() ))
  mysupport  <- temp$support
  myantece.support <- temp$antece.support
  myconseq.support <- temp$conseq.support

  myconfidence <- mysupport / myantece.support
  mylift <- myconfidence / myconseq.support
  
  quality(myrules) <- data.frame(support=mysupport, confidence=myconfidence, lift=mylift)
  myrules <- subset(myrules, subset= confidence>=minconfidence)
  myrules
}


# wrapper for a C++ function
arto.closed.itemsets <- function(fisets){
  fisets.ranked <- sort(fisets, by="support")
  fisets.ranked.aslist  <- LIST(items(fisets.ranked), decode=FALSE)
  print(system.time( temp <- artoCppClosedItemsets(fisets.ranked.aslist, quality(fisets.ranked)[,"support"]) ))
  temp.items <- encode(temp$closed_fisets, itemLabels=itemLabels(fisets.ranked), itemMatrix=TRUE)
  temp.quality <- data.frame(support=temp$support)
  closed.arto  <- new("itemsets", items=temp.items, quality= temp.quality)
  closed.arto
}



myget.allbm  <- function(courses.tr, minsup, minconfidence){
  paraml <- list(support=minsup, minlen=1, maxlen=999, ext=FALSE)
  contrl <- list(verbose=FALSE)
  bm <- list()
  bm$fisets  <- eclat(courses.tr, parameter=paraml, control=contrl)
  bm$closed  <- apriori(courses.tr, parameter=c(paraml, target="closed"), control=contrl)
  bm$maximal <- apriori(courses.tr, parameter=c(paraml, target="maximal"), control=contrl) 
  bm$rules   <- ruleInduction(bm$fisets, confidence=minconfidence, control=contrl)
  bm
}


mynamify  <- function(x, lab){
  temp <- rhs(x); itemLabels(temp) <- lab; rhs(x) <- temp
  temp <- lhs(x); itemLabels(temp) <- lab; lhs(x) <- temp
  x
}



mynamify.is  <- function(x, lab){
  temp <- items(x); itemLabels(temp) <- lab; items(x) <- temp
  x
}



myplot.fcmr <- function(bm, mycolors, titleend){
  counts <- sapply(bm, function(x){tabulate(size(x))})
  counts[counts==0] <- NA
  matplot(counts, pch=1:4, lwd=2, col=mycolors,type="b", log="y", xlab="size of itemset", ylab="Number of frequent itemsets", main=paste("FCMR-plot", titleend))
  grid(lty=2)
  legend("topleft", pch=1:4, lwd=2, lty=1:4, col=mycolors, legend=c("frequent", "closed", "maximal", "1-rules"))
}