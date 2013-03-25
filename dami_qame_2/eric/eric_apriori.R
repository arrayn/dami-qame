source("eric/occurrence_matrix.R")

eric.apriori <- function(occurrence.mat, min.support=0.1, min.confidence=0.7) {
    fis <- frequent.itemset.generation(occurrence.mat, min.support)
    if (length(fis) > 1) {
        return(rule.generation(fis, min.confidence))
    } else {
        return(NULL)
    }
}

rule.generation <- function(freq.itemsets.and.counts, min.confidence=0.7) {
    k <- length(freq.itemsets.and.counts)
    if (k == 1) return(NULL)
    rules.and.counts <- NULL
    item.counter <- 1

    lapply(2:k, function(i) {
        itemsets.and.counts <- freq.itemsets.and.counts[[i]]
        num.of.itemsets <- nrow(itemsets.and.counts$itemsets)


        for (j in 1:num.of.itemsets) {
            rules <- gen.rules(itemsets.and.counts$itemsets[j, ])
            confs <- evaluate.confs(rules, freq.itemsets.and.counts)
            which.are.above.threshold <- confs >= min.confidence

            if (any(which.are.above.threshold)) {
                rules <- rules[which.are.above.threshold]
                confs <- confs[which.are.above.threshold]

                for (d in 1:length(rules)) {
                    rule <- rules[[d]]
                    rule$confidence <- confs[d]
                    rules.and.counts[[item.counter]] <<- rule
                    item.counter <<- item.counter + 1
                }
            }
        }

    })

    class(rules.and.counts) <- "rule.set"
    return(rules.and.counts)
}

print.rule.set <- function(rules.and.counts, convert.name.func=identity) {
    n <- length(rules.and.counts)
    lhs <- sapply(rules.and.counts, function(r) {
        paste("{", paste(convert.name.func(r$lhs), collapse=", "), "}")
    })
    rhs <- sapply(rules.and.counts, function(r) {
         paste("{", paste(convert.name.func(r$rhs), collapse=", "), "}")
    })
    confs <- sapply(rules.and.counts, function(r) r$confidence)
    df <- data.frame(lhs, rhs, confs)
    df <- df[order(df["confs"], decreasing=T),]
    apply(df, 1, function(row) {
        cat(row["lhs"], "=>\n", row["rhs"], row["confs"], "\n\n")
    })
    cat(n, "items\n")
}

# Generate all rules for given itemset
gen.rules <- function(itemset) {
    num.of.items <- length(itemset)
    rules <- list()
    item.counter <- 1

    for (num.items.in.consequent in 1:(num.of.items-1)) {
        consequents <- combn(1:num.of.items, num.items.in.consequent)
        apply(consequents, 2, function(consequent) {
            antecedent <- (1:num.of.items)[-consequent]
            rule <- list(lhs=itemset[antecedent], rhs=itemset[consequent])
            rules[[item.counter]] <<- rule
            item.counter <<- item.counter + 1
        })
    }

    return(rules)
}

evaluate.confs <- function(rules, freq.itemsets.and.counts) {
    f <- function(rule) { evaluate.confidence(rule, freq.itemsets.and.counts) }
    sapply(rules, f)
}

evaluate.confidence <- function(rule, freq.itemsets.and.counts) {
    support.of.antecedent <- find.support.count.for.set(rule$lhs, freq.itemsets.and.counts)
    support.of.all <- find.support.count.for.set(sort(c(rule$lhs, rule$rhs)),
                                                        freq.itemsets.and.counts)
    support.of.all / support.of.antecedent
}

find.support.count.for.set <- function(set, freq.itemsets.and.counts) {
    set.len <- length(set)
    itemsets <- freq.itemsets.and.counts[[set.len]]$itemsets
    index <- which(apply(itemsets, 1, function(row) all(row == set) ))

    stopifnot(length(index) == 1) # should not be zero, since all subsets have to be frequent

    freq.itemsets.and.counts[[set.len]]$support.counts[index]
}

# To read the lines from "course_text" use readLines("course_text.txt")
frequent.itemset.generation <- function(occurrence.mat, min.support=0.4) {

    k <- 1
    freq.itemsets.and.counts <- list()
    min.support.count <- min.support * num.of.transactions(occurrence.mat)

    # Find frequent 1-itemsets.
    freq.itemsets.and.counts[[1]] <- find.frequent.1itemsets(occurrence.mat,
                                                             min.support.count)

    # Find frequent k-itemsets
    while (k == length(freq.itemsets.and.counts)) {
        k <- k + 1

        candidates <- apriori.gen(occurrence.mat,
                                  freq.itemsets.and.counts[[k-1]]$itemsets, k)

        itemsets <- NULL
        support.counts <- NULL
        if (!is.null(candidates)) {
            for (i in 1:nrow(candidates)) {
                candidate <- candidates[i, ]
                candidate.support.count <- support.count(occurrence.mat, candidate)
                if (candidate.support.count >= min.support.count) {
                    itemsets <- rbind(itemsets, candidate, deparse.level=0)
                    support.counts <- c(support.counts, candidate.support.count)
                }
            }
        }
        stopifnot(nrow(itemsets) == length(support.counts)) # invariant

        if (!is.null(itemsets)) {
            freq.itemsets.and.counts[[k]] <-
                list(itemsets=itemsets, support.counts=support.counts)
        }
    }
    return(freq.itemsets.and.counts)
}

find.frequent.1itemsets <- function(occurrence.mat, min.support.count) {
    item.support.counts <- colSums(occurrence.mat)
    which.are.frequent <- item.support.counts >= min.support.count
    freq.items <- names(item.support.counts)[which.are.frequent]
    freq.counts <- item.support.counts[which.are.frequent]

    lexicographical.order <- order(freq.items)
    freq.items <- freq.items[lexicographical.order]
    freq.counts <- freq.counts[lexicographical.order]
    names(freq.counts) <- NULL

    if (length(freq.items) == 0) {
        return(NULL)
    } else {
        return(list(itemsets=matrix(freq.items, ncol=1), support.counts=freq.counts))
    }
}

apriori.gen <- function(occurrence.mat, prev.freq.itemsets, k) {
    prev.num.itemsets <- nrow(prev.freq.itemsets)
    if (prev.num.itemsets == 1) { return(NULL) }

    new.candidates <- NULL

    for (i in 1:(prev.num.itemsets-1)) {
        first.prefix <- prev.freq.itemsets[i, -(k-1)]
        for (j in (i+1):prev.num.itemsets) {
            second.prefix <- prev.freq.itemsets[j, -(k-1)]
            if (!all(first.prefix == second.prefix)) break
            new.candidate <- c(prev.freq.itemsets[i,], prev.freq.itemsets[j,k-1])
            new.candidates <- rbind(new.candidates, new.candidate, deparse.level=0)
        }
    }
    return(new.candidates)
}

maximal.frequent.itemsets <- function(freq.itemsets.and.counts) {
    results <- list()
    index <- 1
    max.size <- length(freq.itemsets.and.counts)
    for (i in 1:(max.size-1)) {
        current.sets <- freq.itemsets.and.counts[[i]]$itemsets
        parent.sets <- freq.itemsets.and.counts[[i+1]]$itemsets
        for (k in 1:nrow(current.sets)) {
            cur.set <- current.sets[k, ]
            if (!any(apply(parent.sets, 1, function(row) all(cur.set %in% row)))) {
                results[[index]] <- cur.set
                index <- index + 1
            }
        }
    }
    apply(freq.itemsets.and.counts[[max.size]]$itemsets, 1, function(row) {
        results[[index]] <<- row
        index <<- index + 1
    })
    return(results)
}

# Main method
#vector.of.strings <- readLines("course-text.txt")
#occ <- occurrence.matrix(vector.of.strings)
