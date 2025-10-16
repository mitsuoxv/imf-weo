library(tidyverse)

load("data-old/data_2504.rda")

data_2504_cut <- data_2504 |> 
  filter(year >= 2021)

# Transition from 2504 to 2510
old_new_ref_area_df <- read_csv("data-raw/old_new_ref_area.csv")

data_2504_cut <- data_2504_cut |> 
  left_join(old_new_ref_area_df, by = "ref_area") |> 
  select(-ref_area) |> 
  rename(ref_area = ref_area_new)

usethis::use_data(data_2504_cut, overwrite = TRUE)
