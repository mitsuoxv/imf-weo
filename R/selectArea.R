#' selectArea module UI
#' 
#' selectArea module UI.
#'
#' @param id A character vector of length 1.
#' @param a_menu A character vector.
#' @param c_menu A character vector.
#'
#' @return A module UI.
#'
#' @examples
#' \dontrun{
#' selectAreaUI("area", area_menu, concept1_menu)
#' }
selectAreaUI <- function(id, a_menu, c_menu) {
  sidebarLayout(
    sidebarPanel(
      
      if (id == "region") {
        selectInput(NS(id, "select_area"),
                    label = h4("Select regions (add/remove)"),
                    choices = a_menu, selected = c("200", "205", "505"),
                    multiple = TRUE
        )
      } else if (id == "commodity") {
        selectInput(NS(id, "select_area"),
                    label = h4("World only"),
                    choices = a_menu, selected = "001"
        )
      } else if (id == "area") {
        selectInput(NS(id, "select_area"),
                    label = h4("Select areas (add/remove)"),
                    choices = a_menu, selected = c("158", "111"),
                    multiple = TRUE
        )
      }
      ,

      hr(),
      
      selectInput(NS(id, "select_concept"),
                  label = h4("Select concept"),
                  choices = c_menu,
                  selected = dplyr::case_when(
                    id == "region" ~ "D_NGDPD",
                    id == "commodity" ~ "POILWTI",
                    id == "area" ~ "NGDP_RPCH"
                  )
      ),
      
      
      hr(),
      
      # Sidebar with a slider input for year
      sliderInput(NS(id, "year_range"),
                  label = h4("Select year range"),
                  min = 1980,
                  max = 2025,
                  value = c(1980, 2025),
                  sep = ""
      ),
      
      # Show source and Shiny app creator
      a(
        href = "https://www.imf.org/en/Publications/SPROLLs/world-economic-outlook-databases#sort=%40imfdate%20descending",
        "Source: IMF"
      ),
      br(),
      a(
        href = "https://mitsuoxv.rbind.io/",
        "Shiny app creator: Mitsuo Shiota"
      )
    ),
    
    # Show a plot of the generated line chart
    mainPanel(
      plotOutput(NS(id, "plot")),
      htmlOutput(NS(id, "notes"))
    )
  )
}

#' selectArea module server
#' 
#' selectArea module server
#'
#' @param id A character vector of length 1.
#'
#' @return A module server.
#'
#' @examples
#' \dontrun{
#' selectAreaServer("area")
#' }
selectAreaServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    chart_data <- reactive({
      weo %>%
        dplyr::filter(
          REF_AREA %in% input$select_area,
          CONCEPT == input$select_concept
        )
    })
    
    output$plot <- renderPlot({
      chart_data() %>%
        dplyr::filter(
          TIME_PERIOD >= input$year_range[1],
          TIME_PERIOD <= input$year_range[2]
        ) %>%
        draw_chart()
    })
    
    output$notes <- renderText({
      chart_data() %>%
        print_note()
    })
    
  })
}