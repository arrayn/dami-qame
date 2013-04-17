seqrules1 <- list()

parameter <- list(support = 0.02, maxsize=1, maxlen=999, mingap=1, maxgap=999, maxwin=999)
s1 <- cspade(courses.str, parameter = parameter)
r1 <- ruleInduction(s1, confidence=0.00)
seqrules1$s1 <- s1
seqrules1$r1 <- r1
tdf  <- as(r1, "data.frame")
seqrules1$tdf  <- tdf

# outting function-closures

seqrules1$outme1 <- function(){
  oldopts <- options("width")
  options(width=120)
  print(as(head(sort(r1, by="lift"), n=15), "data.frame"))
  options(width=oldopts$width)
}

seqrules1$outme2 <- function(){
  oldopts <- options("width")
  options(width=120)
  print(as(head(sort(r1, by="confidence"), n=15), "data.frame"))
  options(width=oldopts$width)
}

# plotting function-closures

seqrules1$inner.plotme1 <- function(tdf, xidx, yidx, ...){
  library(lattice)
  smoothScatter(tdf[,c(xidx, yidx)],nrpoints=nrow(tdf)/10, ...)
}

seqrules1$plotme1 <- function(){
  seqrules1$inner.plotme1(seqrules1$tdf, 2, 3, ylim=c(0,1), main="Rules: confidence vs. support")
}

seqrules1$plotme2 <- function(){
  seqrules1$inner.plotme1(seqrules1$tdf, 2, 4, main="Rules: lift vs. support")
}

seqrules1$plotme3 <- function(){
  seqrules1$inner.plotme1(seqrules1$tdf, 3, 4, main="Rules: lift vs. confidence")
}

# R CMD Sweave dami_qame_3_slides_1.Rnw && pdflatex dami_qame_3_slides_1.tex