#
# Page: Overview
#
# Starting page of the dashboard that gives a world overview of COVID.
#

overviewUI <- function(id) {
    ns <- NS(id)
    
    overview <- fluidPage(
        fluidRow(div(class = "top-padding")),
        fluidRow(
            column(width = 12
                   , valueBoxOutput(ns("new_cases")  , width = 3)
                   , valueBoxOutput(ns("new_deaths") , width = 3)
                   , valueBoxOutput(ns("new_vax")    , width = 3)
                   , ui_fit_in_valuebox(plotly::plotlyOutput(ns("gauge"), height = "250px"), width = 3)
                   )
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
        
        # TODO: build gauge
        output$gauge <- plotly::renderPlotly(expr = plot_gauge())
        

        # Time series plots ----------------------------------------------------

        # TODO
        
        return(output)
    }
    
    return(moduleServer(id, module))
}

