# Fk_1 <- Fk.list[[1]]
arto.sequence.apriori.gen <- function(Fk_1, debug=FALSE){
  
  # flatten the idx-list because we are only interested in 1-item elements
  temp <- LIST(Fk_1, decode=FALSE)
  # temp <- LIST(arto_implementation.list$s_cspade, decode=FALSE)
  idx.list  <- vector("list", length(temp))
  for(i in 1:length(temp)){idx.list[[i]] <- unlist(temp[[i]])}
  
#   if(debug) {
#     print(system.time( temp <- artoCppAprioriGen(idx.list) ))
#   }else{ temp <- artoCppAprioriGen(idx.list)}
  
  # inspect(as(temp, "sequences"))
  # str(arto_implementation.list$s_cspade)
  
  out.list <- temp$candidates;
  count.generated <- temp$generated;
  ret <- encode(out.list, itemLabels=itemLabels(Fk_1), itemMatrix=TRUE)
  ret <- new("itemsets", items=ret)
  # returning:
  list(Ck=ret, counts=c(count.generated, length(ret)))
}


# data.str <- courses.str
arto.sequence.apriori <- function(data.str, parameter){
  Fk.list <- list()
  counts.list <- list()
  k <- 1 # line 1
  # line 2: Find all frequent 1-subsequences
  paratemp <- parameter; paratemp$maxwin <- 1 ; paratemp$mingap <- 1
  temp <- cspade(data.str, paratemp)
  if(length(temp)==0) stop("no frequent 1-itemsets")
  Fk.list[[k]] <- temp
  counts.list[[k]] <- c(NA,NA,length(Fk.list[[k]]))
  cont <- TRUE # line 3: repeat
#   while(cont){ 
#     k <- k+1   # line 4
#     ret <- arto.sequence.apriori.gen(Fk.list[[k-1]], debug) # line 5: generate candidate itemsets
#     Ck <-ret$Ck
#     counts <- ret$counts
#     if(length(Ck)==0) cont <- FALSE
# #     #lines 6-11: calculate supports for candidates
# #     supports <- support(Ck, data.str)
# #     quality(Ck) <- data.frame(support=supports)    
# #     Fk.list[k] <- Ck[supports>=minsup,] # line 12
# #     counts.list[[k]] <- c(counts, length(Fk.list[[k]]))
#     # line 13: until
#     if (k >= ncol(data.str) || k>=parameter$maxlen || length(Fk.list[[k]])==0 ) cont <- FALSE   
#   }
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