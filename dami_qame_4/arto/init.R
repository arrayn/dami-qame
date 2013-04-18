# setwd("~/atlinks/dami-qame/dami_qame_4/reports")
library('arules')
mypaths <- list(saves.dir = "saves")

courses.tr <- read.transactions('../../dami_qame_2/courses_num.txt', rm.duplicates=TRUE)

# lab <- convert.item.ids.to.names(itemLabels(courses.tr), item.id.to.course.name)
