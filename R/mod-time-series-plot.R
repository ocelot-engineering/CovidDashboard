#
# Time series plot
#

#' Module: Time series plot ui function
#'
#' @inherit module_docs params
#' @importFrom shinydashboardPlus box boxDropdown boxDropdownItem dropdownDivider
#' @importFrom plotly plotlyOutput
#'
time_series_plot_ui <- function(id, show_dropdown = TRUE, collapsible = TRUE, ...) {
    ns <- shiny::NS(id)

    # Drop down menu for adding traces and showing sources
    dropdown_menu <- if (show_dropdown) {
        shinydashboardPlus::boxDropdown(
            shinydashboardPlus::boxDropdownItem("Add Trace", id = ns("open_plot_config"), icon = shiny::icon("chart-line")),
            shinydashboardPlus::dropdownDivider(),
            shinydashboardPlus::boxDropdownItem("See data sources", href = proj_config$who_link)
        )
    } else {
        NULL
    }

    html_output <- shinydashboardPlus::box(
        width = 12,
        title = shiny::textOutput(outputId = ns("box_name")),
        collapsible = collapsible,
        dropdownMenu = dropdown_menu,
        shiny::fluidRow(shiny::column(width = 12, plotly::plotlyOutput(ns("plot_time_series"))))
    )

    return(html_output)
}


#' Module: Time series plot server function
#'
#' @inherit module_docs params
#' @importFrom plotly renderPlotly
#'
time_series_plot_server <- function(id, ts_data, labels = list(yaxis = "", box_title = ""), deselected_traces = c(), ...) {

    module <- function(input, output, session) {

        # Data -----------------------------------------------------------------

        # Select-able lines for the plot
        x_col <- "DATE_REPORTED"
        deselected_traces <- c(deselected_traces)

        # All columns to be put on the graph
        y_cols <- shiny::reactive({
            col_names <- colnames(ts_data())
            y_cols <- sort(col_names[!col_names %in% x_col])
            return(y_cols)
        }, label = "y_cols_ts_plot")

        # Hidden cols still put on the graph, but deselected by default
        y_deselected_cols <- shiny::reactive({
            deselected_traces[deselected_traces %in% y_cols()]
        }, label = "y_deselected_cols_ts_plot")


        # Observes -------------------------------------------------------------

        # Open modal to add more traces
        shiny::observeEvent(input$open_plot_config, {
                shiny::showModal(
                    shiny::modalDialog(
                        "Coming soon.",
                        title     = "Add custom traces to plot",
                        footer    = shiny::modalButton("Dismiss"),
                        easyClose = TRUE,
                        fade      = TRUE
                        )
                )
        })


        # Outputs --------------------------------------------------------------

        # Render box title
        output$box_name <- shiny::renderText({
            output <- if (shiny::isTruthy(labels$box_title)) {
                labels$box_title
            } else if (shiny::isTruthy(labels$yaxis)) {
                labels$yaxis
            } else {
                ""
            }
        })

        # Render plot
        output$plot_time_series <- plotly::renderPlotly(expr = {
            shiny::req(ts_data())
            shiny::req(y_cols())
            shiny::req(y_deselected_cols())

            plot_all_ts_traces(
                ts_data       = ts_data(),
                x             = x_col,
                y_cols        = y_cols(),
                y_cols_hidden = y_deselected_cols(),
                labels        = labels
            ) %>% add_all_layers(layers = list(...))

        })

        return(invisible(NULL))
    }

    return(shiny::moduleServer(id, module))
}