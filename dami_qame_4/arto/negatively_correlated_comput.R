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
  lift <- paste("\\[\\frac{P(\\{b,c\\})}{P(b)*P(c)}=", round(lift,2),"\\]", sep="")
  # return
  list(tab1=tab1, tab2=tab2, lift=lift)
}

temp <- negap2$inner_worker(c(1,1,1,1,0,0), c(0,1,1,1,0,0))
negap2$tab11 <- temp[[1]]
negap2$tab12 <- temp[[2]]

temp <- negap2$inner_worker(c(1,1,1,1,NA,NA), c(NA,NA,1,1,1,NA))
negap2$tab21 <- temp[[1]]
negap2$tab22 <- temp[[2]]

temp <- negap2$inner_worker(c(1,1,1,1,0,0), c(0,0,0,1,1,1))
negap2$tab31 <- temp[[1]]
negap2$tab32 <- temp[[2]]

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
#   print(xtable(tab1, digits=0), hline.after=c(-1,0,n-1,n))
#   print(xtable(tab2, digits=2), include.rownames=F)
# }

negap2$outme1 <- function(){
  negap2$inner_outme1(negap2$inner_worker(c(1,1,1,1,0,0), c(0,1,1,1,0,0)))
}

negap2$outme2 <- function(){
  negap2$inner_outme1(negap2$inner_worker(c(1,1,1,1,0,0), c(0,0,1,1,1,0)))
}

negap2$outme3 <- function(){
  negap2$inner_outme1(negap2$inner_worker(c(1,1,1,1,0,0), c(0,0,0,1,1,1)))
}

# negap2$outme2 <- function(){negap2$inner_outme1(negap2$tab21, negap2$tab22)}
# negap2$outme3 <- function(){negap2$inner_outme1(negap2$tab31, negap2$tab32)}
