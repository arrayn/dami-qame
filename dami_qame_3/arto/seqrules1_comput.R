seqrules1 <- list()

parameter <- list(support = 0.02, maxsize=1, maxlen=999, mingap=1, maxgap=999, maxwin=999)
s1 <- cspade(courses.str, parameter = parameter)
r1 <- ruleInduction(s1, confidence=0.00)
seqrules1$s1 <- s1
seqrules1$r1 <- r1
tdf  <- as(r1, "data.frame")
seqrules1$tdf  <- tdf

#
# outting function-closures
#

seqrules1$outme1 <- function(){
  oldopts <- options("width")
  options(width=120)
  print(as(head(sort(r1, by="support"), n=10), "data.frame"))
  cat("
52  software_engineering
77  computer_organization_i
80  data_structures
83  introduction_to_programming
84  programming_in_java
86  introduction_to_databases
131 introduction_to_the_use_of_computers
193 programming_project
194 data_structures_project")
  options(width=oldopts$width)
}

seqrules1$outme2 <- function(){
  oldopts <- options("width")
  options(width=120)
  print(as(head(sort(r1, by="confidence"), n=9), "data.frame"))
  cat("
49  tutoring
52  software_engineering
77  computer_organization_i
83  introduction_to_programming
84  programming_in_java
86  introduction_to_databases
91  concurrent_programming
93  database_management  
131 introduction_to_the_use_of_computers
193 programming_project
194 data_structures_project
196 software_engineering_lab
402 operating_systems")
  options(width=oldopts$width)
}

seqrules1$outme3 <- function(){
  oldopts <- options("width")
  options(width=120)
  print(as(head(sort(r1, by="lift"), n=9), "data.frame"))
  cat("
77  computer_organization_i
80  data_structures
83  introduction_to_programming 
193 programming_project
197 methods_for_software_engineering
198 introduction_to_computer_science
201  humancomputer_interaction
202 introduction_to_data_communication
206 models_of_computation
215 introduction_to_computer_security
362 personal_study_plan_and_participating_in_teacher_tutoring")
  options(width=oldopts$width)
}

#
# plotting function-closures
#

fudgeit <- function(){
  xm <- get('xm', envir = parent.frame(1))
  ym <- get('ym', envir = parent.frame(1))
  z  <- get('dens', envir = parent.frame(1))
  colramp <- get('colramp', parent.frame(1))
  library(fields)
  image.plot(xm,ym,z, col = colramp(256), legend.only = T, add =F)
}

seqrules1$inner.plotme1 <- function(tdf, xidx, yidx, ...){
  # par(mar = c(5,4,4,5) + .1)
  par(mar = c(4,4,2,5) + .1)
  library(lattice)
  smoothScatter(tdf[,c(xidx, yidx)], nrpoints=nrow(tdf)/10, postPlotHook = fudgeit, ...)
}

seqrules1$plotme1 <- function(){
  seqrules1$inner.plotme1(seqrules1$tdf, 2, 3, ylim=c(0,1), main="Rules: confidence = P(L,R) / P(L) vs. support = P(L,R)", ylab="confidence = P(L,R) / P(L)", xlab="support = P(L,R)")
  temp <- head(tdf[order(tdf$support, decreasing=T),], n=6)
  text(temp[,2], temp[,3], as.character(temp[,1]), cex=0.5, pos=2)
}

seqrules1$plotme2 <- function(){
  seqrules1$inner.plotme1(seqrules1$tdf, 3, 4, main="Rules: lift = [P(L,R) / P(L)] / P(R) vs. confidence = P(L,R) / P(L)", ylab="lift = [P(L,R) / P(L)] / P(R)", xlab="confidence = P(L,R) / P(L)")
  rhses <- unlist(LIST(rhs(seqrules1$r1), decode=T))
  points(tdf[which(rhses == "196"), c(3,4)], col="red", pch=19, cex=0.25)
  legend("topleft", c("RHS=<{196}>"), col="red", lwd=2, lty=3)
}

seqrules1$plotme3 <- function(){
  seqrules1$inner.plotme1(seqrules1$tdf, 2, 4, main="Rules: lift = P(L,R) / [P(L) * P(R)] vs. support = P(L,R)", ylab="lift = P(L,R) / [P(L) * P(R)]", xlab="support = P(L,R)")
}

seqrules1$plotme4 <- function(){
  barplot(head(sort(table(unlist(LIST(lhs(seqrules1$r1), decode=T))), decreasing=T), n=15), cex.names=0.70)
  title("Course occurrences in LHS in a seqrules")
}

seqrules1$plotme5 <- function(){
  barplot(head(sort(table(unlist(LIST(rhs(seqrules1$r1), decode=T))), decreasing=T), n=15), cex.names=0.70, xlab="course ID", ylab="count of occurences as RHS")
  title("Course occurrences as RHS in a seqrules")
}

# R CMD Sweave dami_qame_3_slides_1.Rnw && pdflatex dami_qame_3_slides_1.tex