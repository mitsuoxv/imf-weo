#' Draw a line chart
#' 
#' Draw a time-series line chart. 
#'
#' @param df A data frame.
#'
#' @return A ggplot2 plot.
#'
#' @examples
#' \dontrun{
#' draw_chart(df)
#' }
draw_chart <- function(df) {
  unique_area <- df %>%
    dplyr::arrange(REF_AREA) %>%
    dplyr::pull(REF_AREA) %>%
    unique() %>%
    as.character()
  
  labels <- purrr::map_chr(unique_area, lookup_areas)
  
  lastactual <- vector("character", length = length(unique_area))
  
  for (i in seq_along(unique_area)) {
    lastactual[i] <- lookup_lastactual(unique_area[i], df)
  }
  
  caption <- NULL
  
  for (i in seq_along(unique_area)) {
    caption <- paste0(
      caption, "\n",
      "Last actual ", labels[i], ": ", lastactual[i]
    )
  }
  
  concepts <- meta[[4]] %>%
    dplyr::select(Code, Description)
  
  units <- meta[[5]]
  names(units) <- c("Code", "Description")
  
  scales <- meta[[6]]
  scales[scales$Value == "NULL", "Description"] <- ""
  scales[scales$Value == "1", "Description"] <- ""
  
  df <- df %>%
    dplyr::group_by(REF_AREA) %>%
    dplyr::mutate(
      actual = dplyr::if_else(is.na(LASTACTUALDATE), TRUE,
                              dplyr::if_else(TIME_PERIOD > LASTACTUALDATE, FALSE, TRUE)
      ),
      actual_lead = dplyr::lead(actual)
    ) %>%
    tidyr::fill(actual_lead) %>%
    dplyr::ungroup()
  
  ggplot2::ggplot() +
    ggplot2::geom_hline(yintercept = 0, size = 2, color = "white") +
    ggplot2::geom_line(
      data = df %>% dplyr::filter(actual),
      ggplot2::aes(TIME_PERIOD, OBS_VALUE, color = REF_AREA),
      size = 1
    ) +
    ggplot2::geom_line(
      data = df %>% dplyr::filter(!actual_lead),
      ggplot2::aes(TIME_PERIOD, OBS_VALUE, color = REF_AREA),
      size = 1, linetype = "dashed"
    ) +
    ggplot2::scale_color_discrete(
      name = "",
      labels = labels
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
      caption = caption
    ) +
    ggplot2::guides(linetype = "none") +
    ggplot2::theme(
      legend.position = "top",
      plot.title = ggplot2::element_text(size = ggplot2::rel(2))
    )
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
