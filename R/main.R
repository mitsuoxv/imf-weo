#' Show data
#' 
#' Provide 3 panels to show data by area, region, and commodity.
#' 
#' @param weo A list.
#' @param weo_prev_data A data frame.
#' 
#' @return A shinyApp.
#' @import shiny
#' @export
#'
#' @examples
#' \dontrun{
#' mainApp()
#' }
mainApp <- function(weo, weo_prev_data) {
  # Define UI for application
  ui <- navbarPage("IMF World Economic Outlook, April 2021",
  
    tags$head(includeHTML(("google-analytics.html"))),
    selected = "By area",
  
    tabPanel("By area",
             selectAreaUI("area", weo$a_menu$area, weo$c_menu$area)
    ),
    tabPanel("By region",
             selectAreaUI("region", weo$a_menu$region, weo$c_menu$region)
    ),
    tabPanel("By commodity",
             selectAreaUI("commodity", weo$a_menu$world, weo$c_menu$world)
    )
  )
  
  
  # Define server logic required to draw a chart
  server <- function(input, output, session) {
  
    selectAreaServer("area", weo$data, weo_prev_data,
                     weo$meta$area, weo$meta$concept, weo$meta$unit, weo$meta$scale)
    selectAreaServer("region", weo$data, weo_prev_data,
                     weo$meta$area, weo$meta$concept, weo$meta$unit, weo$meta$scale)
    selectAreaServer("commodity", weo$data, weo_prev_data,
                     weo$meta$area, weo$meta$concept, weo$meta$unit, weo$meta$scale)
  
  }
  
  # Run the application
  shinyApp(ui = ui, server = server)
}
