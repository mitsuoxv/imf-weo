# Libraries
library(tidyverse)
library(janitor)

# Bulk download from IMF World Economic Outlook Database
# https://www.imf.org/en/Publications/WEO/weo-database/2021/October
sdmx_file <- "downloads/WEO_PUB_APR2022.xml"

sdmx <- rsdmx::readSDMX(sdmx_file, isURL = FALSE)

weo_raw <- as_tibble(sdmx)

# clean names
weo_df <- weo_raw %>% 
  clean_names()

# rename
weo_df <- weo_df %>% 
  rename(
    year = time_period,
    value = obs_value
  )

# clean types
weo_df <- type_convert(weo_df)

weo_df <- weo_df %>% 
  mutate(
    lastactualdate = parse_integer(lastactualdate, na = c("", "NA", "NULL", "0")),
    year = as.integer(year),
    value = parse_number(value, na = c("", "NA", "n/a", "--"))
    )

# Download meta data
# https://www.imf.org/en/Publications/WEO/weo-database/2021/October
meta_file <- "downloads/WEOApr2022-SDMX-DSD.xlsx"

sheets <- readxl::excel_sheets(meta_file)

meta_list <- vector("list", length(sheets))

for (i in seq_along(sheets)) {
  meta_list[[i]] <- readxl::read_excel(meta_file, skip = 7, sheet = sheets[[i]])
}

meta_list[[5]] <- readxl::read_excel(meta_file, skip = 8, col_names = FALSE ,sheet = sheets[[5]])

meta_list <- map(meta_list, clean_names)

# set up menus
# area
areas <- meta_list[[3]] %>% 
  rename(area = description)

area_vec <- areas$code
names(area_vec) <- areas$area

world_menu <- area_vec[area_vec == "001"]

region_menu <- area_vec[area_vec %in% c("110", "119", "123", "163", "200", "205",
                                  "400", "505", "511", "603", "903",
                                  "998")]

country_menu <- area_vec[!(area_vec %in% c(world_menu, region_menu))]

area_menu <- c(world_menu, region_menu, country_menu)

# concept
concepts <- meta_list[[4]] %>%
  select(code, description)

all_not_na <- function(a_menu) {
  weo_df %>% 
    filter(ref_area %in% a_menu) %>% 
    group_by(concept) %>% 
    summarize(na_all = all(is.na(value))) %>% 
    filter(na_all == FALSE)
}

level1 <- weo_df %>%
  count(concept) %>%
  filter(n > 1000)

concept1 <- concepts %>%
  semi_join(level1, by = c(code = "concept")) %>% 
  semi_join(all_not_na(area_menu), by = c(code = "concept"))

concept1_menu <- split(concept1$code, concept1$description)

region_only <- weo_df %>%
  filter(!is.na(value)) %>%
  filter(ref_area %in% region_menu) %>%
  semi_join(level1, by = "concept") %>%
  distinct(concept)

concept2 <- concepts %>%
  semi_join(region_only, by = c(code = "concept")) %>% 
  semi_join(all_not_na(region_menu), by = c(code = "concept"))

concept2_menu <- split(concept2$code, concept2$description)

concept3 <- concepts %>%
  anti_join(level1, by = c(code = "concept")) %>% 
  anti_join(region_only, by = c(code = "concept")) %>% 
  semi_join(all_not_na(world_menu), by = c(code = "concept"))

concept3_menu <- split(concept3$code, concept3$description)

concept_vec <- concepts$code
names(concept_vec) <- concepts$description

# unit
units <- meta_list[[5]]$x1
names(units) <- meta_list[[5]]$x2

# scale
scales <- meta_list[[6]]$value
names(scales) <- meta_list[[6]]$description
names(scales)[3:4] <- ""

# make a list
data_2204 <- weo_df

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
  area = areas,
  concept = concept_vec,
  unit = units,
  scale = scales
)

# save
usethis::use_data(data_2204, menu, meta, overwrite = TRUE)


