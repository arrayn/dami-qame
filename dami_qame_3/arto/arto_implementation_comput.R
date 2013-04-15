arto_implementation.list <- vector("list")

parameter <- list(support = 0.20, maxsize=1, maxlen=999, mingap=1, maxgap=999, maxwin=999)
arto_implementation.list$parameter <- parameter
arto_implementation.list$s_cspade <- cspade(courses.str, parameter = arto_implementation.list$parameter)
source("../arto/arto_implementation.R")
temp <- arto.sequence.apriori(courses.str, parameter=arto_implementation.list$parameter) 
arto_implementation.list$s_arto <- temp[[1]]
arto_implementation.list$counts <- temp[[2]]  

arto_implementation.list$inner_out1  <- function(s){
  inspect(s)
  print(as(head(sort(s, by="support"), n=500), "data.frame"))
  print(size(s))
#   summary(s)
}

arto_implementation.list$outme1 <- function(){
  arto_implementation.list$inner_out1(arto_implementation.list$s_cspade)
}

arto_implementation.list$outme2 <- function(){
  arto_implementation.list$inner_out1(arto_implementation.list$s_arto)
}