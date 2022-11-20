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
        fluidRow(
            column(width = 8, timeSeriesPlotUI(ns("plot_ts_cases"))),
            column(width = 4, 
                   shinydashboardPlus::box(
                       width = 12, title = "Top 5 Increases", collapsible = TRUE,
                       shinydashboardPlus::boxPad(
                           color = "gray",
                           descriptionBlock(
                               number = "17%", 
                               numberColor = "green", 
                               numberIcon = icon("caret-up"),
                               header = "$35,210.43", 
                               text = "AUSTRALIA", 
                               rightBorder = TRUE,
                               marginBottom = FALSE
                               ),
                           descriptionBlock(
                               number = "12%", 
                               numberColor = "green", 
                               numberIcon = icon("caret-up"),
                               header = "1m", 
                               text = "BRAZIL", 
                               rightBorder = TRUE,
                               marginBottom = FALSE
                           )
                           )
                       )
                   ),
        ),
        fluidRow(column(width = 8, timeSeriesPlotUI(ns("plot_ts_deaths")))
        ),
        fluidRow(column(width = 8, plotly::plotlyOutput(ns("plot_ts_vax")))
        )
    )
    
    return(overview)
}

overviewServer <- function(id, daily_cases, vax) {
    
    module <- function(input, output, session) {
        ns <- session$ns

        # Data -----------------------------------------------------------------
        
        # Daily cases
        daily_cases_filt <- reactive(daily_cases, label = "daily_cases_filt")
        headline_cases  <- reactive(calc_cases(daily_cases = daily_cases_filt()), label = "headline_cases")
        headline_deaths <- reactive(calc_deaths(daily_cases = daily_cases_filt()), label = "headline_deaths")
        
        # Vaccines
        vax_filt <- reactive(vax, label = "vax_filt")
        
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
        
        
        # Headline (top row) ---------------------------------------------------
        
        output$new_cases <- renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Cases", 
                new_cases   = headline_cases()$new_cases, 
                total_cases = headline_cases()$total_cases, 
                perc_inc    = headline_cases()$perc_inc, 
                icon        = shiny::icon("house-medical"))
        )
        
        output$new_deaths <- renderValueBox(
            expr = headline_value_box(
                subtitle    = "New Deaths", 
                new_cases   = headline_deaths()$new_cases, 
                total_cases = headline_deaths()$total_cases, 
                perc_inc    = headline_deaths()$perc_inc, 
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
        
        # timeSeriesControls()
        
        timeSeriesPlotServer(
            id = "plot_ts_cases",
            ts_data = daily_cases_ts,
            labels = list(yaxis = "New Cases", box_title = "Cases", xaxis = ""),
            deselected_traces = c("NEW_CASES")
        )
        
        timeSeriesPlotServer(
            id = "plot_ts_deaths",
            ts_data = daily_deaths_ts,
            labels = list(yaxis = "New Deaths", box_title = "Deaths", xaxis = ""),
            deselected_traces = c("NEW_DEATHS")
        )
        
        output$plot_ts_vax <- plotly::renderPlotly(expr = {
            plt <- blank_ts_plot()
        })
        
        return(output)
    }
    
    return(moduleServer(id, module))
}

