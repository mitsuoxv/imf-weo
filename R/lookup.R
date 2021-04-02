#' Look-up area
#' 
#' Look-up area description from area code.
#'
#' @param code A character vector of length 1.
#'
#' @return A character vector.
#'
#' @examples
#' \dontrun{
#' lookup_areas("001") # World
#' }
lookup_areas <- function(code) {
  meta[[3]] %>%
    dplyr::filter(Code == code) %>%
    dplyr::pull(Description)
}

#' Look-up last actual year
#' 
#' Look-up last actual year from area code.
#'
#' @param code A character vector of length 1.
#' @param df A data frame.
#'
#' @return A year.
#'
#' @examples
#' \dontrun{
#' lookup_lastactual("001", df)
#' }
lookup_lastactual <- function(code, df) {
  df %>%
    dplyr::filter(REF_AREA == code) %>%
    dplyr::pull(LASTACTUALDATE) %>%
    dplyr::first()
}
