negap2 <- list()


negap2$inner_worker <- function(bread, coffee){
  n <- length(bread)
  both   <- as.numeric(bread == 1 & coffee == 1)
  data <- cbind("B"=bread, "C"=coffee, "{B,C}"=both)
  rownames(data)  <- c(paste(1:n))
  counts <- colSums(data)
  tab1 <- rbind(data, counts)
  supports <- t(as.matrix(counts/length(bread)))
  colnames(supports) <- paste("P(",colnames(data),")",sep="")
  inde <- as.numeric(supports[1]*supports[2])
  tab2 <- cbind(supports, "P(B)*P(C)"=inde)
  # return
  list(tab1, tab2)
}

temp <- negap2$inner_worker(c(1,1,1,1,0,0), c(0,1,1,1,0,0))
negap2$tab11 <- temp[[1]]
negap2$tab12 <- temp[[2]]

temp <- negap2$inner_worker(c(1,1,1,1,0,0), c(0,0,1,1,1,0))
negap2$tab21 <- temp[[1]]
negap2$tab22 <- temp[[2]]

temp <- negap2$inner_worker(c(1,1,1,1,0,0), c(0,0,0,1,1,1))
negap2$tab31 <- temp[[1]]
negap2$tab32 <- temp[[2]]

#
# outting function-closures
#

negap2$inner_outme1 <- function(tab1, tab2){
  n <- nrow(tab1)
  print(xtable(tab1, digits=0), hline.after=c(-1,0,n-1,n))
  print(xtable(tab2, digits=2), include.rownames=F)
}

negap2$outme1 <- function(){negap2$inner_outme1(negap2$tab11, negap2$tab12)}
negap2$outme2 <- function(){negap2$inner_outme1(negap2$tab21, negap2$tab22)}
negap2$outme3 <- function(){negap2$inner_outme1(negap2$tab31, negap2$tab32)}
