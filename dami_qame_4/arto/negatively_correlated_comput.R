negap2 <- list()


negap2$inner_worker <- function(bread, coffee){
  n <- length(bread)
  both   <- as.numeric(bread == 1 & coffee == 1)
  data <- cbind("b"=bread, "c"=coffee, "{b,c}"=both)
  rownames(data)  <- c(paste(1:n))
  counts <- colSums(data, na.rm=TRUE)
  tab1 <- rbind(data, counts)
  supports <- t(as.matrix(counts/length(bread)))
  colnames(supports) <- paste("P(",colnames(data),")",sep="")
  inde <- as.numeric(supports[1]*supports[2])
  tab2 <- cbind(supports, "P(b)*P(c)"=inde)
  
  lift <- as.numeric(supports[3]/inde)
  lift <- paste("\\[\\frac{P(\\{b,c\\})}{P(b)*P(c)}=\\frac{",round(supports[3],2),"}{",round(inde,2),"}=", round(lift,2),"\\]", sep="")
  # return
  list(tab1=tab1, tab2=tab2, lift=lift)
}

temp <- negap2$inner_worker(c(1,1,1,1,NA,NA), c(NA,1,1,1,NA,NA))
negap2$tab11 <- temp[[1]]
negap2$tab12 <- temp[[2]]

temp <- negap2$inner_worker(c(1,1,1,1,NA,NA), c(NA,NA,1,1,1,NA))
negap2$tab21 <- temp[[1]]
negap2$tab22 <- temp[[2]]

temp <- negap2$inner_worker(c(1,1,1,1,NA,NA), c(NA,NA,NA,1,1,1))
negap2$tab31 <- temp[[1]]
negap2$tab32 <- temp[[2]]

temp <- cbind(c(1,1,1,1,NA,NA),c(NA,1,1,1,NA,NA),c(NA,NA,NA,1,1,1))
temp <- cbind(temp, as.numeric(temp[,1] == 1 & temp[,2] == 1))
temp <- cbind(temp, as.numeric(temp[,1] == 1 & temp[,2] == 1 & temp[,3]==1))
colnames(temp) <- c("b","c","d","{b,c}","{b,c,d}")
counts <- rbind(colSums(temp, na.rm=T))
rownames(counts) <- "counts"
negap2$tab101 <- rbind(temp, counts)

#
# 8-column tables
#
b <- c(1,1,1,1,NA,NA)
c <- c(NA,NA,NA,1,1,1)
negap2$inner_worker_8column <- function(b, c){
  nb <- as.numeric(is.na(b))
  nb[nb==0] <- NA
  nc <- as.numeric(is.na(c))
  nc[nc==0] <- NA
  temp <- cbind(b,c,nb,nc)
  temp <- cbind(temp, as.numeric(temp[,1] == 1 & temp[,2] == 1))
  temp <- cbind(temp, as.numeric(temp[,1] == 1 & temp[,4] == 1))
  temp <- cbind(temp, as.numeric(temp[,3] == 1 & temp[,2] == 1))
  temp <- cbind(temp, as.numeric(temp[,3] == 1 & temp[,4] == 1))
  colnames(temp) <- c("b","c","!b", "!c", "{b,c}","{b,!c}","{!b,c}","{!b,!c}")
  counts <- rbind(colSums(temp, na.rm=T))  
  ret <- rbind(temp, counts)
  rownames(ret) <- c(paste(1:length(b)),"count")
  ret
} 

negap2$tab111 <- negap2$inner_worker_8column(c(1,1,1,1,NA,NA),c(NA,NA,NA,1,1,1))
negap2$tab121 <- negap2$inner_worker_8column(c(1,1,1,1,NA,NA),c(NA,NA,1,1,1,NA))
negap2$tab131 <- negap2$inner_worker_8column(c(1,1,1,1,NA,NA),c(NA,1,1,1,NA,NA))

# temp <- cbind(c(1,1,1,1,NA,NA),c(NA,NA,NA,1,1,1),c(NA,NA,NA,NA,1,1),c(1,1,1,NA,NA,NA))
# temp <- cbind(temp, as.numeric(temp[,1] == 1 & temp[,2] == 1))
# temp <- cbind(temp, as.numeric(temp[,1] == 1 & temp[,4] == 1))
# temp <- cbind(temp, as.numeric(temp[,3] == 1 & temp[,2] == 1))
# temp <- cbind(temp, as.numeric(temp[,3] == 1 & temp[,4] == 1))
# colnames(temp) <- c("b","c","!b", "!c", "{b,c}","{b,!c}","{!b,c}","{!b,!c}")
# counts <- rbind(colSums(temp, na.rm=T))
# rownames(counts) <- "counts"
# negap2$tab111 <- rbind(temp, counts)


#
# outting function-closures
#

negap2$inner_outme1 <- function(l){
  n <- nrow(l$tab1)
  print(xtable(l$tab1, digits=0), hline.after=c(-1,0,n-1,n))
  print(xtable(l$tab2, digits=2), include.rownames=F)
  cat(l$lift)
}

# negap2$inner_outme1 <- function(tab1, tab2){
#   n <- nrow(tab1)
#   print(xtable(tab1, digits=NA), hline.after=c(-1,NA,n-1,n))
#   print(xtable(tab2, digits=2), include.rownames=F)
# }

negap2$outme1 <- function(){
  negap2$inner_outme1(negap2$inner_worker(c(1,1,1,1,NA,NA), c(NA,1,1,1,NA,NA)))
}

negap2$outme2 <- function(){
  negap2$inner_outme1(negap2$inner_worker(c(1,1,1,1,NA,NA), c(NA,NA,1,1,1,NA)))
}

negap2$outme3 <- function(){
  negap2$inner_outme1(negap2$inner_worker(c(1,1,1,1,NA,NA), c(NA,NA,NA,1,1,1)))
}

# negap2$outme2 <- function(){negap2$inner_outme1(negap2$tab21, negap2$tab22)}
# negap2$outme3 <- function(){negap2$inner_outme1(negap2$tab31, negap2$tab32)}
