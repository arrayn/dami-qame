arules.tr.to.occurrence.matrix <- function(courses.tr) {
    as(courses.tr, "matrix")
}

read.occurrence.matrix <- function(filename) {
    occurrence.matrix(readLines(filename))
}

# Given a vector of strings (where each string represents a transaction),
# create a matrix where each row represents a transaction and each column
# an item. The value of a row-column pair (TRUE or FALSE) indicates whether the
# item is present in the transaction.
occurrence.matrix <- function(vector.of.strings) {

    # Get itemset for each transaction (element) in vector.
    itemsets <- lapply(vector.of.strings, split.to.words)

    # Combine all items (words) into one big vector, remove duplicates.
    items <- unique(unlist(itemsets))

    # For each item, create an occurence column. At end combine to matrix.
    sapply(items, function(item) {
        sapply(itemsets, function(itemset) item %in% itemset)
    })
}

num.of.transactions <- function(occurrence.matrix) nrow(occurrence.matrix)

support.count <- function(occurrence.matrix, items) {
    # as.matrix for case where items consists of 1 item (the output is a
    # vector)
    res <- sum(apply(as.matrix(occurrence.matrix[,items]), 1, all))
}

get.items <- function(occurrence.matrix) colnames(occurrence.matrix)

# Split a string into a vector of words.
# E.g. words_from_str("i am mario") => c("i", "am", "mario")
split.to.words <- function(s) strsplit(s, split="\\s")[[1]]
