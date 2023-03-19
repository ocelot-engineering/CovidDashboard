#
# Page: Overview
#
# Starting page of the dashboard that gives a world overview of COVID.
#

#' Page: Overview ui function
#' @inherit module_docs params
#' @importFrom leaflet leafletOutput
#' @importFrom shinydashboardPlus box
#' @importFrom shinydashboard valueBoxOutput
#' @importFrom plotly plotlyOutput
overview_ui <- function(id) {
    ns <- shiny::NS(id)

    overview <- shiny::fluidPage(
        shiny::fluidRow(shiny::div(class = "top-padding")),
        shiny::fluidRow(shiny::column(width = 12
                   , shinydashboard::valueBoxOutput(outputId = ns("new_cases")  , width = 3)
                   , shinydashboard::valueBoxOutput(outputId = ns("new_deaths") , width = 3)
                   , shinydashboard::valueBoxOutput(outputId = ns("new_vax")    , width = 3)
                   , shinydashboard::valueBoxOutput(outputId = ns("risk_rating"), width = 3)
                   )
        ),
        shiny::fluidRow(
            shiny::column(width = 7, time_series_plot_ui(id = ns("plot_ts_cases"))),
            shiny::column(width = 5, time_series_plot_ui(id = ns("plot_ts_outbreak")))
        ),
        shiny::fluidRow(
            shiny::column(width = 7, time_series_plot_ui(id = ns("plot_ts_deaths"))),
            shiny::column(width = 5, 
                   shinydashboardPlus::box(
                        width = 12,
                        title = "World Map",
                        collapsible = TRUE,
                        leaflet::leafletOutput(outputId = ns("world_map"))
                    )
            )
        ),
        shiny::fluidRow(
            shiny::column(width = 7, plotly::plotlyOutput(ns("plot_ts_vax"))),
            shiny::column(width = 5,
                shinydashboardPlus::box(
                    width = 12,
                    title = "Top 5 Increases",
                    collapsible = TRUE,
                    shinydashboardPlus::boxPad(
                        color = "gray",
                        shinydashboardPlus::descriptionBlock(
                            number = "17%", 
                            numberColor = "green", 
                            numberIcon = shiny::icon("caret-up"),
                            header = "$35,210.43", 
                            text = "AUSTRALIA", 
                            rightBorder = TRUE,
                            marginBottom = FALSE
                        ),
                        shinydashboardPlus::descriptionBlock(
                            number = "12%", 
                            numberColor = "green", 
                            numberIcon = shiny::icon("caret-up"),
                            header = "1m", 
                            text = "BRAZIL", 
                            rightBorder = TRUE,
                            marginBottom = FALSE
                        )
                    )
                )
            )
        )
    )

    return(overview)
}

#' Page: Overview server function
#' @inherit module_docs params
#' @importFrom shinydashboard renderValueBox valueBox
overview_server <- function(id, daily_cases, vax, population) {

    module <- function(input, output, session) {
        ns <- session$ns

        # Data -----------------------------------------------------------------

        # Daily cases
        daily_cases_filt <- reactive(daily_cases, label = "daily_cases_filt")
        headline_cases  <- reactive(calc_cases(daily_cases = daily_cases_filt()), label = "headline_cases")
        headline_deaths <- reactive(calc_deaths(daily_cases = daily_cases_filt()), label = "headline_deaths")

        # Vaccines
        vax_filt <- reactive(vax, label = "vax_filt")

        # Population
        population_filt <- reactive(population, label = "population")

        world_population <- reactive({
            population_filt() %>% 
                dplyr::group_by(DATE_REPORTED) %>%
                dplyr::summarise(dplyr::across(POPULATION, sum))
        })

        # Time series data
        daily_agg <- reactive({
            # Aggregated daily cases at daily level
            get_daily_agg(
                daily_cases = daily_cases_filt(),
                agg = sum,
                cols_sel = c("NEW_CASES", "NEW_DEATHS"))
        }, label = "daily_agg")

        daily_cases_ts <- reactive({
            # Aggregated daily cases at daily level with moving average smoothing
            smooth_daily_agg(
                daily_agg = daily_agg(),
                cols_used = "NEW_CASES",
                custom_ma_orders = c(180)) # make custom_ma_orders reactive
        }, label = "daily_cases_ts")

        daily_deaths_ts <- reactive({
            # Aggregated daily deaths at daily level with moving average smoothing
            smooth_daily_agg(
                daily_agg = daily_agg(),
                cols_used = "NEW_DEATHS",
                custom_ma_orders = c(180)) # make custom_ma_orders reactive
        }, label = "daily_deaths_ts")

        daily_outbreak_rating_ts <- reactive({
            # Aggregated daily outbreak rating at daily level with moving average smoothing
            daily_cases_w_pop <- dplyr::left_join(
                daily_agg(), 
                world_population(), 
                by = c("DATE_REPORTED")) %>%
                dplyr::select(-NEW_DEATHS)

            outbreak_ratings <- generate_daily_outbreak_ratings(daily_cases_w_pop = daily_cases_w_pop)

            smooth_daily_agg(
                daily_agg = outbreak_ratings,
                cols_used = "OUTBREAK_RATING",
                custom_ma_orders = c(180)) # make custom_ma_orders reactive
        }, label = "daily_outbreak_rating_ts")

        latest_rows_by_country <- reactive({
            # latest rows for each country
            get_latest_info_by_country(daily_cases_filt(), lag = 0)
        }, label = "latest_rows_by_country")

        latest_outbreak_rating <- reactive({
            # outbreak rating for latest date for all countries

            # Get population cols
            pop <- population_filt() %>% dplyr::select(DATE_REPORTED, COUNTRY_CODE, POPULATION)

            # get latest rows for each country, then sum up to a singledate
            outbreak_rating <- latest_rows_by_country() %>%
                dplyr::select(DATE_REPORTED, COUNTRY_CODE, NEW_CASES) %>%
                dplyr::left_join(y = pop, by = c("COUNTRY_CODE", "DATE_REPORTED")) %>%
                dplyr::summarise(
                    UNQ_DATES = dplyr::n_distinct(DATE_REPORTED)
                  , UNQ_COUNTRIES = dplyr::n_distinct(COUNTRY_CODE)
                  , NEW_CASES = sum(NEW_CASES)
                  , POPULATION = sum(POPULATION)
                ) %>% 
                dplyr::mutate(OUTBREAK_RATING = calculate_outbreak_rating(new_cases = NEW_CASES, population = POPULATION)) %>%
                dplyr::mutate(OUTBREAK_DESC = describe_outbreak(OUTBREAK_RATING))

            outbreak_rating
        }, label = "latest_outbreak_rating")


        latest_outbreak_rating_by_country <- reactive({
            # outbreak rating for latest date for each countries

            # Get population cols
            pop <- population_filt() %>% dplyr::select(DATE_REPORTED, COUNTRY_CODE, POPULATION)

            # get latest rows for each country
            outbreak_rating <- latest_rows_by_country() %>%
                dplyr::select(DATE_REPORTED, COUNTRY_CODE, COUNTRY, NEW_CASES) %>%
                dplyr::left_join(y = pop, by = c("COUNTRY_CODE", "DATE_REPORTED")) %>%
                dplyr::mutate(OUTBREAK_RATING = calculate_outbreak_rating(new_cases = NEW_CASES, population = POPULATION)) %>%
                dplyr::mutate(OUTBREAK_DESC = describe_outbreak(OUTBREAK_RATING))

            outbreak_rating
        }, label = "latest_outbreak_rating_by_country")

        # Headline (top row) ---------------------------------------------------

        output$new_cases <- shinydashboard::renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Cases", 
                new_cases   = headline_cases()$new_cases, 
                total_cases = headline_cases()$total_cases, 
                perc_inc    = headline_cases()$perc_inc, 
                icon        = shiny::icon("house-medical"))
        )

        output$new_deaths <- shinydashboard::renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Deaths", 
                new_cases   = headline_deaths()$new_cases, 
                total_cases = headline_deaths()$total_cases, 
                perc_inc    = headline_deaths()$perc_inc, 
                icon        = shiny::icon("skull"))
        )

        output$new_vax <- shinydashboard::renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Vaccinations", 
                new_cases   = 0, 
                total_cases = 0, 
                perc_inc    = 0, 
                icon        = shiny::icon("syringe"))
        )


        output$risk_rating <- shinydashboard::renderValueBox({

            outbreak_rating <- latest_outbreak_rating()
            desc <- outbreak_rating$OUTBREAK_DESC[1]
            color <- get_outbreak_rating_types(label = desc)$colors[1]

            expr = shinydashboard::valueBox(
                value    = desc, 
                icon     = shiny::icon("gauge-high"),
                color    = color,
                subtitle = HTML(paste0(
                    "<b>", "Outbreak rating", "</b>",
                    "<br>",
                    "There are multiple active outbreaks",
                    "<br>",
                    "and a ", tolower(desc), " risk of spread.",
                    "<br>"
                ))
            )
        })

        # TODO: Risk rating (daily cases per 100k people)
        calc_risk_rating <- function() {
            # TODO: historical population is available from OECD
            # this is a mid-year estimate of the total population.
            # will assume linear growth to impute data to a daily level.
            # e.g. Country X has a population of 20 in 2019 and 30 and 2020.
            #      this means July 1st 2019 the population is 20, July 1st 2020
            #      the population is 30, and January 1st 2020 the population is
            #      25, (from (30 - 20) / 365 *( 365/2 ) ) . This means spikes in
            #      population (from mass refugee immigration for example), will
            #      not be captured at a fine grain level. 
            #      TODO: note justification for metrics and decisions like this. 
        }


        # Time series plots ----------------------------------------------------

        time_series_plot_server(
            id = "plot_ts_cases",
            ts_data = daily_cases_ts,
            labels = list(yaxis = "New Cases", box_title = "Cases", xaxis = ""),
            deselected_traces = c("NEW_CASES")
        )

        time_series_plot_server(
            id = "plot_ts_deaths",
            ts_data = daily_deaths_ts,
            labels = list(yaxis = "New Deaths", box_title = "Deaths", xaxis = ""),
            deselected_traces = c("NEW_DEATHS")
        )

        time_series_plot_server(
            id = "plot_ts_outbreak",
            ts_data = daily_outbreak_rating_ts,
            labels = list(yaxis = "Outbreak Rating", box_title = "Outbreak Rating", xaxis = ""),
            deselected_traces = c("OUTBREAK_RATING", "OUTBREAK_RATING_MA_30DAY", "OUTBREAK_RATING_MA_90DAY", "OUTBREAK_RATING_MA_180DAY"),
            make_outbreak_rating_shading_layer_fn( # produces the layers for background color shading
                xmin = min(daily_outbreak_rating_ts()[["DATE_REPORTED"]]), 
                xmax = max(daily_outbreak_rating_ts()[["DATE_REPORTED"]])
            )
        )

        output$plot_ts_vax <- plotly::renderPlotly(expr = {
            plt <- blank_ts_plot()
        })


        output$world_map <- leaflet::renderLeaflet({
            outbreak_ratings <- latest_outbreak_rating_by_country() %>% 
                dplyr::select(dplyr::all_of(c(
                    "COUNTRY_CODE",
                    "COUNTRY",
                    "OUTBREAK_RATING",
                    "OUTBREAK_DESC"))
                    )

            plt <- plot_world_map(outbreak_ratings)
        })

        return(invisible())
    }

    return(moduleServer(id, module))
}
