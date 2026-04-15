library(tidyverse)

load("data-old/data_2510.rda")

data_2510_cut <- data_2510 |> 
  filter(year >= 2022)

usethis::use_data(data_2510_cut, overwrite = TRUE)
