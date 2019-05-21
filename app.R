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
                               "406", "440", "505", "511", "603", "901", "903",
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
  filter(REF_AREA != "001") %>% 
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

# Define UI for application that draws a histogram
ui <- navbarPage("IMF World Economic Outlook, April 2019",
    tabPanel("By area",
    sidebarLayout(
        sidebarPanel(
            selectInput("select_area", label = h3("Select area"), 
                      choices = area_menu, selected = "158"),
          
            hr(),
            
            selectInput("select_concept", label = h3("Select concept"), 
                        choices = concept1_menu, selected = "NGDP_RPCH"),
            
            hr(),
            
            # Sidebar with a slider input for year 
            sliderInput("year_range",
                        label = h3("Select year range"), 
                        min = 1980,
                        max = 2024,
                        value = c(1980, 2024),
                        sep = "")
        ),

        # Show a plot of the generated line chart
        mainPanel(
           plotOutput("linePlot"),
           textOutput("lastactual"),
           textOutput("notes")
        )
    )
    ),
    tabPanel("By region",
             sidebarLayout(
               sidebarPanel(
                 selectInput("select_area2", label = h3("Select region"), 
                             choices = region_menu),
                 
                 hr(),
                 
                 selectInput("select_concept2", label = h3("Select concept"), 
                             choices = concept2_menu),
                 
                 hr(),
                 
                 # Sidebar with a slider input for year 
                 sliderInput("year_range2",
                             label = h3("Select year range"), 
                             min = 1980,
                             max = 2024,
                             value = c(1980, 2024),
                             sep = "")
               ),
               
               # Show a plot of the generated line chart
               mainPanel(
                 plotOutput("linePlot2")
               )
             )
    ),
    tabPanel("By commodity",
             sidebarLayout(
               sidebarPanel(
                 selectInput("select_concept3", label = h3("Select concept"), 
                             choices = concept3_menu),
                 
                 hr(),
                 
                 # Sidebar with a slider input for year 
                 sliderInput("year_range3",
                             label = h3("Select year range"), 
                             min = 1980,
                             max = 2024,
                             value = c(1980, 2024),
                             sep = "")
               ),
               
               # Show a plot of the generated line chart
               mainPanel(
                 plotOutput("linePlot3")
               )
             )
    )
)

# Define server logic required to draw a chart
server <- function(input, output) {
    output$linePlot <- renderPlot({
      chart_data <- weo %>% 
        filter(REF_AREA == input$select_area, CONCEPT == input$select_concept,
               TIME_PERIOD >= input$year_range[1],
               TIME_PERIOD <= input$year_range[2])
      
      chart_data %>% 
        ggplot(aes(x = TIME_PERIOD, y = OBS_VALUE)) +
        geom_hline(yintercept = 0, size = 2, color = "white") +
        geom_line() +
        scale_color_discrete(guide = FALSE) +
        labs(
          x = "",
          y = paste0(units[units$Code == chart_data$UNIT[1], "Description"], " ",
                     scales[scales$Value == chart_data$SCALE[1], "Description"])
        )
    })
    
    output$lastactual <- renderText(paste0("Last actual: ",
                                     weo %>% 
                                filter(REF_AREA == input$select_area, CONCEPT == input$select_concept) %>% 
                                `[[`("LASTACTUALDATE") %>% 
                                `[`(1))
    )

    output$notes <- renderText(paste0("",
                                           weo %>% 
                                             filter(REF_AREA == input$select_area, CONCEPT == input$select_concept) %>% 
                                             `[[`("NOTES") %>% 
                                             `[`(1))
    )
    
    output$linePlot2 <- renderPlot({
      chart_data <- weo %>% 
        filter(REF_AREA == input$select_area2, CONCEPT == input$select_concept2,
               TIME_PERIOD >= input$year_range2[1],
               TIME_PERIOD <= input$year_range2[2])
      
      chart_data %>% 
        ggplot(aes(x = TIME_PERIOD, y = OBS_VALUE)) +
        geom_hline(yintercept = 0, size = 2, color = "white") +
        geom_line() +
        scale_color_discrete(guide = FALSE) +
        labs(
          x = "",
          y = paste0(units[units$Code == chart_data$UNIT[1], "Description"], " ",
                     scales[scales$Value == chart_data$SCALE[1], "Description"])
        )
    })
    
    output$linePlot3 <- renderPlot({
      chart_data <- weo %>% 
        filter(REF_AREA == "001", CONCEPT == input$select_concept3,
               TIME_PERIOD >= input$year_range3[1],
               TIME_PERIOD <= input$year_range3[2])
      
      chart_data %>% 
        ggplot(aes(x = TIME_PERIOD, y = OBS_VALUE)) +
        geom_hline(yintercept = 0, size = 2, color = "white") +
        geom_line() +
        scale_color_discrete(guide = FALSE) +
        labs(
          x = "",
          y = paste0(units[units$Code == chart_data$UNIT[1], "Description"], " ",
                     scales[scales$Value == chart_data$SCALE[1], "Description"])
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
