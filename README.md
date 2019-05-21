IMF World Economic Outlook
================
Mitsuo Shiota
2019-05-21

Updated: 2019-05-21

## Summary

<https://mitsuoxv.shinyapps.io/imf-weo/>

IMF World Economic Outlook Databases are great sources for economic
analyses. I searched for APIs, but could not find any. So I have decided
to download [the entire
dataset](https://www.imf.org/external/pubs/ft/weo/2019/01/weodata/download.aspx).

The dataset has SDMX data structure, which I don’t know. I have searched
for packages, and found rsdmx package. With its help, I have managed to
transform SDMX data to data frame.

``` r
tf <- tempfile(tmpdir = tdir <- tempdir()) #temp file and folder
download.file("https://www.imf.org/external/pubs/ft/weo/2019/01/weodata/WEOApr2019_SDMXData.zip", tf)
sdmx_files <- unzip(tf, exdir = tdir)

sdmx <- rsdmx::readSDMX(sdmx_files[1], isURL = FALSE)
```

    ## Warning in readChar(file, file.info(file)$size): can only read in bytes in
    ## a non-UTF-8 MBCS locale

``` r
weo <- as_tibble(sdmx)

weo$LASTACTUALDATE <- weo$LASTACTUALDATE %>% 
  as.character() %>% 
  as.integer()
```

    ## Warning in function_list[[k]](value): NAs introduced by coercion

``` r
weo$TIME_PERIOD <- weo$TIME_PERIOD %>% 
  as.integer()

weo$OBS_VALUE <- weo$OBS_VALUE %>% 
  as.double()
```

    ## Warning in function_list[[k]](value): NAs introduced by coercion

I have also downloaded an excel file, which contain meta data. I
transform each sheet to data frame, and put it in a
list.

``` r
url <- "https://www.imf.org/external/pubs/ft/weo/2019/01/weodata/WEOApr2019_SDMXDSD.XLSX"

httr::GET(url, httr::write_disk(tf2 <- tempfile(fileext = ".xlsx")))
```

``` r
sheets <- readxl::excel_sheets(tf2)

meta <- vector("list", length(sheets))

for (i in seq_along(sheets)) {
  meta[[i]] <- readxl::read_excel(tf2, skip = 7, sheet = sheets[[i]])
}

meta[[5]] <- readxl::read_excel(tf2, skip = 8, col_names = FALSE ,sheet = sheets[[5]])
```

I save data and meta data in a rdata format file to use them later in
app.R for Shiny.

``` r
save(weo, meta, file = "data/weo.rdata")
```

EOL
