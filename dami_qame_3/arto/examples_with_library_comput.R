
str(courses.str)
summary(courses.str)
as(x, "data.frame")
s1 <- cspade(courses.str, parameter = list(support = 0.08), control = list(verbose = TRUE))
s2 <- cspade(courses.str, parameter = list(support = 0.08, maxsize=1), control = list(verbose = TRUE))
s3 <- cspade(courses.str, parameter = list(support = 0.08, maxsize=1, mingap=1, maxgap=1), control = list(verbose = TRUE))
s4 <- cspade(courses.str, parameter = list(support = 0.08, maxwin=5), control = list(verbose = TRUE))
s1
s2
s3
s4
summary(s2)
as(s2, "data.frame")
summary(s3)
as(s3, "data.frame")

s1
as(head(sort(s1, by="support"), n=500), "data.frame")
size(s1)

# R CMD Sweave dami_qame_3_slides_1.Rnw && pdflatex dami_qame_3_slides_1.tex