reformat_data_if_not_done_yet  <- function(mypaths){
  if (file.exists(mypaths$reformatted.data)){return(NULL)}
  cat("STARTED: reformat_data_if_not_done_yet(mypaths)\n")
  pmt <- proc.time()
  # library(gsubfn)
  x <- readLines("../data/courses_sequences_num.txt")
  m <- length(x)
  y <- vector("character")
  event_strs.list <- regmatches(x, gregexpr("(?<=\\{\\s).*?(?=\\s\\})", x, perl=T))
  for(sid in 1L:m){
    # event_strs <- strapply(x[[sid]], "\\{\\s([^}]*)\\s\\}", c, simplify = c)
    # event_strs <- regmatches(x[[sid]], gregexpr("(?<=\\{\\s).*?(?=\\s\\})", x[[sid]], perl=T))[[1]] 
    event_strs <- event_strs.list[[sid]]
    # print(event_strs)
    for(eid in 1:length(event_strs)){
      temp <- strsplit(event_strs[[eid]], " ")[[1]]
      # print(temp)
      y <- c(y, paste(sid, eid, length(temp), event_strs[[eid]], sep=" "))
    }
  }
  if(!file.exists(mypaths$saves.dir)){dir.create(mypaths$saves.dir)}
  cat(y, file=mypaths$reformatted.data, sep="\n")
  print(proc.time()-pmt)
}