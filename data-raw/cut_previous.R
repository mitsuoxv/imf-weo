library(tidyverse)

load("data-old/data_2310.rda")

data_2310_cut <- data_2310 %>% 
  filter(year >= 2020)

usethis::use_data(data_2310_cut)
