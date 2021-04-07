#' Draw a line chart
#' 
#' Draw a time-series line chart. 
#'
#' @param df A data frame.
#' @param df_prev A data frame.
#' @param prev "Yes" or "No".
#' @param m_area A data frame with 2 columns, code and area.
#' @param m_concept A named character vector.
#' @param m_unit A named character vector.
#' @param m_scale A named character vector.
#'
#' @return A plotly object.
#'
#' @examples
#' \dontrun{
#' draw_chart(df, m_area, m_concept, m_unit, m_scale)
#' }
draw_chart <- function(df, df_prev, prev, m_area, m_concept, m_unit, m_scale) {

  p <- df %>% 
    dplyr::left_join(m_area, by = c("ref_area" = "code")) %>% 
    ggplot2::ggplot(ggplot2::aes(year, value, color = area)) +
    ggplot2::geom_hline(yintercept = 0, size = 1, color = "white") +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = names(m_concept)[m_concept == df$concept[1]][1],
      x = NULL, color = NULL,
      y = paste0(
        names(m_unit)[m_unit == df$unit[1]],
        " ",
        names(m_scale)[m_scale == df$scale[1]]
      )
    ) +
    ggplot2::guides(linetype = "none") +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = ggplot2::rel(1.5))
    )
  
  if (prev == "Yes") {
    p <- p + ggplot2::geom_line(data = df_prev%>% 
                                  dplyr::left_join(m_area, by = c("ref_area" = "code")),
                                linetype = "dotted")
  }
  
  plotly::ggplotly(p)
}


#' Print last actual year
#' 
#' Print last actual year.
#'
#' @param df A data frame.
#' @param m_area A data frame with 2 columns, code and area
#'
#' @return A character vector of length 1.
#'
#' @examples
#' \dontrun{
#' print_lastactual(df, m_area)
#' }
print_lastactual <- function(df, m_area) {
  df <- df %>%
    dplyr::left_join(m_area, by = c("ref_area" = "code")) %>% 
    dplyr::distinct(ref_area, area, lastactualdate)

  if (all(is.na(df$lastactualdate))) {
    NULL
  } else {
    paste0("<p>", paste0(
      paste0("Last actual ", df$area, ": ", df$lastactualdate),
      collapse = "<br>"), "</p>")
  }
}

#' Print notes
#' 
#' Print notes.
#'
#' @param df A data frame.
#'
#' @return A character vector of length 1.
#'
#' @examples
#' \dontrun{
#' print_note(df)
#' }
print_note <- function(df) {

  notes <- df %>%
    dplyr::distinct(ref_area, .keep_all = TRUE) %>% 
    dplyr::pull(notes)

  if (all(is.na(notes))) {
    NULL
  } else {
    paste0("<p>", paste0(notes, collapse = "<br>"), "</p>")
  }
}
