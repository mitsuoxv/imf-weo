library(tidyverse)

load("data-old/data_2204.rda")

data_2204_cut <- data_2204 %>% 
  filter(year >= 2019)

usethis::use_data(data_2204_cut)
