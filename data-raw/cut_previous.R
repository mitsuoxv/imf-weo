library(tidyverse)

load("data-old/data_2410.rda")

data_2410_cut <- data_2410 %>% 
  filter(year >= 2021)

usethis::use_data(data_2410_cut)
