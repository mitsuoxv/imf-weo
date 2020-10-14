IMF World Economic Outlook
================
Mitsuo Shiota
2019-05-21

Updated: 2020-10-14

## Summary

<https://mitsuoxv.shinyapps.io/imf-weo/>

IMF World Economic Outlook Databases are great sources for economic
analyses. I searched for APIs, but could not find any. So I have decided
to download from [the entire
dataset page](https://www.imf.org/en/Publications/WEO/weo-database/2020/October/download-entire-database).

I download SDMX Data in SDMX section, unzip, and put in the directory "weooct2020-sdmxdata", which I gitignore.

I transform SDMX data to data frame by utilizing rsdmx package.

I also download SDMX Data Structure Definition in SDMX section, which contain meta data, and put it in the same directory above.
I transform each sheet to data frame, and put it in a list.

I save data and meta data in a rdata format file to use them later in
app.R for Shiny.

The codes are in setup.R

EOL
