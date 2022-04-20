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

      selectInput(NS(id, "select_concept"),
                  label = h4("Select concept"),
                  choices = c_menu,
                  selected = dplyr::case_when(
                    id == "region" ~ "D_NGDPD",
                    id == "commodity" ~ "POILWTI",
                    id == "area" ~ "NGDP_RPCH"
                  )
      ),
      
      # Sidebar with a slider input for year
      sliderInput(NS(id, "year_range"),
                  label = h4("Select year range"),
                  min = 1980,
                  max = 2027,
                  value = c(1980, 2027),
                  sep = ""
      ),
      
      # Toggle add previous forecast or not
      radioButtons(NS(id, "previous"), "Add October 2021 forecast?", c("Yes", "No"),
                   selected = "No"),
    
      # Show source and Shiny app creator
      a(
        href = "https://www.imf.org/en/Publications/WEO/weo-database/2022/April",
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
      plotly::plotlyOutput(NS(id, "plot")),
      fluidRow(
        column(4,
               htmlOutput(NS(id, "lastactual"))),
        column(4,
               htmlOutput(NS(id, "notes"))),
        column(4,
               downloadButton(NS(id, "download"), "Download .tsv"))
      )
    )
  )
}

#' selectArea module server
#' 
#' @param id A character vector of length 1.
#' @param data A tibble.
#' @param data_prev A tibble.
#' @param name_current A character vector of length 1, like "2104".
#' @param name_prev A character vector of length 1, like "2010".
#'
#' @return A module server.
#'
#' @examples
#' \dontrun{
#' selectAreaServer("area", data_2110, data_2104_cut, "2110", "2104")
#' }
selectAreaServer <- function(id, data, data_prev, 
                             name_current, name_prev) {
  moduleServer(id, function(input, output, session) {

    chart_data <- reactive({
      data %>%
        dplyr::filter(
          ref_area %in% input$select_area,
          concept == input$select_concept,
          year >= input$year_range[1],
          year <= input$year_range[2]
        )
    }) %>% 
      bindCache(input$select_area, input$select_concept,
                input$year_range)
    
    chart_data_prev <- reactive({
      data_prev %>%
        dplyr::filter(
          ref_area %in% input$select_area,
          concept == input$select_concept,
          year >= input$year_range[1],
          year <= input$year_range[2]
        )
    }) %>% 
      bindCache(input$select_area, input$select_concept,
                input$year_range)
    
    output$plot <- plotly::renderPlotly({
      draw_chart(input$previous,
                 chart_data(), chart_data_prev())
    })
    
    output$lastactual <- renderText({
      chart_data() %>%
        print_lastactual()
    })

    output$notes <- renderText({
      chart_data() %>%
        print_note()
    })
    
    output$download <- downloadHandler(
      filename = function() {
        paste0(input$select_concept, ".tsv")
      },
      content = function(file) {
        data <- output_data(input$previous, 
                            chart_data(), chart_data_prev(),
                            name_current, name_prev)
        vroom::vroom_write(data, file)
      }
    )
  })
}
