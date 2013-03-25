item.id.to.course.name <- list()
years.held <- list()

ReadInData <- function() {
    for (line in readLines("courses_details.txt")) {
        parts <- strsplit(line, split="\t")[[1]]
        course.id <- parts[1]
        course.name <- parts[2]
        course.year <- as.integer(parts[3])
        item.id.to.course.name[[course.id]] <<- course.name

        years.held[[course.id]] <<- c(years.held[[course.id]], course.year)
    }
}

# Given an item id, returns the course name. E.g.
# GetNameForItem(195) == "information_systems_project"
GetNameForItem <- function(id) {
    if (length(item.id.to.course.name) == 0) {
        ReadInData()
    }

    return(item.id.to.course.name[[as.character(id)]])
}

# Given an item id, returns the years it was held (in no particular order).
# E.g. GetYearsForItem(195) == c(1995, 1996, 1996, 1996, 1997, ..., 1999 )
GetYearsForItem <- function(id) {
    if (length(item.id.to.course.name) == 0) {
        ReadInData()
    }

    return(years.held[[as.character(id)]])
}
