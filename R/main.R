#' Show data
#' 
#' Provide 3 panels to show data by area, region, and commodity.
#' 
#' @param data_current A tibble
#' @param data_prev A tibble.
#' @param name_current A character vector of length 1, like "2104".
#' @param name_prev A character vector of length 1, like "2010".
#' 
#' @return A shinyApp.
#' @import shiny
#' @export
#'
#' @examples
#' \dontrun{
#' mainApp()
#' }
mainApp <- function(data_current, data_prev, name_current, name_prev) {
  # Define UI for application
  ui <- navbarPage("IMF World Economic Outlook, October 2023",
  
    tags$head(includeHTML(("google-analytics.html"))),
    selected = "By area",
  
    tabPanel("By area",
             selectAreaUI("area", menu$a_menu$area, menu$c_menu$area)
    ),
    tabPanel("By region",
             selectAreaUI("region", menu$a_menu$region, menu$c_menu$region)
    ),
    tabPanel("By commodity",
             selectAreaUI("commodity", menu$a_menu$world, menu$c_menu$world)
    )
  )
  
  
  # Define server logic required to draw a chart
  server <- function(input, output, session) {
  
    selectAreaServer("area", data_current, data_prev, name_current, name_prev)
    selectAreaServer("region", data_current, data_prev, name_current, name_prev)
    selectAreaServer("commodity", data_current, data_prev, name_current, name_prev)
  
  }
  
  # Run the application
  shinyApp(ui = ui, server = server)
}
