#
# Time series plot
#

timeSeriesPlotUI <- function(id, ...) {
    ns <- NS(id)
    
    html_output <- shinydashboardPlus::box(
        width = 12, 
        title = textOutput(ns("box_name")), 
        collapsible = TRUE,
        dropdownMenu = shinydashboardPlus::boxDropdown(
            shinydashboardPlus::boxDropdownItem("Add Trace", id = ns("open_plot_config"), icon = icon("chart-line")),
            shinydashboardPlus::dropdownDivider(),
            shinydashboardPlus::boxDropdownItem("See data sources", href = proj_config$who_link)
        ),
        fluidRow(column(width = 12, plotly::plotlyOutput(ns("plot_time_series"))))
    )
    
    return(html_output)
}


timeSeriesPlotServer <- function(id, ts_data, labels = list(yaxis = "", box_title = ""), deselected_traces = c()) {
    
    module <- function(input, output, session) {
        
        # Data -----------------------------------------------------------------
        
        # Select-able lines for the plot
        x_col <- "DATE_REPORTED"
        deselected_traces <- c(deselected_traces)
        
        # All columns to be put on the graph
        y_cols <- reactive({
            col_names <- colnames(ts_data())
            y_cols <- sort(col_names[!col_names %in% x_col])
            return(y_cols)
        }, label = "y_cols_ts_plot")
        
        # Hidden cols still put on the graph, but deselected by default
        y_deselected_cols <- reactive({
            deselected_traces[deselected_traces %in% y_cols()]
        }, label = "y_deselected_cols_ts_plot")
        

        # Observes -------------------------------------------------------------
        
        # Open modal to add more traces
        observeEvent(input$open_plot_config, {
                showModal(
                    modalDialog(
                        "Coming soon.",
                        title     = "Add custom traces to plot",
                        footer    = modalButton("Dismiss"),
                        easyClose = TRUE,
                        fade      = TRUE
                        )
                )
        })
        

        # Outputs --------------------------------------------------------------
        
        # Render box title
        output$box_name <- renderText({
            output <- if (isTruthy(labels$box_title)) {
                labels$box_title
            } else if (isTruthy(labels$yaxis)) {
                labels$yaxis
            } else {
                ""
            }
        })
        
        # Render plot
        output$plot_time_series <- plotly::renderPlotly(expr = {
            req(ts_data())
            req(y_cols())
            req(y_deselected_cols())
            
            plot_all_ts_traces(
                ts_data       = ts_data(), 
                x             = x_col, 
                y_cols        = y_cols(), 
                y_cols_hidden = y_deselected_cols(),
                labels        = labels
                )
        })
        
        return(invisible(NULL))
    }
    
    return(moduleServer(id, module))
}
