mat <- read.occurrence.matrix("courses_num.txt")


# Performance of frequent itemset generation
supports <- seq(0.4, 0.08, -0.02)

freq.itemsets <- NULL
index <- 1
itemset.gen.times <- sapply(supports, function(support) {
    times <- system.time(itemset <- frequent.itemset.generation(mat, support))
    freq.itemsets[[index]] <<- itemset
    index <<- index + 1
    times[1]
})

num.itemsets.per.param <- sapply(freq.itemsets, function(freq.itemset) {
    sum(sapply(freq.itemset, function(itemset) length(itemset$support.counts)))
})

# Performance of rule generation
rule.set.sizes <- NULL
index <- 1
ruleset.gen.times <- sapply(freq.itemsets, function(freq.itemset) {
    times <- system.time(rule.set <- rule.generation(freq.itemset, 0.7))
    rule.set.sizes[[index]] <<- length(rule.set)
    index <<- index + 1
    times[1]
})


# Number of rules
largest.freq.itemset <- freq.itemsets[[length(freq.itemsets)-1]]

confidences <- seq(0.8, 0.1, -0.02)

rule.sets <- NULL
index <- 1
sapply(confidences, function(confidence) {
    rule.set <- rule.generation(largest.freq.itemset, confidence)
    rule.sets[[index]] <<- rule.set
    index <<- index + 1
})

num.rules.per.param <- sapply(rule.sets, length)


plot(supports, itemset.gen.times, t="b",
     main="Effect of support threshold on performance",
     xlab="minimum support threshold",
     ylab="execution time (secs)", lwd=2)
lines(supports, ruleset.gen.times, lwd=2, col="purple", t="b")
legend(0.15,60, c("frequent itemset generation", "rule generation (minconf=0.7)"),
       lwd=2, col=c("black", "purple"))

par(ask=T)

plot(supports, rule.set.sizes, t="b",
     main="Effect of support threshold on number of frequent itemsets / rules",
     xlab="minimum support threshold",
     ylab="number of frequent itemsets / rules", lwd=2, col="purple")
lines(supports, num.itemsets.per.param, lwd=2, col="black", t="b")
legend(0.15,4500, c("frequent itemset generation", "rule generation (minconf=0.7)"),
       lwd=2, col=c("black", "purple"))

par(ask=T)

plot(confidences, num.rules.per.param, t="b",
     main="Effect of confidence threshold on number of rules",
     xlab="minimum confidence threshold",
     ylab="number of rules", lwd=2)


