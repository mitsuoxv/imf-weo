#' Prepare download data
#'
#' @param prev A character vector of length 1, "Yes" or "No".
#' @param df A tibble.
#' @param df_prev A tibble.
#' @param name_current A character vector of length 1, like "2104".
#' @param name_prev A character vector of length 1, like "2010".
#'
#' @return A tibble.
#'
#' @examples
#' \dontrun{
#' output_data(input$previous, chart_data(), chart_data_prev(),
#' "2110", "2104")
#' }
output_data <- function(prev, df, df_prev, name_current, name_prev) {
  if (prev == "Yes") {
    data <- dplyr::bind_rows(df %>% dplyr::mutate(publish = name_current),
                      df_prev %>% dplyr::mutate(publish = name_prev)) %>% 
      dplyr::left_join(meta$area, by = c("ref_area" = "code")) %>%
      tidyr::unite(area_publish, c(area, publish)) %>% 
      dplyr::select(year, area_publish, value) %>%
      tidyr::pivot_wider(names_from = area_publish, values_from = value)
  } else {
    data <- df %>%
      dplyr::left_join(meta$area, by = c("ref_area" = "code")) %>%
      dplyr::select(year, area, value) %>%
      tidyr::pivot_wider(names_from = area, values_from = value)
  }
}