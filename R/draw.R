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
    dplyr::select(Code, Description)
  
  units <- meta[[5]]
  names(units) <- c("Code", "Description")
  
  scales <- meta[[6]]
  scales[scales$Value == "NULL", "Description"] <- ""
  scales[scales$Value == "1", "Description"] <- ""
  
  df <- df %>%
    dplyr::left_join(meta[[3]], by = c("REF_AREA" = "Code")) %>% 
    dplyr::rename(
      year = TIME_PERIOD,
      value = OBS_VALUE,
      area = Description
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
      title = concepts[concepts$Code == df$CONCEPT[1], ] %>%
        `[[`("Description") %>%
        `[`(1),
      x = NULL,
      y = paste0(
        units[units$Code == df$UNIT[1], "Description"], " ",
        scales[scales$Value == df$SCALE[1], "Description"]
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
    dplyr::left_join(meta[[3]], by = c("REF_AREA" = "Code")) %>% 
    dplyr::distinct(REF_AREA, Description, LASTACTUALDATE)

  if (all(is.na(df$LASTACTUALDATE))) {
    NULL
  } else {
    paste0("<p>", paste0(
      paste0("Last actual ", df$Description, ": ", df$LASTACTUALDATE),
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
    dplyr::arrange(REF_AREA) %>%
    dplyr::pull(REF_AREA) %>%
    unique() %>%
    as.character()
  
  notes <- df %>%
    dplyr::filter(
      REF_AREA %in% area,
      TIME_PERIOD == max(TIME_PERIOD)
      ) %>%
    dplyr::pull(NOTES)

  if (all(is.na(notes))) {
    NULL
  } else {
    paste0("<p>", paste0(notes, collapse = "<br>"), "</p>")
  }
}
