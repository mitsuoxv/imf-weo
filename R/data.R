#' IMF World Economic Outlook data
#'
#' Economic data published in October 2020.
#'
#' @source https://www.imf.org/~/media/Files/Publications/WEO/WEO-Database/2020/02/weooct2020_sdmxdata.ashx
#' @format A data frame.
#' \describe{
#' \item{unit}{1 letter showing unit}
#' \item{concept}{concept}
#' \item{ref_area}{area code}
#' \item{freq}{1 letter showing frequency}
#' \item{lastactualdate}{last actual year}
#' \item{scale}{scale}
#' \item{notes}{notes}
#' \item{time_period}{year}
#' \item{obs_value}{value}
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
