# Libraries
library(tidyverse)
library(janitor)

# Bulk download from IMF World Economic Outlook Database
# tf <- tempfile(tmpdir = tdir <- tempdir()) #temp file and folder
# download.file("https://www.imf.org/~/media/Files/Publications/WEO/WEO-Database/2020/02/weooct2020_sdmxdata.ashx", tf)
sdmx_file <- "weooct2020-sdmxdata/WEO_PUB_OCT2020.xml"

sdmx <- rsdmx::readSDMX(sdmx_file, isURL = FALSE)

weo <- as_tibble(sdmx)

weo <- map_dfc(weo, as.character)

weo$LASTACTUALDATE <- weo$LASTACTUALDATE %>% 
  as.integer()

weo$TIME_PERIOD <- weo$TIME_PERIOD %>% 
  as.integer()

weo$OBS_VALUE <- weo$OBS_VALUE %>% 
  as.double()


# Download meta data
# url <- "https://www.imf.org/external/pubs/ft/weo/2020/01/weodata/WEOApr2020_SDMXDSD.XLSX"
# httr::GET(url, httr::write_disk(tf2 <- tempfile(fileext = ".xlsx")))

tf2 <- "weooct2020-sdmxdata/weooct2020-sdmxdsd.xlsx"

sheets <- readxl::excel_sheets(tf2)

meta <- vector("list", length(sheets))

for (i in seq_along(sheets)) {
  meta[[i]] <- readxl::read_excel(tf2, skip = 7, sheet = sheets[[i]])
}

meta[[5]] <- readxl::read_excel(tf2, skip = 8, col_names = FALSE ,sheet = sheets[[5]])


# World is 001 not 1
weo$REF_AREA <- as.character(weo$REF_AREA)

weo <- weo %>% 
  mutate(REF_AREA = if_else(REF_AREA == "1", "001", REF_AREA))

# clean names
weo <- clean_names(weo)
meta <- map(meta, clean_names)

# save
# save(weo, meta, file = "data/weo.rdata")
usethis::use_data(weo, meta, overwrite = TRUE)


