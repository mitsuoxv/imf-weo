#' IMF World Economic Outlook data, current
#'
#' Economic data published in October 2020.
#'
#' @source https://www.imf.org/~/media/Files/Publications/WEO/WEO-Database/2020/02/weooct2020_sdmxdata.ashx
#' @format A list.
#' \describe{
#' \item{data}{
#' @format A tibble.
#' \describe{
#' \item{unit}{refer to meta unit}
#' \item{concept}{refer to meta concept}
#' \item{ref_area}{refer to meta area}
#' \item{freq}{"A" for annual}
#' \item{lastactualdate}{year like 2019}
#' \item{scale}{refer to meta scale}
#' \item{notes}{some notes}
#' \item{year}{year like 1980}
#' \item{value}{observed value}
#' }
#' }
#' \item{a_menu}{
#' area menu
#' @format A list.
#' \describe{
#' \item{area}{a named character vector, 3 digit code}
#' \item{region}{a named character vector, 3 digit code}
#' \item{world}{a named character vector, 3 digit code, "001" named "World"}
#' }
#' }
#' \item{c_menu}{
#' concept menu
#' @format A list.
#' \describe{
#' \item{area}{a named list}
#' \item{region}{a named list}
#' \item{world}{a named list}
#' }
#' }
#' \item{meta}{
#' meta data of code and description
#' @format A list.
#' \describe{
#' \item{area}{a tibble with 2 columns, code and area}
#' \item{concept}{a named character vector, code named by description}
#' \item{unit}{a named character vector, code named by description}
#' \item{scale}{a named character vector, code named by description}
#' }
#' }
#' }
"weo_2104"

#' IMF World Economic Outlook data, previous
#'
#' Economic data published in October 2020. Cut to since 2019 only.
#'
#' @source https://www.imf.org/~/media/Files/Publications/WEO/WEO-Database/2020/02/weooct2020_sdmxdata.ashx
#' @format A tibble.
#' \describe{
#' \item{unit}{refer to meta unit}
#' \item{concept}{refer to meta concept}
#' \item{ref_area}{refer to meta area}
#' \item{freq}{"A" for annual}
#' \item{lastactualdate}{year like 2019}
#' \item{scale}{refer to meta scale}
#' \item{notes}{some notes}
#' \item{year}{year like 1980}
#' \item{value}{observed value}
#' }
"weo_2010_cut_data"