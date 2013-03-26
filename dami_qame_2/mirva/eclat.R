# Mirva Toivonen
# eclat implementation

setwd("~/R_tiedostot")
library('arules')

# read in textfile
data.tr <- read.transactions('datav2', rm.duplicates=TRUE)

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

generate.fr.itemset <- function(vertical.mat, minsup = 0.2){
  
  fr.itemsets <- list()
  
  # item is frequent enough if:  x/N >= minsup -> x >= minsup*N 
  support.threshold <- minsup * nrow(vertical.mat)
  
  # find 1itemsets
  fr.itemsets[[1]] <- find.1itemsets(vertical.mat, support.threshold)
  
  #branch1 <- list()
  branch1 <- NULL
  
  # Find frequent k-itemsets
  branch1 <-  dive.branch(vertical.mat, support.threshold)
  
  return (branch1)  
}

dive <- function(j, combined, tmp.candidate, support.threshold){
  
  #combine frequent items
  combined <- combined & vertical.mat[,fr.itemsets[[1]][j]]
  
  if (sum(combined) >= support.threshold){
    if(j< length(fr.itemsets[[1]])){
      
      tmp.candidate <- c(tmp.candidate, sorted.items[freq.items[j]])
      tmp.candidate <-  dive((j+1), combined, tmp.candidate, support.threshold)
    }
  }
  return(tmp.candidate)
}

dive.branch <- function(vertical.mat, support.threshold){
  max.items <- list()
  new.candidates <- list()
  n<-1
  for(i in 1:length(fr.itemsets[[1]])-1){
    for(j in (i+1):length(fr.itemsets[[1]])){
      
      combined <- vertical.mat[,fr.itemsets[[1]][i]] & vertical.mat[,fr.itemsets[[1]][j]]
      # print(sum(combined))
      if (sum(combined) >= support.threshold){
        
        tmp.candidate <- c(sorted.items[freq.items[i]], sorted.items[freq.items[j]])
        if(j< length(fr.itemsets[[1]])){
          
          tmp.candidate <-  dive(j+1, combined, tmp.candidate, support.threshold)
          max.items[[n]]<- tmp.candidate
          n<- (n+1)
        }
      }
    }   
  }
  return(max.items)
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


