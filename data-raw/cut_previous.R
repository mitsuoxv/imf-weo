library(tidyverse)

load("data-old/data_2110.rda")

data_2110_cut <- data_2110 %>% 
  filter(year >= 2019)

usethis::use_data(data_2110_cut)
