library(tidyverse)

load("data-old/data_2010.rda")

data_2010_cut <- data_2010 %>% 
  filter(year >= 2019)

usethis::use_data(data_2010_cut)
