# Mirva Toivonen
# eclat implementation

setwd("~/R_tiedostot")
library('arules')

# read in textfile

# details <- readLines('courses_details.txt')
courses <- readLines('datav2')

# Split a string into a vector of words.
# E.g. words_from_str("i am mario") => c("i", "am", "mario")
split.to.words <- function(s) strsplit(s, split="\\s")[[1]]

# Get itemset for each transaction (element) in vector.
itemsets <- lapply(courses, split.to.words)


# Combine all items (course numbers) into one big vector, remove duplicates.
items <- unique(unlist(itemsets))
sorted.items <- sort(items) 

# For each item, create an occurence column. At end combine to matrix.

vertical.mat <- sapply(sorted.items, function(item) {
  sapply(itemsets, function(itemset) item %in% itemset)
})

#count support for every items = sum of each column
# support.count <- apply(vertical.mat, 2, sum)


generate.fr.itemset <- function(vertical.mat, minsup = 0.2){}

k <- 1
fr.itemsets <- list()

# item is frequent enough if:  x/N >= minsup -> x >= minsup*N 
support.threshold <- minsup * nrow(vertical.mat)


# find 1itemsets
fr.itemsets[[1]] <- find.1itemsets(vertical.mat, support.threshold)


tmp.fr.list <- NULL

branch1 <- list()

#go deep...
# Find frequent k-itemsets
branch1 <-  dive.branch(vertical.mat)

dive <- function(width, branch.nr, depth, combined, new){
  
  # combine frequent items
  tmp <- combined & new
  cat("diving")
  print(width)
  if (sum(tmp) >= support.threshold){
    
    tmp.fr.list[[depth]] <- cbind(branch.nr, width)
    cat("tmp filled")
    
    if(width< length(fr.itemset[[1]])){
      width <- width +1
      dive(width, branch.nr, depth+1, tmp, vertical.mat[,fr.itemset[[branch.nr]][width]])
    }
  }
  return(tmp.fr.list)
  
}

dive.branch <- function(vertical.mat){
  
new.candidates <- NULL
  for(i in 1:length(fr.itemset[[1]])-1){
    for(j in 1:length(fr.itemset[[1]])-1){
      cat("for loop... \n")
      combined <- vertical.mat[,fr.itemset[[1]][i]] & vertical.mat[,fr.itemset[[1]][j]]
      
      print(sum(combined))
      # count support for combined: sum(combined)
      if (sum(combined) >= support.threshold){
        cat("inside if... \n")
        
        tmp.candidate <- c(freq.items[i], freq.items[j])
        new.candidates <- rbind(new.candidates, tmp.candidate, deparse.level=0)
        # dive((i+1), 1, 1, combined, vertical.mat[,fr.itemset[[1]][j+2]])
      
      }
     # if(length(tmp.fr.list) != 0){
      #  candidate[[i]] <- tmp.fr.list
      #}
    }
  }
  
return(new.candidates)
}


find.1itemsets <- function(vertical.mat, support.threshold) {
  
  # support count for every items = sum of each column
  support.count <- apply(vertical.mat, 2, sum)
  
  # for getting the index of frequent item write: freq.items[[1]]
  
  freq.items <- which(support.count >= support.threshold) 
  freq.items <- sort(freq.items) # lexicographical order
  
  if (length(freq.items) == 0) {
    return(NULL)
  }
  else 
    freq.items
}

