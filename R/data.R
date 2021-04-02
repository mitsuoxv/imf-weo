#' IMF World Economic Outlook data
#'
#' Economic data published in October 2020.
#'
#' @source https://www.imf.org/~/media/Files/Publications/WEO/WEO-Database/2020/02/weooct2020_sdmxdata.ashx
#' @format A data frame.
#' \describe{
#' \item{UNIT}{1 letter showing unit}
#' \item{CONCEPT}{concept}
#' \item{REF_AREA}{area}
#' \item{FREQ}{1 letter showing frequency}
#' \item{LASTACTUALDATE}{last actual year}
#' \item{SCALE}{scale}
#' \item{NOTES}{notes}
#' \item{TIME_PERIOD}{year}
#' \item{OBS_VALUE}{value}
#' }
"weo"


#' IMF World Economic Outlook meta data
#'
#' Meta data published in October 2020.
#'
#' @source https://www.imf.org/external/pubs/ft/weo/2020/01/weodata/WEOApr2020_SDMXDSD.XLSX
#' @format A list of 7 data frames
#' \describe{
#' \item{1}{frequency description}
#' \item{2}{date}
#' \item{3}{area}
#' \item{4}{concept}
#' \item{5}{denominator}
#' \item{6}{scale}
#' \item{7}{year}
#' }
"meta"
