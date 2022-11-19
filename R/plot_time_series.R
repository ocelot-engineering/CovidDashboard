#
# Time series plot
#


# Blank canvas ------------------------------------------------------------

#' Generates a blank canvas time series plot
#' 
#' @description  This will need to have data added to it
#' 
#' @param data data frame: used when adding different data to an existing plot
#' @param labels: list: e.g. `list(xaxis = "Date", yaxis = "Magnitude", title = "New Plot")`
#' @param colour_pallet: list: allows custom color pallet that overrides global 
#' one. (see config/colour_pallet.R for changable colours)
#' 
#' @returns plotly plot
#' 
#' @examples
#' \dontrun{
#' blank_ts_plot()
#' }
blank_ts_plot <- function(data = data.frame(), labels = list(), colour_pallet = list()) {
    checkmate::assert_data_frame(data)
    checkmate::assert_list(labels)
    checkmate::assert_list(colour_pallet)
    
    # Update color pallet
    default_colour_pallet <- list(
        background = "#353c42"
      , light_highlight = "#bec5cb"
      , dark_highlight = "#272c30"
      , white = "#FFFFFF"
      , black = "#000000"
    )
    colour_pallet <- modifyList(default_colour_pallet, colour_pallet)
    
    # Update axis and title labels
    default_labels <- list(title = "", xaxis = "Date", yaxis = "Magnitude")
    labels <- modifyList(default_labels, labels)
    
    # Set up canvas
    fig <- plot_ly(data = data) %>%
        config(displayModeBar = FALSE) %>% 
        config(displaylogo = FALSE)
    
    xaxis <- list(
        zerolinecolor = '#ffff',
        zerolinewidth = 2,
        gridcolor = 'ffff',
        title = labels$xaxis
        )
    
    yaxis_left <- list(
        zerolinecolor = '#ffff',
        zerolinewidth = 2,
        gridcolor = 'ffff',
        title = labels$yaxis
      )
    
    # yaxis_right <- list(
    #     overlaying = "y"
    #   , side = "right"
    #   , title = "<b>Reported Deaths</b> Deaths")
    
    # options(warn = -1)
    
    # Style plot and add labels
    fig <- fig %>%
        layout(
            title = labels$title,
            showlegend = FALSE,
            xaxis = xaxis,
            yaxis = yaxis_left,
            # yaxis2 = yaxis_right,
            plot_bgcolor = colour_pallet$dark_highlight,
            paper_bgcolor = colour_pallet$light_highlight)
    
    
    return(fig)
}



# Building trace ----------------------------------------------------------

#' Higher order function that builds a configured `plotly::add_trace`.
#' 
#' @description  Useful for consistent trace adding. 
#' 
#' @param x string: the x variable. A string is converted to a formula like ~X_AXIS
#' @param data data frame: used when adding different data to an existing plot
#' @param type string: type arg passed to trace type
#' @param mode string: mode arg passed to trace type
#' 
#' @returns function: configured add_trace
#' 
#' @examples
#' \dontrun{
#' add_ts_trace <- build_ts_trace_fn(x = "DATE")
#' }
build_ts_trace_fn <- function(x, data = NULL, type = "scatter", mode = "lines") {
    checkmate::assert_string(x)
    checkmate::assert_data_frame(data, null.ok = TRUE)
    checkmate::assert_string(type)
    checkmate::assert_string(mode)
    
    func <- function(p, y) {
        output <- add_trace(
            p,
            data = data, 
            type = type, 
            mode = mode, 
            x = make_formula(x, prefix = "~"), 
            y = make_formula(y, prefix = "~")
        )
        return(output)
    }
    return(func)
}



# Plotting all traces -----------------------------------------------------



#' Plots a time series with all traces at once.
#' 
#' @description This works by building the trace then calling the resulting 
#' function with purrr. Therefore the traces need to have the same x axis.
#' 
#' @param ts_data: data frame: used when adding different data to an existing plot
#' @param x_col: string: name of the x axis
#' @param y_cols: character: vector of the col names that will be added to the plot
#' @param labels: list: e.g. `list(xaxis = "Date", yaxis = "Magnitude", title = "New Plot")`
#' 
#' @returns plotly plot
#' 
#' @examples
#' \dontrun{
#' plot_all_ts_traces(
#' ts_data = data.frame(), 
#' x = "DATE_REPORTED", 
#' y = c("NEW_CASES_MA_7DAY", "NEW_CASES_MA_90DAY") 
#' labels = list(yaxis = "New Cases"))
#' }
plot_all_ts_traces <- function(ts_data, x_col, y_cols, labels = list()) {
    checkmate::assert_data_frame(ts_data)
    checkmate::assert_string(x_col)
    checkmate::assert_character(y_cols)
    checkmate::assert_list(labels)
    
    # Initalise plot
    init_plt <- blank_ts_plot(data = ts_data, labels = labels, colour_pallet = colour_pallet)
    
    # Build tracing function
    add_ts_trace <- build_ts_trace_fn(x = x_col)
    
    # Generate plot for all traces
    plt <- purrr::reduce(.x = y_cols, .f = add_ts_trace, .init = init_plt)
    
    return(plt)
}
