library(tidyverse)

load("data-old/data_2304.rda")

data_2304_cut <- data_2304 %>% 
  filter(year >= 2019)

usethis::use_data(data_2304_cut)
