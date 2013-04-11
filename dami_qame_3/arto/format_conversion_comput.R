format_conversion.list <- vector("list")

format_conversion.list$out_orig <- function(){
  cat(readLines("../data/courses_sequences_num.txt", n=6), sep="\n")
}

format_conversion.list$out_reformatted <- function(){
  cat(readLines(mypaths$reformatted.data, n=10), sep="\n")
}

format_conversion.list$out_reformatted_inspected <- function(){
  inspect(head(courses.str, n=10))
}