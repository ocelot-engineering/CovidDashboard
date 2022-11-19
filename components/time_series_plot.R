#
# Time series plot
#

timeSeriesPlotUI <- function(id, ...) {
    ns <- NS(id)
    
    html_output <- plotly::plotlyOutput(ns("plot_time_series"))
    
    return(html_output)
}


timeSeriesPlotServer <- function(id, ts_data, x_col, y_cols, labels = list(yaxis = "New Cases")) {
    
    module <- function(input, output, session) {
        
        output$plot_time_series <- plotly::renderPlotly(expr = {
            plot_all_ts_traces(
                ts_data = ts_data, 
                x       = x_col, 
                y       = y_cols, 
                labels  = labels
                )
        })
        
        return(invisible(NULL))
    }
    
    return(moduleServer(id, module))
}
