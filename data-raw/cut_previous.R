library(tidyverse)

load("data-old/data_2210.rda")

data_2210_cut <- data_2210 %>% 
  filter(year >= 2019)

usethis::use_data(data_2210_cut)
