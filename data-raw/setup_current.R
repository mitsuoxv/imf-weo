# Libraries
library(tidyverse)
library(janitor)

# Download from IMF World Economic Outlook Database
# https://data.imf.org/en/datasets/IMF.RES:WEO
# full dataset, CSV, Observation per row
# ID and Name
# Country, Indicator, Frequency, Scale, Unit of Measure, Methodology notes,
# Latest Actual Annual Data, Base year

csv_file <- "downloads/dataset_2025-10-16T05_59_25.533931356Z_DEFAULT_INTEGRATION_IMF.RES_WEO_9.0.0.csv"

csv_raw <- read_csv(csv_file) |> 
  clean_names()

csv_df <- csv_raw |>
  select(
    unit = unit_id,
    base_year,
    ref_area = country_id,
    freq = frequency_id,
    lastactualdate = latest_actual_annual_data,
    scale = scale_id,
    notes = methodology_notes,
    concept = indicator_id,
    year = time_period,
    value = obs_value
  )

# make sure no NAs in scale
csv_df |> 
  count(scale, sort = TRUE) # a few NAs

concept_scale <- csv_df |> # guess scale from concept
  filter(ref_area == "JPN") |> 
  select(concept, scale_jp = scale) |> 
  distinct(concept, .keep_all = TRUE)

csv_df <- csv_df |> 
  left_join(concept_scale, by = "concept") |> 
  mutate(scale = if_else(is.na(scale), scale_jp, scale)) |> 
  select(!scale_jp)

# from raw value to scaled value
csv_df <- csv_df |> 
  filter(!is.na(value)) |> 
  mutate(
    value = value / as.numeric(paste0("1e", scale))
  )

# make sure no NAs in unit
csv_df |> 
  count(unit, sort = TRUE) # lots of NAs

csv_df <- csv_df |> # fill character "na"
  mutate(unit = if_else(is.na(unit), "na", unit))

# set up menus
# area
area_df <- csv_raw |> 
  distinct(country_id, country) |> 
  arrange(country_id) |> 
  rename(
    code = country_id,
    area = country
  )

world_df <- area_df |> 
  filter(area == "World")

world_menu <- world_df$code
names(world_menu) <- world_df$area

region_df <- area_df |> 
  filter(str_count(code) > 3, area != "World")

region_menu <- region_df$code
names(region_menu) <- region_df$area

country_df <- area_df |> 
  filter(str_count(code) <= 3) |> 
  arrange(area)

country_menu <- country_df$code
names(country_menu) <- country_df$area

area_menu <- c(world_menu, region_menu, country_menu)

# concept
concept_df <- csv_raw |> 
  distinct(indicator_id, indicator) |> 
  arrange(indicator_id)

level1 <- csv_df  |> 
  count(concept) |>
  filter(n > 1000)

concept1 <- concept_df |>
  semi_join(level1, by = c(indicator_id = "concept"))

concept1_menu <- split(concept1$indicator_id, concept1$indicator)

region_only <- csv_df |>
  filter(!is.na(value)) |>
  filter(ref_area %in% region_menu) |>
  semi_join(level1, by = "concept") |>
  distinct(concept)

concept2 <- concept_df |>
  semi_join(region_only, by = c(indicator_id = "concept"))

concept2_menu <- split(concept2$indicator_id, concept2$indicator)

concept3 <- concept_df |>
  anti_join(level1, by = c(indicator_id = "concept")) |> 
  anti_join(region_only, by = c(indicator_id = "concept"))

concept3_menu <- split(concept3$indicator_id, concept3$indicator)

concept_vec <- concept_df$indicator_id
names(concept_vec) <- concept_df$indicator

# unit
unit_df <- csv_raw |> 
  mutate(
    unit_id = if_else(is.na(unit_id), "na", unit_id),
    unit = if_else(is.na(unit), "", unit)
  ) |> 
  distinct(unit_id, unit) |> 
  arrange(unit_id)

units <- unit_df$unit_id
names(units) <- unit_df$unit

# scale
scale_df <- csv_raw |> 
  filter(!is.na(scale_id)) |> 
  distinct(scale_id, scale) |> 
  arrange(scale_id) |> 
  mutate(scale = if_else(scale == "Units", "", scale))

scales <- scale_df$scale_id
names(scales) <- scale_df$scale

# make a list
data_2510 <- csv_df

menu <- list(
  a_menu = list(
    area = area_menu,
    region = region_menu,
    world = world_menu
  ),
  c_menu = list(
    area = concept1_menu, 
    region = concept2_menu,
    world = concept3_menu
  )
)

meta <- list(
  area = area_df,
  concept = concept_vec,
  unit = units,
  scale = scales
)

# save
usethis::use_data(data_2510, menu, meta, overwrite = TRUE)



# Transition from 2504 to 2510
# Download old meta data
# https://www.imf.org/en/Publications/WEO/weo-database/2025/april/download-entire-database
meta_file <- "downloads/WEOPUB_DSD_APR2025.xlsx"

sheets <- readxl::excel_sheets(meta_file)

meta_list <- vector("list", length(sheets))

for (i in seq_along(sheets)) {
  meta_list[[i]] <- readxl::read_excel(meta_file, skip = 7, sheet = sheets[[i]])
}

meta_list[[3]] <- meta_list[[3]] |> 
  clean_names()

# area
meta_list[[3]] |> 
  arrange(description) |> View()

area_df |> 
  arrange(area) |> View() # LIE

old_new_ref_area_df <- bind_cols(
  meta_list[[3]] |> 
    arrange(description) |> 
    rename(ref_area = code),
  area_df |> 
    arrange(area) |> 
    filter(code != "LIE") |> 
    rename(ref_area_new = code)
) |> 
  select(ref_area, ref_area_new)

write_csv(old_new_ref_area_df, file = "data-raw/old_new_ref_area.csv")
