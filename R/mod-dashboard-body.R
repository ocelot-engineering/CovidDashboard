#
# Dashboard body
#
# Displays tabs from sidebar navigation
#

#' Dashboard body ui function
#'
#' @inherit module_docs params
#' @importFrom shinydashboard dashboardBody tabItems tabItem
#'
body_ui <- function(id) {
    ns <- shiny::NS(id)

    body <- shinydashboard::dashboardBody(
        style = "padding: 0px;",
        shiny::includeCSS(path = system.file("styles/styles.css", package = get_pkg_name())),
        shiny::includeScript(path = system.file("scripts/sidebar-triggers.js", package = get_pkg_name())),
        shiny::includeScript(path = system.file("scripts/debug.js", package = get_pkg_name())),
        shinydashboard::tabItems(
            shinydashboard::tabItem(tabName = "overview",      overview_ui(ns("page_overview"))),
            shinydashboard::tabItem(tabName = "world_map",     world_map_ui(ns("world_map"))),
            shinydashboard::tabItem(tabName = "news_feed",     news_feed_ui(ns("news_feed"))),
            shinydashboard::tabItem(tabName = "country_comp",  country_comp_ui(ns("country_comp"))),
            shinydashboard::tabItem(tabName = "data_explorer", data_explorer_ui(ns("data_explorer"))),
            shinydashboard::tabItem(tabName = "simulations",   simulations_ui(ns("simulations"))),
            shinydashboard::tabItem(tabName = "vaccines",      vaccines_ui(ns("vaccines"))),
            shinydashboard::tabItem(tabName = "data_sources",  data_sources_ui(ns("data_sources"))),
            shinydashboard::tabItem(tabName = "metrics",       metrics_ui(ns("metrics")))
        )
    )

    return(body)
}

#' Dashboard body server function
#'
#' @inherit module_docs params
#' @inherit common_docs params
#'
body_server <- function(id, daily_cases, vax, population) {

    module <- function(input, output, session) {

        # Reactives ------------------------------------------------------------

        # Daily cases
        daily_cases_filt <- reactive(daily_cases, label = "daily_cases_filt")

        # Vaccines
        vax_filt <- reactive(vax, label = "vax_filt")

        # Population
        population_filt <- reactive(population, label = "population")

        # Latest by country
        latest_rows_by_country <- reactive({
            # latest rows for each country
            get_latest_info_by_country(daily_cases_filt(), lag = 0)
        }, label = "latest_rows_by_country")

        latest_outbreak_rating_by_country <- reactive({
            # outbreak rating for latest date for each countries

            # Get population cols
            pop <- population_filt() %>% dplyr::select(dplyr::all_of(c("DATE_REPORTED", "COUNTRY_CODE", "POPULATION")))

            # get latest rows for each country
            outbreak_rating <- latest_rows_by_country() %>%
                dplyr::select(dplyr::all_of(c("DATE_REPORTED", "COUNTRY_CODE", "COUNTRY", "NEW_CASES"))) %>%
                dplyr::left_join(y = pop, by = c("COUNTRY_CODE", "DATE_REPORTED")) %>%
                dplyr::mutate(OUTBREAK_RATING = calculate_outbreak_rating(new_cases = .data$NEW_CASES, population = .data$POPULATION)) %>%
                dplyr::mutate(OUTBREAK_DESC = describe_outbreak(.data$OUTBREAK_RATING))

            outbreak_rating
        }, label = "latest_outbreak_rating_by_country")

        # Pages ----------------------------------------------------------------
        overview_server("page_overview",
            daily_cases_filt = daily_cases_filt,
            vax_filt = vax_filt,
            population_filt = population_filt,
            latest_rows_by_country = latest_rows_by_country,
            latest_outbreak_rating_by_country = latest_outbreak_rating_by_country
        )
        world_map_server("world_map", latest_outbreak_rating_by_country = latest_outbreak_rating_by_country)
        news_feed_server("news_feed")
        country_comp_server("country_comp")
        data_explorer_server("country_comp")
        simulations_server("simulations")
        vaccines_server("vaccines")
        data_sources_server("data_sources")
        metrics_server("metrics")
    }

    return(shiny::moduleServer(id, module))
}
