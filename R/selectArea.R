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
                  max = 2025,
                  value = c(1980, 2025),
                  sep = ""
      ),
      
      # Toggle add previous forecast or not
      radioButtons(NS(id, "previous"), "Add October 2020 forecast?", c("Yes", "No"),
                   selected = "No"),
    
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
      plotly::plotlyOutput(NS(id, "plot")),
      fluidRow(
        column(4,
               htmlOutput(NS(id, "lastactual"))),
        column(4,
               htmlOutput(NS(id, "notes"))),
        column(4,
               downloadButton(NS(id, "download"), "Download"))
      )
    )
  )
}

#' selectArea module server
#' 
#' selectArea module server
#'
#' @param id A character vector of length 1.
#' @param data A data frame.
#' @param m_area A data frame with 2 columns, code and area.
#' @param m_concept A named character vector.
#' @param m_unit A named character vector.
#' @param m_scale A named character vector.
#' @param data_prev A data frame.
#'
#' @return A module server.
#'
#' @examples
#' \dontrun{
#' selectAreaServer("area", weo$data, weo_prev_data,
#' weo$meta$area, weo$meta$concept, weo$meta$unit, weo$meta$scale)
#' }
selectAreaServer <- function(id, data, data_prev, m_area, m_concept, m_unit, m_scale) {
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
      draw_chart(chart_data(), chart_data_prev(), input$previous,
                 m_area, m_concept, m_unit, m_scale)
    })
    
    output$lastactual <- renderText({
      chart_data() %>%
        print_lastactual(m_area)
    })

    output$notes <- renderText({
      chart_data() %>%
        print_note()
    })
    
    output$download <- downloadHandler(
      filename = function() {
        paste0(input$select_concept, ".csv")
      },
      content = function(file) {
        if (input$previous == "Yes") {
          bind_rows(chart_data() %>% mutate(publish = "2104"),
                    chart_data_prev() %>% mutate(publish = "2010")) %>% 
            dplyr::left_join(m_area, by = c("ref_area" = "code")) %>%
            tidyr::unite(area_publish, c(area, publish)) %>% 
            dplyr::select(year, area_publish, value) %>%
            tidyr::pivot_wider(names_from = area_publish, values_from = value) %>%
            vroom::vroom_write(file)
        } else {
          chart_data() %>%
            dplyr::left_join(m_area, by = c("ref_area" = "code")) %>%
            dplyr::select(year, area, value) %>%
            tidyr::pivot_wider(names_from = area, values_from = value) %>%
            vroom::vroom_write(file)
        }
      }
    )
  })
}