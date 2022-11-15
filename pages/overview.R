#
# Page: Overview
#
# Starting page of the dashboard that gives a world overview of COVID.
#

overviewUI <- function(id) {
    ns <- NS(id)
    
    overview <- fluidPage(
        fluidRow(div(class = "top-padding")),
        fluidRow(column(width = 12
                   , valueBoxOutput(ns("new_cases")  , width = 3)
                   , valueBoxOutput(ns("new_deaths") , width = 3)
                   , valueBoxOutput(ns("new_vax")    , width = 3)
                   , valueBoxOutput(ns("risk_rating"), width = 3)
                   )
        ),
        fluidRow(column(width = 12, plotly::plotlyOutput(ns("plot_ts_cases")))
        ), 
        fluidRow(column(width = 12, plotly::plotlyOutput(ns("plot_ts_death")))
        ),
        fluidRow(column(width = 12, plotly::plotlyOutput(ns("plot_ts_vax")))
        )
    )
    
    return(overview)
}

overviewServer <- function(id) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        
        # TODO: create global store and make reactive
        daily_cases <- get_daily_cases()
        cases  <- calc_cases(daily_cases)
        deaths <- calc_deaths(daily_cases)
        
        # Top row --------------------------------------------------------------
        
        output$new_cases <- renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Cases", 
                new_cases   = cases$new_cases, 
                total_cases = cases$total_cases, 
                perc_inc    = cases$perc_inc, 
                icon        = shiny::icon("house-medical"))
        )
        
        output$new_deaths <- renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Deaths", 
                new_cases   = deaths$new_cases, 
                total_cases = deaths$total_cases, 
                perc_inc    = deaths$perc_inc, 
                icon        = shiny::icon("skull"))
        )
        
        output$new_vax <- renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Vaccinations", 
                new_cases   = 0, 
                total_cases = 0, 
                perc_inc    = 0, 
                icon        = shiny::icon("syringe"))
        )
        
        
        output$risk_rating <- renderValueBox(
            expr = valueBox(
                value    = "High", 
                icon     = shiny::icon("gauge-high"),
                color    = "red",
                subtitle = HTML(paste0(
                    "<b>", "Global Risk", "</b>",
                    "<br>",
                    "There are multiple active outbreaks",
                    "<br>",
                    "and a high risk of spread.",
                    "<br>"
                ))
            )
        )
        
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

        # TODO - time series plots
        output$plot_ts_cases <- plotly::renderPlotly(expr = {
            daily_cases <- get_daily_cases() # FIXME: move data global store
            daily_cases_ts <- get_daily_agg(daily_cases, agg = sum, cols_sel = c("NEW_CASES"))
            daily_cases_ts_smoothed <- add_ma_smoothing(daily_cases_ts, cols_used = c("NEW_CASES"), orders = c(7, 30, 90, 180))
            plt <- blank_ts_plot(daily_cases_ts_smoothed)
            plt %>% 
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_CASES_MA_7DAY) %>% 
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_CASES_MA_30DAY) %>% 
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_CASES_MA_90DAY) %>% 
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_CASES_MA_180DAY)
        })
        
        output$plot_ts_death <- plotly::renderPlotly(expr = {
            daily_cases <- get_daily_cases() # FIXME: move data global store
            daily_cases_ts <- get_daily_agg(daily_cases, agg = sum, cols_sel = c("NEW_DEATHS"))
            daily_cases_ts_smoothed <- add_ma_smoothing(daily_cases_ts, cols_used = c("NEW_DEATHS"), orders = c(7, 30, 90, 180))
            plt <- blank_ts_plot(daily_cases_ts_smoothed)
            plt %>% 
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_DEATHS_MA_7DAY) %>% 
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_DEATHS_MA_30DAY) %>% 
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_DEATHS_MA_90DAY) %>%
                add_trace(data = daily_cases_ts_smoothed, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_DEATHS_MA_180DAY)
        })
        
        output$plot_ts_vax <- plotly::renderPlotly(expr = {
            daily_cases <- get_daily_cases() # FIXME: move data global store
            daily_cases_ts <- get_daily_agg(daily_cases, agg = sum, cols_sel = c("NEW_DEATHS"))
            daily_cases_ts_smoothed <- add_ma_smoothing(daily_cases_ts, cols_used = c("NEW_DEATHS"), orders = c(1))
            plt <- blank_ts_plot(daily_cases_ts_smoothed)
        })
        
        return(output)
    }
    
    return(moduleServer(id, module))
}

