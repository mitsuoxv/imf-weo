library(tidyverse)

load("data-old/data_2604.rda")

data_2604_cut <- data_2604 |> 
  filter(year >= 2022)

usethis::use_data(data_2604_cut, overwrite = TRUE)
