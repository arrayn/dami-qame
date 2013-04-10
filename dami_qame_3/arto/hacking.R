library(arulesSequences)
x <- readLines("~/R/x86_64-pc-linux-gnu-library/2.15/arulesSequences/misc/zaki.txt")
x
x <- read_baskets(con = system.file("misc", "zaki.txt", package = "arulesSequences"), 
                  info = c("sequenceID","eventID","SIZE"))
str(x)
summary(x)
as(x, "data.frame")
s1 <- cspade(x, parameter = list(support = 0.4), control = list(verbose = TRUE))
summary(s1)
as(s1, "data.frame")


# wikibook case
n <- read_baskets(con = system.file("misc", "test.txt", package = "arulesSequences"), 
                  info = c("sequenceID","eventID","SIZE"))
summary(n)
ptm=proc.time(); s1 <- cspade(n, parameter = list(support = 0.2), control = list(verbose = TRUE)); proc.time()-ptm
s1
as(head(sort(s1, by="support"), n=50), "data.frame")
