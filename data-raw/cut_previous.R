library(tidyverse)

load("data-old/data_2404.rda")

data_2404_cut <- data_2404 %>% 
  filter(year >= 2020)

usethis::use_data(data_2404_cut)
