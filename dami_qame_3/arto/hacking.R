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


# format conversion
library(gsubfn)
x <- readLines("../data/courses_sequences_num.txt")
m <- length(x)
y <- vector("character")
for(sid in 1L:m){
  event_strs <- strapply(x[[sid]], "\\{\\s([^}]*)\\s\\}", c, simplify = c)
  # print(event_strs)
  for(eid in 1:length(event_strs)){
    temp <- strsplit(event_strs[[eid]], " ")[[1]]
    # print(temp)
    y <- c(y, paste(sid, eid, length(temp), event_strs[[eid]], sep=" "))
  }
}
if(!file.exists("saves")){dir.create("saves")}
cat(y, file=file.path("saves", "reformatted_courses_sequences_num.txt"), sep="\n")

# try reading in
x <- read_baskets(con = file.path("saves", "reformatted_courses_sequences_num.txt"), 
                  info = c("sequenceID","eventID","SIZE"))
str(x)
summary(x)
as(x, "data.frame")
s1 <- cspade(x, parameter = list(support = 0.1), control = list(verbose = TRUE))
summary(s1)
as(head(sort(s1, by="support"), n=20), "data.frame")