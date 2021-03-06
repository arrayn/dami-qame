
# setwd("~/atlinks/dami-qame/dami_qame_3/reports")
library('arulesSequences')
# library("Rcpp")
# Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
source('../arto/data_loading.R')
mypaths <- list(
  saves.dir = "saves",
  reformatted.data = "saves/reformatted_courses_sequences_num.txt",
  courses.str = "saves/courses.str.saved")

reformat_data_if_not_done_yet(mypaths)
if(file.exists(mypaths$courses.str)){
  load(mypaths$courses.str)
}else{
  courses.str <- read_baskets(con = mypaths$reformatted.data, info = c("sequenceID","eventID","SIZE"))
  save(courses.str, file=mypaths$courses.str)
}

# lab <- convert.item.ids.to.names(itemLabels(courses.tr), item.id.to.course.name)
