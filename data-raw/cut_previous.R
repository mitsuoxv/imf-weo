library(tidyverse)

load("data/weo_2010.rda")

weo_2010_cut_data <- weo_2010$data %>% 
  filter(year >= 2019)

usethis::use_data(weo_2010_cut_data)
