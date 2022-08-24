library(purrr)

test <- list(first = c("a", "b", "c", "d", "e", "f", "g", "h"),
             second = c("f", "g", "h", "i", "j", "k", "l", "m"),
             third = c("m", "n", "o", "p", "q", "r", "s", "t"))

todrop <- c("g", "l", "m")

out <- purrr::map(test, ~ discard(.x, ~ .x %in% todrop))
out

L <- list(emt = c("", ""))


x <- list(c("", "alteryx", "confirme", "", "", "", "ans", "", ""))


l <- list(c(1:3), "foo", character(0), integer(0))
library(purrr)


purrr::compact(emtstr$emt)

Filter(length, emtstr)

emtstr[emtstr != ""]

L[L != ""]

cc <- lapply(L, function(x) x[!x %in% ""])

L2 <- purrr::map(L, ~ purrr::discard(.x, ~ .x %in% ""))
L2
