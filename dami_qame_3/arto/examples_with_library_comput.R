arto1 <- list()

parameter <- list(support = 0.09, maxsize=1, maxlen=999, mingap=1, maxgap=999, maxwin=999)
s1 <- cspade(courses.str, parameter = parameter)
s1
as(head(sort(s1, by="support"), n=500), "data.frame")

r1 <- ruleInduction(s1, confidence=0.5)
r1


# R CMD Sweave dami_qame_3_slides_1.Rnw && pdflatex dami_qame_3_slides_1.tex