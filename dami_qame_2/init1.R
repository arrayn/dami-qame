library('knitr') 
opts_chunk$set(fig.width=10, fig.height=6)
library('RColorBrewer')
mycolors <- brewer.pal(8, "Dark2")
mycolors.a20  <- paste(mycolors,"33",sep="")
# computation
library('Rcpp')
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
library('arules')

