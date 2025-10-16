#' Menu, current
#'
#' @source https://www.imf.org/en/Publications/WEO/weo-database/2025/april/download-entire-database
#' @format A list.
#' \describe{
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
#' }
"menu"

#' Meta data, current
#'
#' @source https://data.imf.org/en/datasets/IMF.RES:WEO
#' @format A list.
#' \describe{
#' \item{area}{
#' @format A tibble.
#' \describe{
#' \item{code}{"USA"}
#' \item{area}{"United States"}
#' }
#' }
#' \item{concept}{a named character vector, code named by description}
#' \item{unit}{a named character vector, code named by description}
#' \item{scale}{a named character vector, code named by description}
#' }
"meta"

#' IMF World Economic Outlook data, current
#'
#' Economic data published in October 2025.
#'
#' @source https://data.imf.org/en/datasets/IMF.RES:WEO
#' @format A tibble.
#' \describe{
#' \item{unit}{refer to meta unit}
#' \item{base_year}{year like 2010}
#' \item{concept}{refer to meta concept}
#' \item{ref_area}{refer to meta area}
#' \item{freq}{"A" for annual}
#' \item{lastactualdate}{year like 2019}
#' \item{scale}{refer to meta scale}
#' \item{notes}{some notes}
#' \item{year}{year like 1980}
#' \item{value}{observed value}
#' }
"data_2510"

#' IMF World Economic Outlook data, previous
#'
#' Economic data published in April 2025. Cut to since 2021 only.
#'
#' @source https://www.imf.org/en/Publications/WEO/weo-database/2025/april/download-entire-database
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
"data_2504_cut"