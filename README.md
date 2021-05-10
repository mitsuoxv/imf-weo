IMF World Economic Outlook
================
Mitsuo Shiota
2019-05-21

<!-- badges: start -->
[![R-CMD-check](https://github.com/mitsuoxv/imf-weo/workflows/R-CMD-check/badge.svg)](https://github.com/mitsuoxv/imf-weo/actions)
<!-- badges: end -->

Updated: 2021-04-09

## Summary

<https://mitsuoxv.shinyapps.io/imf-weo/>

IMF World Economic Outlook Databases are great sources for economic
analyses. I searched for APIs, but could not find any. So I have decided
to download from [the entire
dataset](https://www.imf.org/en/Publications/SPROLLs/world-economic-outlook-databases#sort=%40imfdate%20descending).

## Codes

I download SDMX Data in SDMX section, unzip, and put in the directory `downloads`, which I gitignore.

I transform SDMX data to data frame by utilizing `rsdmx` package.

I also download SDMX Data Structure Definition in SDMX section, which contain meta data, and put it in `downloads` directory. I transform each sheet to data frame, and make some named character vectors for menus.

I combine them in a list, `weo_2104`.

I save `weo_2104` in `data` directory in a rdata format file to use them later in app.R for Shiny. The codes are in `setup_current.R` in `data-raw` directory.

I also put a cut down version data frame `weo_2010_cut_data`, which contains only data since 2019, of half a year ago forecast in `data' directory. The codes are in `cut_previous.R` in `data-raw` directory.

## Package

I transformed this Shiny app into a R package, as of April 2021 version. So, if you are a R user, you can install it from my GitHub repo, as below. Once installed, you can see data like `weo_2104` and `weo_2010_cut_data` in R.

```
remotes::install_github("mitsuoxv/imf-weo")
```

EOL
