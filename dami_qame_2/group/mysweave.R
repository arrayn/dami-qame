### COPY TO THE BEGINNING OF EACH CHILD DOCUMENT:
# % !Rnw root = ../reports/dami_qame_2_sweaved.Rnw

if(basename(getwd())!="reports") stop(paste("STOPPED! Directory is not reports:", getwd()))
if(!file.exists("figure")) dir.create("figure")
options(SweaveHooks=list(fig=function() par(mar=c(4,4,2,0.1))))
options(width=60) # 48
library(xtable)
options(xtable.table.placement="H", xtable.scalebox=0.8, xtable.booktabs=T)
library('RColorBrewer')
mycolors <- brewer.pal(8, "Dark2")
mycolors.a20  <- paste(mycolors,"33",sep="")

### ADDITIONS TO MAIN DOCUMENT:

# % MY ADDITIONS BEFORE \begin{document}
# \usepackage[top=1.5cm, bottom=2.0cm, left=1.5cm, right=1.5cm]{geometry}
# \usepackage{float}
# \usepackage[hypcap]{caption}
# \usepackage[hidelinks]{hyperref}
# \usepackage{multicol}
# 
# \begin{document}
# 
# \SweaveOpts{concordance=TRUE, echo=FALSE, results=tex, prefix.string=figure/fig, width=5, height=3}
# \DefineVerbatimEnvironment{Soutput}{Verbatim}{fontsize=\scriptsize, fontshape=n}
# \setkeys{Gin}{width=1.00\linewidth}
# <<myinit, echo=FALSE>>=
#   source("../group/mysweave.R")
# @
# % MY ADDITIONS END
