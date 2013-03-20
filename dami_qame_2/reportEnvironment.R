# reportEnvironment.R

# to build the whole report, run:
# setwd("~/atlinks/dami-qame/dami_qame_1")
# source('reportEnvironment.R'); build.report(c(1,2,3,4,5,6,7,8), do.pdf=TRUE);

# source this file manually and keep it commented like this: 
# ```{r, echo=FALSE}
# # source('reportEnvironment.R'); build.report(c(2,4));
# ```
# .  
# 
# 4. Reference itemsets created by euclat-algorithm
# -------------------

# install.packages('arules') # only once

library('knitr') 
library('RColorBrewer')
library('arules')
opts_chunk$set(fig.width=10, fig.height=6)

mycat.monospace <- function(filepath, highlight="r"){
  x <- readLines(filepath)
  cat("```", highlight,"\n")
  cat(x, sep="\n")
  cat("```\n")
}

build.report <- function(filename="dami_qame_2", chosen.parts, do.pdf=FALSE, toc=FALSE){
  if (toc) {tocstr <- "--toc"} else{tocstr <- ""}
  r <- ""
#   r <- c(filename,
#          '===========')
  if(1 %in% chosen.parts) r <- c(r, readLines('part1_summary.Rmd'))
  if(2 %in% chosen.parts) r <- c(r, readLines('part2_init.Rmd'))
  if(3 %in% chosen.parts) r <- c(r, readLines('part3_explore.Rmd'))
  if(4 %in% chosen.parts) r <- c(r, readLines('part4_reference.Rmd'))
  if(5 %in% chosen.parts) r <- c(r, readLines('part5_arto.Rmd'))
  if(6 %in% chosen.parts) r <- c(r, readLines('part6_eric.Rmd'))
  if(7 %in% chosen.parts) r <- c(r, readLines('part7_mirva.Rmd'))
  if(8 %in% chosen.parts) r <- c(r, readLines('part8_quan.Rmd'))
  if(15 %in% chosen.parts) r <- c(r, readLines('part15_arto_individual.Rmd'))
  if(16 %in% chosen.parts) r <- c(r, readLines('part16_eric_individual.Rmd'))
  if(17 %in% chosen.parts) r <- c(r, readLines('part17_mirva_individual.Rmd'))
  if(18 %in% chosen.parts) r <- c(r, readLines('part18_quan_individual.Rmd'))
  cat(r, file=paste(filename,".Rmd", sep=""), sep="\n")
  knit2html(paste(filename,".Rmd", sep=""))
  if(interactive()) {
    if(do.pdf){
      system(paste('pandoc', tocstr, '-V geometry:margin=1.5cm -o',
                   paste(filename, '.pdf', sep=""),
                   paste(filename, '.md', sep="")))
      system(paste('evince ', filename, '.pdf', sep=""), wait=FALSE)
    }else{
      browseURL(paste(filename, ".html", sep=""))
    }
  }  
}
