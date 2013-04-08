
```
## Error: there is no package called 'RColorBrewer'
```

```
## Error: could not find function "sourceCpp"
```

```
## Error: could not find function "read.transactions"
```

```
## Error: could not find function "read.transactions"
```

```
## Error: object 'courses.tr' not found
```

```
## Error: object 'courses.tidlists' not found
```

```
## Error: could not find function "ReadInData"
```

```
## Error: could not find function "convert.item.ids.to.names"
```





Data Mining Problem 2 - QAME Group Report
=================================================
This problem 2 report submission consists of five different parts: this group report that is more results focused and the four individual reports (already turned in) that are more algorithm focused. Reader is welcome to read the individual reports for further details that are not repeated here.

We begin with group-learning related issues and then proceed to substance.

Group learning and self evaluation
----------------------------------

### Learning objectives for this problem
In addition to concept understanding goals (maximal and closed itemsets, association rules, interestingness measures and depth-first vs breadth-first algorithms) presented further in the research questions, we wanted to utilize the feedback and experience from previous problem to make our report more accessible. For example we used different finishing process to be able to make figures appear nearer the text that addresses them. We also stated our research goals more clearly. 

### Organizing studying, learning and working

We meet after lectures and organize our work face to face. We found it more effective to work face to face and discuss about learning goals, results and findings. We tried to divide focus areas so that we would have different algorithms implemented and we could compare them. However, estimating the difficulty level of different choices proved to be quite difficult. We could try to improve this work division and goal setting process.

We identified the rest of the chapter 6 from the course book as beneficial in order to reach our learning goals. After that group members studied and tried to implement their chosen algorithms mostly independently. After Monday’s lecture we started to produce the group report by each member developing mini-reports on particular subjects for others to see via git. Finally, we composed a coherent whole of these mini-reports. We found this approach satisfactory.

Different members of the group found different things difficult. We were able to teach each other something. We were also able to share some useful functions via github and improve on the work of others. These things helped us enjoy working as a group.

Research questions
------------------
We sought answers to the following questions.

* How does this data set compare to the previous one. Does it have the same
kind of problems (e.g. duplicates) as the last set? What can we infer from the
additional information?

* Effectiveness of depth-first vs. breadth-first approaches to mining frequent
itemsets, or in a nutshell: which one is faster, Apriori or Eclat?

* How much worse (or better) our implementations of the algorithms perform
compared to the "arules" R library's implementations?

* How many of the mined frequent itemsets turn out to be closed, how many
were maximal?

* How do the results of different interestingness measures compare?


Exploratory analysis
--------------------

### Most frequent courses
Below are outlined the most frequent courses (support greater than 0.08).


```
## Error: object 'courses.tr' not found
```

```
## Error: object 'lab' not found
```

```
## Error: object 'temp' not found
```

```
## Error: could not find function "itemFrequencyPlot"
```



### Skewness of support distribution


```
## Error: could not find function "itemFrequency"
```

```
## Error: object 'item.freqs' not found
```

```
## Error: object 'item.freqs' not found
```


Above is plotted the support of each item in increasing order of support.
Notice that the x-axis is not the TID but rather the rank of the item in the
ordering.  Out of all 

```

Error in eval(expr, envir, enclos) : object 'item.freqs' not found

```

 items, 

```

Error in eval(expr, envir, enclos) : object 'item.freqs' not found

```


have a support lower than 1%, 

```

Error in eval(expr, envir, enclos) : object 'item.freqs' not found

```

 items have a support
higher than 10%. Highest support is 

```

Error in tail(item.freqs, n = 1) : object 'item.freqs' not found

```

.

Whether this skewness is a problem or not is hard to say without experience.
Visually this seems very worrying, but on the other hand the example given in
the book (p. 386) is much worse.

### Missing course details
Some item ids in `courses_num.txt` don't have an entry in the file
`courses_details.txt`. This means that we don't have any name, year or other
details about these courses. The following item ids have no course details:


```
## Error: could not find function "itemLabels"
```

```
## Error: object 'item.ids' not found
```

```
## Error: object 'item.ids' not found
```


So about 

```

Error in eval(expr, envir, enclos) : object 'item.ids' not found

```

 of all items have no
name associated with them.

### Duplicate items
While last week only a couple of transactions had duplicate items, this week
more than half of the transactions have duplicate items.
The following is a distribution of duplicates in transactions:


```
## 
##    0    1    2    3    4    5    6    7    8    9   10   11   12   13   14 
## 4022 1244  675  487  329  254  210  188  129  109   99   80   73   64   65 
##   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29 
##   49   39   37   37   38   25   26   27   12   14   15   11   18    9   12 
##   30   31   32   33   34   35   36   37   38   39   40   41   43   44   45 
##    9    2    6    2    3    3    4    4    4    3    4    1    3    1    2 
##   47   48   49   50   54   55   61   66   70   75  158 
##    1    2    2    2    2    1    2    2    1    1    1
```


So 4022 transactions have no (0) duplicates, 1244 transactions have
one duplicate, 675 have two duplicates and so on.

An extreme case of this is transaction #846 which contains 158 duplicates. This
may just be an data entry error. Alternatively, this could be an actual student
who has a very unique approach to taking courses. E.g. he or she signs up for
several courses during periods and attends only those that interest him/her.
Below is the full list of courses this student enrolled to.


```
## Transaction / Line number 846
```

```
##   [1] "5"   "31"  "35"  "44"  "52"  "52"  "52"  "52"  "52"  "52"  "52" 
##  [12] "61"  "72"  "72"  "72"  "75"  "75"  "77"  "77"  "77"  "77"  "77" 
##  [23] "77"  "77"  "77"  "80"  "80"  "80"  "80"  "80"  "80"  "80"  "80" 
##  [34] "80"  "83"  "83"  "84"  "84"  "84"  "85"  "86"  "86"  "86"  "86" 
##  [45] "86"  "86"  "87"  "89"  "89"  "89"  "89"  "89"  "89"  "89"  "89" 
##  [56] "89"  "89"  "89"  "89"  "89"  "89"  "91"  "91"  "91"  "91"  "91" 
##  [67] "91"  "91"  "91"  "91"  "91"  "91"  "91"  "91"  "91"  "91"  "91" 
##  [78] "92"  "92"  "92"  "92"  "92"  "92"  "92"  "92"  "92"  "92"  "92" 
##  [89] "93"  "93"  "93"  "93"  "93"  "93"  "94"  "94"  "94"  "98"  "98" 
## [100] "98"  "98"  "98"  "98"  "98"  "98"  "98"  "98"  "98"  "99"  "99" 
## [111] "101" "103" "108" "108" "108" "109" "109" "109" "131" "193" "193"
## [122] "193" "193" "193" "194" "201" "206" "206" "206" "206" "206" "206"
## [133] "206" "206" "206" "206" "206" "206" "208" "208" "208" "208" "208"
## [144] "208" "208" "265" "265" "265" "265" "265" "265" "265" "265" "267"
## [155] "267" "267" "267" "267" "279" "279" "279" "279" "279" "279" "303"
## [166] "303" "303" "303" "303" "307" "307" "307" "307" "339" "339" "339"
## [177] "339" "339" "339" "339" "339" "339" "347" "347" "347" "347" "347"
## [188] "348" "362" "396" "398" "402" "402" "402" "402" "402" "402" "402"
## [199] "402" "402" "402" "402"
```

```
## Number of duplicates 158
```


### Number of students enrolled vs. years taught


```
## Error: object 'years.held' not found
```

```
## Error: could not find function "itemFrequency"
```

```
## Error: object 'total.years' not found
```

```
## Error: object 'res' not found
```

```
## Error: object 'item.freqs' not found
```

```
## Error: object 'xs' not found
```

```
## Error: object 'ys' not found
```

```
## Error: object 'xs' not found
```


From the additional data file we could find the specific years a course has
been held and thus infer the total number of years it has been held. Note here
that we're assuming that all relevant years are reported in the additional data.
This is most likely a naive belief, especially given the quality of the data
so far, nevertheless it's a useful approximation.

From the plot above, we can see that the total years a course has been held
definitely impacts the number of students who have enrolled to it. But this
doesn't automatically imply that the number of enrollments will be high, rather
it is just a precondition for it to be possible.

Algorithm related findings
--------------------------


### Comparison of depth-first vs breadth-first
From the plot below we can see that depth first counts supports from data to more itemsets but seems to runs faster anyway. We think that support-counting from TID-lists is just so much faster than from "horizontal" data. 

We were also thinking that maybe depth-first search would benefit from ordering the items in increasing order of frequency. This is because the more right we are on the search tree the less supersets we have to check. And maybe the ordering would make the tree more right-weighted. 


```
## Error: object 'courses.tr.old' not found
```

```
## Error: 'data' must be of a vector type
```



```r
barplot(tim, beside = TRUE, log = "y", ylab = "runtime (seconds)", main = "Runnning times")
```

```
## Error: log scale error: at least one 'height + offset' value <= 0
```


Running times of different algorithm implementations are shown above. For each
of the four cases, the first two bars corresponds to support thresholds of 0.23
and 0.15 on last week's data, while the last two bars corresponds to
thresholds 0.12 and 0.08 on this week's data.



### Number of non-closed itemsets and data density

#### Density difference between old and new data set visualization
Old datasets density, 0.130863, is much bigger than the new dataset's density, 0.02010921. The visualizations below are samples from the beginning of data-matrix sorted in a such way that the most frequent courses are at the left and the students who took the most courses are at the top. 


```
## Error: object 'courses.tr.old' not found
```



```
## Error: object 'courses.tr' not found
```


#### Frequent, closed and maximal itemsets and 1-rules
In the new dataset we observe that almost all of the frequent itemsets are also closed itemsets. This is indicated by the fact that the "frequent"-line and "closed"-line are almost overlapping in the plot below. Threshold has to be set to 0.08 to get at least some non-closed frequent itemsets. Even setting the threshold to 0.04 does not yield many non-closed itemsets, as we can see from the plot below (note that in the plot the rules include only rules that have consequents of size 1). 

The old dataset on comparison had much more non-closed itemsets as we can see from the plots. We thought that this could be related to the fact that old datasets density, 0.130863, is much bigger than the new dataset's density, 0.02010921. 


```
## Error: could not find function "eclat"
```

```
## Error: object 'bm' not found
```

```
## Error: could not find function "eclat"
```

```
## Error: object 'bm' not found
```

```
## Error: could not find function "eclat"
```

```
## Error: object 'bm' not found
```

```
## Error: could not find function "eclat"
```

```
## Error: object 'bm' not found
```



### Interestingness measures comparison

#### Non-closed frequent itemsets and rule-confidence=1 relation
With support threshold=0.08 we get 6 itemsets that are not closed frequent. These itemsets are exactly the rule antecedents (left hand sides, LHS) of the only 1-consequent-rules that have confidence of 1 as we can see from output below. This means unioning these LHS with the rule consequent (right hand sides, RHS), item 80 (data_structures) in this case, we get itemsets whose supports are exactly the same as LHS alone. Therefore these LHS+RHS union itemsets are closed itemsets that close over their respective LHS-part (which are not closed themselves).

Also, Items 131 (introduction_to_the_use_of_computers), 194 (data_structures_project) and 83 (introduction_to_programming) appear in all of those 6 itemsets. But a rule {131,194,83} => {80} has a confidence of 0.9973118. This means that the itemset {131,194,83} have slightly higher support than the combined itemset {131,194,83,80}. Also, by knowing that {131,194,83} is not a closed itemset, we could immediately say that all of it's supersets must have lower support than it.

Another interesting question is why are the lifts the same?


```r
bm <- myget.allbm(courses.tr, 0.08, minconfidence)
```

```
## Error: could not find function "eclat"
```

```r
as(setdiff(bm$fisets, bm$closed), "data.frame")
```

```
## Error: object 'bm' not found
```

```r
as(head(sort(bm$rules, by = "confidence"), n = 30), "data.frame")
```

```
## Error: object 'bm' not found
```

```r
inspect(head(mynamify(sort(bm$rules, by = "confidence"), lab), n = 1))
```

```
## Error: could not find function "inspect"
```



#### Top ranked by allconfidence vs lift
Definition: "allConfidence (see, Omiencinski, 2003) is defined on itemsets as the minimum confidence of all possible rule generated from the itemset." [arules vignette]. In other words, these items tend to appear together. Lift is P(R|L)/P(R). These two seem to give quite similar intuition, at least in this run.


```
## Error: object 'bm' not found
```

```
## Error: could not find function "interestMeasure"
```

```
## Error: could not find function "quality"
```

```
## Error: could not find function "items"
```

```
## Error: could not find function "quality"
```

```
## Error: object of type 'closure' is not subsettable
```

```
## Error: object 'ex' not found
```

```
## Error: object 'fisets' not found
```

```
## Error: object 'bm' not found
```



```r
inspect(top.allConfidence)
```

```
## Error: could not find function "inspect"
```

```r
inspect(mynamify(head(sort(bm$rules, by = "lift"), n = 8), lab))
```

```
## Error: could not find function "inspect"
```


### Other observations
For most of the experiments with Apriori we used a support threshold of 0.08
because that yielded at least some non-closed itemsets which could be analyzed
further.  However setting the threshold this low, especially with this data
set, caused us some problems with performance.
