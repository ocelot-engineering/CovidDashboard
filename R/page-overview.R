#
# Page: Overview
#
# Starting page of the dashboard that gives a world overview of COVID.
#

#' Page: Overview ui function
#'
#' @inherit module_docs params
#' @importFrom leaflet leafletOutput
#' @importFrom shinydashboardPlus box
#' @importFrom shinydashboard valueBoxOutput
#' @importFrom plotly plotlyOutput
#'
overview_ui <- function(id) {
    ns <- shiny::NS(id)

    overview <- shiny::fluidPage(
        shiny::fluidRow(shiny::div(class = "top-padding")),
        shiny::fluidRow(shiny::column(width = 12
                   , shinydashboard::valueBoxOutput(outputId = ns("new_cases"),   width = 3)
                   , shinydashboard::valueBoxOutput(outputId = ns("new_deaths"),  width = 3)
                   , shinydashboard::valueBoxOutput(outputId = ns("new_vax"),     width = 3)
                   , shinydashboard::valueBoxOutput(outputId = ns("risk_rating"), width = 3)
                   )
        ),
        shiny::fluidRow(
            shiny::column(width = 7,
                time_series_plot_ui(id = ns("plot_ts_cases")),
                time_series_plot_ui(id = ns("plot_ts_deaths"))
            ),
            shiny::column(width = 5,
                shinydashboardPlus::box(
                    width = 12,
                    title = "World Map",
                    collapsible = TRUE,
                    leaflet::leafletOutput(outputId = ns("world_map"))
                ),
                time_series_plot_ui(id = ns("plot_ts_outbreak"))
            )
        )
    )

    return(overview)
}

#' Page: Overview server function
#' @inherit common_docs params
#' @inherit module_docs params
#' @importFrom shinydashboard renderValueBox valueBox
#' @importFrom dplyr group_by summarise across all_of left_join select mutate
#'
overview_server <- function(id, daily_cases_filt, vax_filt, population_filt, latest_rows_by_country, latest_outbreak_rating_by_country) {

    module <- function(input, output, session) {

        # Data -----------------------------------------------------------------

        # Headline data
        headline_cases  <- reactive(calc_cases(daily_cases = daily_cases_filt()), label = "headline_cases")
        headline_deaths <- reactive(calc_deaths(daily_cases = daily_cases_filt()), label = "headline_deaths")
        headline_vax    <- reactive(calc_vax(vax_filt = vax_filt()), label = "headline_vax")

        # Population
        world_population <- reactive({
            population_filt() %>%
                dplyr::group_by(.data$DATE_REPORTED) %>%
                dplyr::summarise(dplyr::across(dplyr::all_of("POPULATION"), sum))
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
                dplyr::select(-dplyr::all_of("NEW_DEATHS"))

            outbreak_ratings <- generate_daily_outbreak_ratings(daily_cases_w_pop = daily_cases_w_pop)

            smooth_daily_agg(
                daily_agg = outbreak_ratings,
                cols_used = "OUTBREAK_RATING",
                custom_ma_orders = c(180)) # make custom_ma_orders reactive
        }, label = "daily_outbreak_rating_ts")

        # Outbreak rating
        latest_outbreak_rating <- reactive({
            # outbreak rating for latest date for all countries

            # Get population cols
            pop <- population_filt() %>% dplyr::select(dplyr::all_of(c("DATE_REPORTED", "COUNTRY_CODE", "POPULATION")))

            # get latest rows for each country, then sum up to a singledate
            outbreak_rating <- latest_rows_by_country() %>%
                dplyr::select(dplyr::all_of(c("DATE_REPORTED", "COUNTRY_CODE", "NEW_CASES"))) %>%
                dplyr::left_join(y = pop, by = c("COUNTRY_CODE", "DATE_REPORTED")) %>%
                dplyr::summarise(
                    UNQ_DATES = dplyr::n_distinct(.data$DATE_REPORTED)
                  , UNQ_COUNTRIES = dplyr::n_distinct(.data$COUNTRY_CODE)
                  , NEW_CASES = sum(.data$NEW_CASES)
                  , POPULATION = sum(.data$POPULATION)
                ) %>%
                dplyr::mutate(OUTBREAK_RATING = calculate_outbreak_rating(new_cases = .data$NEW_CASES, population = .data$POPULATION)) %>%
                dplyr::mutate(OUTBREAK_DESC = describe_outbreak(.data$OUTBREAK_RATING))

            outbreak_rating
        }, label = "latest_outbreak_rating")


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
                subtitle     = "People Fully Vaccinated",
                new_cases    = headline_vax()$persons_fully_vaxxed,
                total_cases  = headline_vax()$total_vax_given,
                total_suffix = "total vaccines administered",
                perc_inc     = NULL, # NULL to remove message (don't have this info)
                icon         = shiny::icon("syringe"))
        )

        output$risk_rating <- shinydashboard::renderValueBox({

            outbreak_rating <- latest_outbreak_rating()
            desc <- outbreak_rating$OUTBREAK_DESC[1]
            color <- get_outbreak_rating_types(label = desc)$colors[1]

            subtitle_notes <- if (outbreak_rating$OUTBREAK_RATING > 0) {
                paste0(
                    "There are active outbreaks",
                    "<br>",
                    "and a ", tolower(desc), " risk of spread."
                )
            } else {
                paste0(
                    "Outbreaks are currently well contained.",
                    "<br>",
                    "However, communities should remain cautious."
                )
            }

            shinydashboard::valueBox(
                value    = desc,
                icon     = shiny::icon("gauge-high"),
                color    = color,
                subtitle = HTML(paste0(
                    "<b>", "Outbreak rating", "</b>",
                    "<br>",
                    subtitle_notes,
                    "<br>"
                ))
            )
        })


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
