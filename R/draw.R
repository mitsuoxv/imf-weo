#' Draw a line chart
#' 
#' Draw a time-series line chart. 
#'
#' @param df A data frame.
#'
#' @return A plotly object.
#'
#' @examples
#' \dontrun{
#' draw_chart(df)
#' }
draw_chart <- function(df) {

  concepts <- meta[[4]] %>%
    dplyr::select(code, description)
  
  units <- meta[[5]]
  names(units) <- c("code", "desc")
  
  scales <- meta[[6]] %>% 
    dplyr::rename(desc = description)
  scales[scales$value == "NULL", "desc"] <- ""
  scales[scales$value == "1", "desc"] <- ""
  
  df <- df %>%
    dplyr::left_join(meta[[3]], by = c("ref_area" = "code")) %>% 
    dplyr::rename(
      year = time_period,
      value = obs_value,
      area = description
      )
  
  p <- df %>% 
    dplyr::mutate(area = area %>% forcats::fct_reorder2(year, value)) %>% 
    ggplot2::ggplot() +
    ggplot2::geom_hline(yintercept = 0, size = 2, color = "white") +
    ggplot2::geom_line(
      ggplot2::aes(year, value, color = area),
      size = 1
    ) +
    ggplot2::labs(
      title = concepts[concepts$code == df$concept[1], ] %>%
        dplyr::pull(description) %>%
        dplyr::first(),
      x = NULL,
      y = paste0(
        units[units$code == df$unit[1], "desc"], " ",
        scales[scales$value == df$scale[1], "desc"]
      ),
      color = NULL
    ) +
    ggplot2::guides(linetype = "none") +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = ggplot2::rel(2))
    )
  
  plotly::ggplotly(p)
}


#' Print last actual year
#' 
#' Print last actual year.
#'
#' @param df A data frame.
#'
#' @return A character vector of length 1.
#'
#' @examples
#' \dontrun{
#' print_lastactual(df)
#' }
print_lastactual <- function(df) {
  df <- df %>%
    dplyr::left_join(meta[[3]], by = c("ref_area" = "code")) %>% 
    dplyr::distinct(ref_area, description, lastactualdate)

  if (all(is.na(df$lastactualdate))) {
    NULL
  } else {
    paste0("<p>", paste0(
      paste0("Last actual ", df$description, ": ", df$lastactualdate),
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
  area <- df %>%
    dplyr::arrange(ref_area) %>%
    dplyr::pull(ref_area) %>%
    unique() %>%
    as.character()
  
  notes <- df %>%
    dplyr::filter(
      ref_area %in% area,
      time_period == max(time_period)
      ) %>%
    dplyr::pull(notes)

  if (all(is.na(notes))) {
    NULL
  } else {
    paste0("<p>", paste0(notes, collapse = "<br>"), "</p>")
  }
}
