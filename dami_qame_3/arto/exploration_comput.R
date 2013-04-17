exploration <- list()

exploration$plotme1 <- function(){
  barplot(table(size(courses.str)), main="How many courses in one student's semester", xlab="course count", ylab="semester occurrences")
}


