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
  
  world_code <- tibble::tibble(code = "001")
  
  region_code <- tibble::tibble(code = c(
    "110", "119", "123", "163", "200", "205",
    "400", "505", "511", "603", "903",
    "998"
  ))
  
  world <- areas %>%
    dplyr::semi_join(world_code, by = "code")
  
  regions <- areas %>%
    dplyr::semi_join(region_code, by = "code")
  
  countries <- areas %>%
    dplyr::anti_join(world_code, by = "code") %>%
    dplyr::anti_join(region_code, by = "code")
  
  world_menu <- split(world$code, world$description)
  
  region_menu <- split(regions$code, regions$description)
  
  country_menu <- split(countries$code, countries$description)
  
  area_menu <- c(world_menu, region_menu, country_menu)
  
  concepts <- meta[[4]] %>%
    dplyr::select(code, description)
  
  level1 <- weo %>%
    dplyr::group_by(concept) %>%
    dplyr::count() %>%
    dplyr::filter(n > 1000)
  
  concept1 <- concepts %>%
    dplyr::semi_join(level1, by = c("code" = "concept"))
  
  concept1_menu <- split(concept1$code, concept1$description)
  
  level2 <- weo %>%
    dplyr::group_by(concept) %>%
    dplyr::count() %>%
    dplyr::filter(n <= 1000)
  
  region_only <- weo %>%
    dplyr::filter(!is.na(obs_value)) %>%
    dplyr::filter(ref_area %in% region_code$code) %>%
    dplyr::semi_join(level1, by = "concept") %>%
    dplyr::group_by(concept) %>%
    dplyr::count()
  
  world_only <- level2 %>%
    dplyr::anti_join(region_only, by = "concept")
  
  concept2 <- concepts %>%
    dplyr::semi_join(region_only, by = c("code" = "concept"))
  
  concept2_menu <- split(concept2$code, concept2$description)
  
  concept3 <- concepts %>%
    dplyr::semi_join(world_only, by = c("code" = "concept"))
  
  concept3_menu <- split(concept3$code, concept3$description)
  
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
