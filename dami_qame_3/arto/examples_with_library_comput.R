arto1 <- list()

parameter <- list(support = 0.05, maxsize=1, maxlen=999, mingap=1, maxgap=999, maxwin=999)
s1 <- cspade(courses.str, parameter = parameter)
r1 <- ruleInduction(s1, confidence=0.5)
arto1$s1 <- s1
arto1$r1 <- r1

arto1$outme1 <- function(){
  print(as(head(sort(r1, by="lift"), n=20), "data.frame"))
}

# R CMD Sweave dami_qame_3_slides_1.Rnw && pdflatex dami_qame_3_slides_1.tex