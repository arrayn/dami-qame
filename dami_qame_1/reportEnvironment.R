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

build.report <- function(chosen.parts=c(2), do.pdf=FALSE){
  r <- c('dami_qame_1',
         '===========')
#          '### Contents:',
#          '1. Summary',
#          '2. Init',
#          '3. Explore the data',
#          '4. Reference frequent itemsets',
#          '5. Arto Nissinen',
#          '6. Eric Andrews',
#          '7. Mirva Toivonen',
#          '8. Quan Nguyen',)
  if(1 %in% chosen.parts) r <- c(r, readLines('part1_summary.Rmd'))
  if(2 %in% chosen.parts) r <- c(r, readLines('part2_init.Rmd'))
  if(3 %in% chosen.parts) r <- c(r, readLines('part3_explore.Rmd'))
  if(4 %in% chosen.parts) r <- c(r, readLines('part4_reference.Rmd'))
  if(5 %in% chosen.parts) r <- c(r, readLines('part5_arto.Rmd'))
  if(6 %in% chosen.parts) r <- c(r, readLines('part6_eric.Rmd'))
  if(7 %in% chosen.parts) r <- c(r, readLines('part7_mirva.Rmd'))
  if(8 %in% chosen.parts) r <- c(r, readLines('part8_quan.Rmd'))
  cat(r, file='dami_qame_1.Rmd', sep="\n")
  knit2html('dami_qame_1.Rmd')
  if(interactive()) {
    if(do.pdf){
      system('pandoc --toc -V geometry:margin=1.5cm -o dami_qame_1.pdf dami_qame_1.md')
      system('evince dami_qame_1.pdf', wait=FALSE)
    }else{
      browseURL('dami_qame_1.html')
    }
  }
  
}
