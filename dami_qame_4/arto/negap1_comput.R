negap1 <- list()

data("Groceries")

## add a complement-items for "whole milk" and "other vegetables"
g2 <- addComplement(Groceries, c("whole milk", "other vegetables"))
negap1$g2  <- g2 


negap1$outme1 <- function(){
  inspect(head(g2, 3))
}