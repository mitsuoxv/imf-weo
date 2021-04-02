#' Show data
#' 
#' Provide 3 panels to show data by area, region, and commodity.
#'
#' @return A shinyApp.
#' @import shiny
#' @export
#'
#' @examples
#' \dontrun{
#' mainApp()
#' }
mainApp <- function() {
  areas <- meta[[3]]
  
  world_code <- tibble::tibble(Code = "001")
  
  region_code <- tibble::tibble(Code = c(
    "110", "119", "123", "163", "200", "205",
    "400", "505", "511", "603", "903",
    "998"
  ))
  
  world <- areas %>%
    dplyr::semi_join(world_code, by = "Code")
  
  regions <- areas %>%
    dplyr::semi_join(region_code, by = "Code")
  
  countries <- areas %>%
    dplyr::anti_join(world_code, by = "Code") %>%
    dplyr::anti_join(region_code, by = "Code")
  
  world_menu <- split(world$Code, world$Description)
  
  region_menu <- split(regions$Code, regions$Description)
  
  country_menu <- split(countries$Code, countries$Description)
  
  area_menu <- c(world_menu, region_menu, country_menu)
  
  concepts <- meta[[4]] %>%
    dplyr::select(Code, Description)
  
  level1 <- weo %>%
    dplyr::group_by(CONCEPT) %>%
    dplyr::count() %>%
    dplyr::filter(n > 1000)
  
  concept1 <- concepts %>%
    dplyr::semi_join(level1, by = c("Code" = "CONCEPT"))
  
  concept1_menu <- split(concept1$Code, concept1$Description)
  
  level2 <- weo %>%
    dplyr::group_by(CONCEPT) %>%
    dplyr::count() %>%
    dplyr::filter(n <= 1000)
  
  region_only <- weo %>%
    dplyr::filter(!is.na(OBS_VALUE)) %>%
    dplyr::filter(REF_AREA %in% region_code$Code) %>%
    dplyr::semi_join(level1, by = "CONCEPT") %>%
    dplyr::group_by(CONCEPT) %>%
    dplyr::count()
  
  world_only <- level2 %>%
    dplyr::anti_join(region_only, by = "CONCEPT")
  
  concept2 <- concepts %>%
    dplyr::semi_join(region_only, by = c("Code" = "CONCEPT"))
  
  concept2_menu <- split(concept2$Code, concept2$Description)
  
  concept3 <- concepts %>%
    dplyr::semi_join(world_only, by = c("Code" = "CONCEPT"))
  
  concept3_menu <- split(concept3$Code, concept3$Description)
  
  # Define UI for application
  ui <- navbarPage("IMF World Economic Outlook, October 2020",
  
    tags$head(includeHTML(("google-analytics.html"))),
    selected = "By area",
  
    tabPanel("By area",
             selectAreaUI("area", area_menu, concept1_menu)
    ),
    tabPanel("By region",
             selectAreaUI("region", region_menu, concept2_menu)
    ),
    tabPanel("By commodity",
             selectAreaUI("commodity", world_menu, concept3_menu)
    )
  )
  
  
  # Define server logic required to draw a chart
  server <- function(input, output, session) {
  
    selectAreaServer("area")
    selectAreaServer("region")
    selectAreaServer("commodity")
  
  }
  
  # Run the application
  shinyApp(ui = ui, server = server)
}
