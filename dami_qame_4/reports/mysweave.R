# Working directory has to be "reports". To force intermediate files in one place.
mysweave <- vector("list")
if(basename(getwd())!="reports") stop(paste("STOPPED! Directory is not reports:", getwd()))
if(!file.exists("figure")) dir.create("figure")
options(SweaveHooks=list(fig=function() par(mar=c(4,4,2,0.1))))
options(width=60)
library(xtable)
options(xtable.table.placement="H", xtable.scalebox=0.8, xtable.booktabs=T)
library('RColorBrewer')
mysweave$colors <- brewer.pal(8, "Dark2")
mysweave$colors.a20  <- paste(mysweave$colors,"33",sep="")

# convenience function for cleaning up intermediate files
mysweave$clean.reports.dir <- function(){
  if(basename(getwd())!="reports") stop(paste("STOPPED! Directory is not reports:", getwd()))
  cat("Removing intermediate files in:", getwd(), "\n")  
  if(file.exists("figure")) {
    setwd("figure")
    l <- list.files(".")
    idx  <- grep("pdf$|tex$", l)
    for(f in l[idx]){cat("figure/", f, " ", file.remove(f), "\n" ,sep="")}
    setwd("..");
    cat("figure/", file.remove("figure"), "\n")
  }
  l <- list.files(".")
  idx  <- grep('bbl$|blg$|lof$|log$|lot$|nav$|snm$|synctex.gz$|tex$|toc$|vrb$', l)
  for(f in l[idx]){cat(f, " ", file.remove(f), "\n" ,sep="")}
  cat("Done removing intermediate files.")
}
