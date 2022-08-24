library(tidyverse)

set.seed(100)

airquality

bar_df <- data.frame(fruits = c("Apple", "Mango", "Orange", "Banana", "Pineapple"), 
                     price = c(360, 105, 25, 50, 120))
box_df <- data.frame(a = factor(1:5), b = c(10, 15, 25, 30, 40))

hist_df <- data.frame(
  sex = factor(rep("F", "M")),
  age = round(c(
    rnorm(200, mean = 55, sd = 5),
    rnorm(200, mean = 65, sd = 5)
  ))
)

bar_df %>%
  ggplot(aes(x = fruits, y = price)) +
  geom_col()


box_df %>% 
  ggplot(aes(x = a, b))+
  geom_boxplot()

hist_df %>%
  ggplot(aes(x = a)) +
  geom_histogram()

line_df <- bar_df

line_df %>%
  ggplot(aes(x = a, y = b)) +
  geom_line()
