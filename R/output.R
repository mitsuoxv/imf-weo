#' Prepare download data
#'
#' @param prev A character vector of length 1, "Yes" or "No".
#' @param df A tibble.
#' @param df_prev A tibble.
#' @param pub_ym_current A character vector of length 1, like "2104".
#' @param pub_ym_prev A character vector of length 1, like "2010".
#' @param m_area A tibble, with 2 columns: code and area.
#'
#' @return A tibble.
#'
#' @examples
#' \dontrun{
#' output_data(input$previous, chart_data(), chart_data_prev(),
#' "2104", "2010", m_area)
#' }
output_data <- function(prev, df, df_prev, pub_ym_current, pub_ym_prev, m_area) {
  if (prev == "Yes") {
    data <- dplyr::bind_rows(df %>% dplyr::mutate(publish = pub_ym_current),
                      df_prev %>% dplyr::mutate(publish = pub_ym_prev)) %>% 
      dplyr::left_join(m_area, by = c("ref_area" = "code")) %>%
      tidyr::unite(area_publish, c(area, publish)) %>% 
      dplyr::select(year, area_publish, value) %>%
      tidyr::pivot_wider(names_from = area_publish, values_from = value)
  } else {
    data <- df %>%
      dplyr::left_join(m_area, by = c("ref_area" = "code")) %>%
      dplyr::select(year, area, value) %>%
      tidyr::pivot_wider(names_from = area, values_from = value)
  }
}