#' Draw a line chart
#' 
#' Draw a time-series line chart. 
#'
#' @param prev "Yes" or "No".
#' @param df A tibble.
#' @param df_prev A tibble.
#'
#' @return A plotly object.
#'
#' @examples
#' \dontrun{
#' draw_chart(prev, df, df_prev)
#' }
draw_chart <- function(prev, df, df_prev) {

  p <- df %>% 
    dplyr::left_join(meta$area, by = c("ref_area" = "code")) %>% 
    ggplot2::ggplot(ggplot2::aes(year, value, color = area)) +
    ggplot2::geom_hline(yintercept = 0, size = 1, color = "white") +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = names(meta$concept)[meta$concept == df$concept[1]][1],
      x = NULL, color = NULL,
      y = paste0(
        names(meta$unit)[meta$unit == df$unit[1]],
        " ",
        names(meta$scale)[meta$scale == df$scale[1]]
      )
    ) +
    ggplot2::guides(linetype = "none") +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = ggplot2::rel(1.5))
    )
  
  if (prev == "Yes") {
    p <- p + ggplot2::geom_line(data = df_prev%>% 
                                  dplyr::left_join(meta$area, by = c("ref_area" = "code")),
                                linetype = "dotted")
  }
  
  plotly::ggplotly(p)
}


#' Print last actual year
#' 
#' Print last actual year.
#'
#' @param df A tibble.
#'
#' @return A character vector of length 1.
#'
#' @examples
#' \dontrun{
#' print_lastactual(df)
#' }
print_lastactual <- function(df) {
  df <- df %>%
    dplyr::left_join(meta$area, by = c("ref_area" = "code")) %>% 
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
#' @param df A tibble.
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
