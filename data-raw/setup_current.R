# Libraries
library(tidyverse)
library(janitor)

# Bulk download from IMF World Economic Outlook Database
# https://www.imf.org/en/Publications/WEO/weo-database/2021/April
sdmx_file <- "downloads/WEO_PUB_APR2021.xml"

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
# https://www.imf.org/en/Publications/WEO/weo-database/2021/April
meta_file <- "downloads/weoapr2021-sdmx-dsd.xlsx"

sheets <- readxl::excel_sheets(meta_file)

meta <- vector("list", length(sheets))

for (i in seq_along(sheets)) {
  meta[[i]] <- readxl::read_excel(meta_file, skip = 7, sheet = sheets[[i]])
}

meta[[5]] <- readxl::read_excel(meta_file, skip = 8, col_names = FALSE ,sheet = sheets[[5]])

meta <- map(meta, clean_names)

# set up menus
# area
areas <- meta[[3]] %>% 
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
concepts <- meta[[4]] %>%
  dplyr::select(code, description)

level1 <- weo_df %>%
  dplyr::count(concept) %>%
  dplyr::filter(n > 1000)

concept1 <- concepts %>%
  dplyr::semi_join(level1, by = c("code" = "concept"))

concept1_menu <- split(concept1$code, concept1$description)

region_only <- weo_df %>%
  dplyr::filter(!is.na(value)) %>%
  dplyr::filter(ref_area %in% region_menu) %>%
  dplyr::semi_join(level1, by = "concept") %>%
  dplyr::distinct(concept)

concept2 <- concepts %>%
  dplyr::semi_join(region_only, by = c("code" = "concept"))

concept2_menu <- split(concept2$code, concept2$description)

concept3 <- concepts %>%
  dplyr::anti_join(level1, by = c("code" = "concept")) %>% 
  dplyr::anti_join(region_only, by = c("code" = "concept"))

concept3_menu <- split(concept3$code, concept3$description)

concept_vec <- concepts$code
names(concept_vec) <- concepts$description

# unit
units <- meta[[5]]$x1
names(units) <- meta[[5]]$x2

# scale
scales <- meta[[6]]$value
names(scales) <- meta[[6]]$description
names(scales)[3:4] <- ""

# make a list
weo_2104 <- list(
  data = weo_df,
  a_menu = list(
    area = area_menu,
    region = region_menu,
    world = world_menu
  ),
  c_menu = list(
    area = concept1_menu, 
    region = concept2_menu,
    world = concept3_menu
  ),
  meta = list(
    area = areas,
    concept = concept_vec,
    unit = units,
    scale = scales
  )
)

# save
usethis::use_data(weo_2104)


