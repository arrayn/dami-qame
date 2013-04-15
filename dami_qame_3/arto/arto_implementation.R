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
#   cont <- TRUE # line 3: repeat
#   while(cont){ 
#     k <- k+1   # line 4
#     if(debug) cat("k = ",k,"\n")
#     ret <- arto.apriori.gen(Fk.list[[k-1]], debug) # line 5: generate candidate itemsets
#     Ck <-ret$Ck
#     counts <- ret$counts
#     if(length(Ck)==0) {
#       cont <- FALSE
#     }else{
#       if(debug){
#         cat("Ck=",k," image of candidates after pruning:\n")
#         print(image(items(Ck), main="Ck candidates"))
#       }
#     }
#     #lines 6-11: calculate supports for candidates
#     supports <- support(Ck, data.str)
#     quality(Ck) <- data.frame(support=supports)    
#     Fk.list[k] <- Ck[supports>=minsup,] # line 12
#     counts.list[[k]] <- c(counts, length(Fk.list[[k]]))
#     # line 13: until
#     if (k >= ncol(data.str) || k>=maxk || length(Fk.list[[k]])==0 ) cont <- FALSE   
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