#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# libraries
library(shiny)
library(tidyverse)

# load data
load("data/weo.rdata")


# create menus
areas <- meta[[3]]

world_code <- tibble(Code = "001")

region_code <- tibble(Code = c("110", "119", "123", "163", "200", "205",
                               "400", "505", "511", "603", "903",
                               "998"))

world <- areas %>% 
  semi_join(world_code, by = "Code")

regions <- areas %>% 
  semi_join(region_code, by = "Code")

countries <- areas %>% 
  anti_join(world_code, by = "Code") %>% 
  anti_join(region_code, by = "Code")

world_menu <- split(world$Code, world$Description)

region_menu <- split(regions$Code, regions$Description)

country_menu <- split(countries$Code, countries$Description)

area_menu <- c(world_menu, region_menu, country_menu)


concepts <- meta[[4]] %>% 
  select(Code, Description)

level1 <- weo %>% 
  group_by(CONCEPT) %>% 
  count() %>% 
  filter(n > 1000)

concept1 <- concepts %>% 
  semi_join(level1, by = c("Code"="CONCEPT"))

concept1_menu <- split(concept1$Code, concept1$Description)

level2 <- weo %>% 
  group_by(CONCEPT) %>% 
  count() %>% 
  filter(n <= 1000)

region_only <- weo %>% 
  drop_na(OBS_VALUE) %>% 
  filter(REF_AREA %in% region_code$Code) %>% 
  semi_join(level2, by = "CONCEPT")%>% 
  group_by(CONCEPT) %>% 
  count()

world_only <- level2 %>% 
  anti_join(region_only, by = "CONCEPT")

concept2 <- concepts %>% 
  semi_join(region_only, by = c("Code"="CONCEPT"))

concept2_menu <- split(concept2$Code, concept2$Description)

concept3 <- concepts %>% 
  semi_join(world_only, by = c("Code"="CONCEPT"))

concept3_menu <- split(concept3$Code, concept3$Description)

units <- meta[[5]]
names(units) <- c("Code", "Description")

scales <- meta[[6]]
scales[scales$Value == "NULL", "Description"] <- ""
scales[scales$Value == "1", "Description"] <- ""

# Define UI for application
ui <- navbarPage("IMF World Economic Outlook, October 2019",
    tabPanel("By area",
    sidebarLayout(
        sidebarPanel(
            selectInput("select_area1", label = h4("Select area1"), 
                      choices = area_menu, selected = "158"),
          
            selectInput("select_area2", label = h4("Select area2"), 
                        choices = area_menu, selected = "111"),
            
            hr(),
            
            selectInput("select_concept1", label = h4("Select concept1"), 
                        choices = concept1_menu, selected = "NGDP_RPCH"),
            
            selectInput("select_concept2", label = h4("Select concept2"), 
                        choices = concept1_menu, selected = "GGXWDG_NGDP"),
            
            hr(),
            
            # Sidebar with a slider input for year 
            sliderInput("year_range",
                        label = h4("Select year range"), 
                        min = 1980,
                        max = 2024,
                        value = c(1980, 2024),
                        sep = ""),
            
            hr(),
            
            # Show source and Shiny app creator
            a(href = "https://www.imf.org/en/Publications/SPROLLS/world-economic-outlook-databases#sort=%40imfdate%20descending", 
                   "Source: IMF"),
            br(),
            a(href = "https://mitsuoxv.rbind.io/", 
                   "Shiny app creator: Mitsuo Shiota")
        ),

        # Show a plot of the generated line chart
        mainPanel(
           plotOutput("plot1"),
           htmlOutput("notes1"),
           plotOutput("plot2"),
           htmlOutput("notes2")
        )
    )
    ),
    tabPanel("By region",
             sidebarLayout(
               sidebarPanel(
                 selectInput("select_region1", label = h4("Select region1"), 
                             choices = region_menu, selected = "200"),
                 
                 selectInput("select_region2", label = h4("Select region2"), 
                             choices = region_menu, selected = "205"),
                 
                 selectInput("select_region3", label = h4("Select region3"), 
                             choices = region_menu, selected = "505"),
                 
                 hr(),
                 
                 selectInput("select_concept_region", label = h4("Select concept"), 
                             choices = concept2_menu, selected = "D_NGDPD"),

                                  
                 hr(),
                 
                 # Sidebar with a slider input for year 
                 sliderInput("year_range_region",
                             label = h4("Select year range"), 
                             min = 1980,
                             max = 2024,
                             value = c(1980, 2024),
                             sep = "")
               ),
               
               # Show a plot of the generated line chart
               mainPanel(
                 plotOutput("plot_region")
               )
             )
    ),
    tabPanel("By commodity",
             sidebarLayout(
               sidebarPanel(
                 selectInput("select_concept_commodity", label = h4("Select concept"), 
                             choices = concept3_menu, selected = "POILWTI"),
                 
                 hr(),
                 
                 # Sidebar with a slider input for year 
                 sliderInput("year_range_commodity",
                             label = h4("Select year range"), 
                             min = 1980,
                             max = 2024,
                             value = c(1980, 2024),
                             sep = "")
               ),
               
               # Show a plot of the generated line chart
               mainPanel(
                 plotOutput("plot_commodity")
               )
             )
    )
)

# Functions
lookup_areas <- function(code) {
  areas %>% 
    filter(Code == code) %>% 
    `[[`("Description")
}

lookup_lastactual <- function(code, df) {
  df %>% 
    filter(REF_AREA == code) %>% 
    `[[`("LASTACTUALDATE") %>% 
    `[`(1)
}

draw_chart <- function(df) {
  unique_area <- df %>% 
    arrange(REF_AREA) %>% 
    `[[`("REF_AREA") %>% 
    unique() %>% 
    as.character()
  
  labels <- map_chr(unique_area, lookup_areas)
  
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

    
  df %>% 
    mutate(actual = if_else(is.na(LASTACTUALDATE), "3",
                            if_else(TIME_PERIOD > LASTACTUALDATE, "2", "1"))
           ) %>% 
    ggplot(aes(x = TIME_PERIOD, y = OBS_VALUE,
               color = REF_AREA, linetype = actual)) +
    geom_hline(yintercept = 0, size = 2, color = "white") +
    geom_line() +
    scale_color_discrete(name = "",
                         labels = labels) +
    labs(
      title = concepts[concepts$Code == df$CONCEPT[1], ] %>% 
        `[[`("Description") %>% 
        `[`(1),
      x = "",
      y = paste0(units[units$Code == df$UNIT[1], "Description"], " ",
                 scales[scales$Value == df$SCALE[1], "Description"]),
      caption = caption
    ) +
    guides(linetype = "none") +
    theme(legend.position = "top",
          plot.title = element_text(size = rel(2)))
}

print_note <- function(df) {
  area <- df %>% 
    arrange(REF_AREA) %>% 
    `[[`("REF_AREA") %>% 
    unique() %>% 
    as.character()
  
  note1 <- df %>% 
    filter(REF_AREA == area[1]) %>% 
    `[[`("NOTES") %>% 
    `[`(1)
  
  note2 <- df %>% 
    filter(REF_AREA == area[2]) %>% 
    `[[`("NOTES") %>% 
    `[`(1)
  
  paste0("<p>", note1, "<br>", note2, "</p>")
}

# Define server logic required to draw a chart
server <- function(input, output) {
  chart_data1 <- reactive({
    weo %>% 
      filter(REF_AREA %in% c(input$select_area1, input$select_area2),
             CONCEPT == input$select_concept1)
  })
  
  output$plot1 <- renderPlot({
    chart_data1() %>% 
      filter(TIME_PERIOD >= input$year_range[1],
             TIME_PERIOD <= input$year_range[2]) %>% 
      draw_chart()
  })

  output$notes1 <- renderText({
    chart_data1() %>% 
      print_note()
  })
  
  chart_data2 <- reactive({
    weo %>% 
      filter(REF_AREA %in% c(input$select_area1, input$select_area2),
             CONCEPT == input$select_concept2)
  })
  
  output$plot2 <- renderPlot({
    chart_data2() %>% 
      filter(TIME_PERIOD >= input$year_range[1],
             TIME_PERIOD <= input$year_range[2]) %>% 
      draw_chart()
  })
  
  output$notes2 <- renderText({
    chart_data2() %>% 
      print_note()
  })
  
  chart_data_region <- reactive({
    weo %>% 
      filter(REF_AREA %in% c(input$select_region1, input$select_region2,
                             input$select_region3),
             CONCEPT == input$select_concept_region)
  })
  
  output$plot_region <- renderPlot({
    chart_data_region() %>% 
      filter(TIME_PERIOD >= input$year_range_region[1],
             TIME_PERIOD <= input$year_range_region[2]) %>% 
      draw_chart()
  })

  chart_data_commodity <- reactive({
    weo %>% 
      filter(REF_AREA == "001", CONCEPT == input$select_concept_commodity)
  })
  
  output$plot_commodity <- renderPlot({
    chart_data_commodity() %>% 
      filter(TIME_PERIOD >= input$year_range_commodity[1],
             TIME_PERIOD <= input$year_range_commodity[2]) %>% 
      draw_chart()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
