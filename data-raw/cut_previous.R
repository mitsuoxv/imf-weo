library(tidyverse)

load("data-old/data_2104.rda")

data_2104_cut <- data_2104 %>% 
  filter(year >= 2019)

usethis::use_data(data_2104_cut)
