# example_comput.R

set.seed(123)
example1 <- vector("list")
example1$x  <- rnorm(100)
example1$y  <- rnorm(100, example1$x)

example1$plotme1  <- function(){
  plot(example1$x, example1$y, col=mycolors)
  abline(v=0, h=0, lty=2)
}

example1$plotme2  <- function(){
  plot(example1$y, example1$x)
  abline(v=0, h=0, lty=2)
}