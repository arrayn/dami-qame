build.report <- function(chosen.parts, filename="dami_qame_2", do.pdf=FALSE, toc=FALSE){
  if (toc) {tocstr <- "--toc"} else{tocstr <- ""}
  r <- ""
  if(1 %in% chosen.parts) r <- c(r, readLines('part1_groupreport.Rmd'))
  if(5 %in% chosen.parts) r <- c(r, readLines('part5_arto.Rmd'))
  if(6 %in% chosen.parts) r <- c(r, readLines('part6_eric.Rmd'))
  if(7 %in% chosen.parts) r <- c(r, readLines('part7_mirva.Rmd'))
  if(8 %in% chosen.parts) r <- c(r, readLines('part8_quan.Rmd'))
  if(15 %in% chosen.parts) r <- c(r, readLines('../arto/part15_arto_individual.Rmd'))
  if(16 %in% chosen.parts) r <- c(r, readLines('../eric/part16_eric_individual.Rmd'))
  if(17 %in% chosen.parts) r <- c(r, readLines('../mirva/part17_mirva_individual.Rmd'))
  if(18 %in% chosen.parts) r <- c(r, readLines('../quan/part18_quan_individual.Rmd'))
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
