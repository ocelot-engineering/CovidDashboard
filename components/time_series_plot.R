#
# Time series plot
#

timeSeriesPlotUI <- function(id, ...) {
    ns <- NS(id)
    
    html_output <- fluidRow(
        fluidRow(
            column(width = 4, selectInput(ns("ts_views"), label = "Views",choices = NULL, selected = NULL, multiple = TRUE)),
            column(width = 4, actionButton(ns("open_custom_view_modal"), label = "Add View", icon = shiny::icon("chart-line")))
        ),
        fluidRow(column(width = 12, plotly::plotlyOutput(ns("plot_time_series"))))
    )
    
    return(html_output)
}


timeSeriesPlotServer <- function(id, ts_data, y_cols, labels = list(yaxis = "New Cases")) {
    
    module <- function(input, output, session) {
        
        # Select-able lines for the plot
        x_col <- "DATE_REPORTED"
        
        y_cols <- reactive({
            col_names <- colnames(ts_data())
            y_cols <- sort(col_names[!col_names %in% x_col])
            return(y_cols)
        }, label = "y_cols_ts_plot")
        
        
        # Update select-able lines for the plot
        observeEvent(y_cols(), {
            
            prefered_choice <- 2:3
            if (length(y_cols()) >= max(prefered_choice)) {
                selected_choice <- y_cols()[prefered_choice]
            } else {
                selected_choice <- NULL
            }
            
            updateSelectizeInput(session, 
                                 inputId = "ts_views", 
                                 choices = y_cols(), 
                                 selected = selected_choice,
                                 server = FALSE)
        })
        
        
        # Render plot
        output$plot_time_series <- plotly::renderPlotly(expr = {
            req(input$ts_views)
            
            plot_all_ts_traces(
                ts_data = ts_data(), 
                x       = x_col, 
                y       = input$ts_views, 
                labels  = labels
                )
        })
        
        return(invisible(NULL))
    }
    
    return(moduleServer(id, module))
}
