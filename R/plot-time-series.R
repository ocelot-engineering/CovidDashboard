#
# Time series plot
#


# Blank canvas ------------------------------------------------------------

#' Generates a blank canvas time series plot
#'
#' @description  This will need to have data added to it
#'
#' @param data data frame: used when adding different data to an existing plot
#' @param labels list: e.g. `list(xaxis = "Date", yaxis = "Magnitude", title = "New Plot")`
#' @param colour_palette list: allows custom color pallet that overrides global
#' one. (see config/colour-palette.yaml for changable colours)
#'
#' @returns plotly plot_ly config layout
#'
#' @examples
#' \dontrun{
#' blank_ts_plot()
#' }
#'
#' @importFrom checkmate assert_data_frame assert_list
#' @importFrom plotly plot_ly config layout
#'
blank_ts_plot <- function(data = data.frame(), labels = list(), colour_palette = list()) {
    checkmate::assert_data_frame(data)
    checkmate::assert_list(labels)
    checkmate::assert_list(colour_palette)

    # Update color pallet
    default_colour_palette <- list(
        background = "#353c42"
      , light_highlight = "#bec5cb"
      , dark_highlight = "#272c30"
      , white = "#FFFFFF"
      , black = "#000000"
    )
    colour_palette <- modifyList(default_colour_palette, get_color_pal())

    # Update axis and title labels
    default_labels <- list(title = "", xaxis = "Date", yaxis = "Magnitude")
    labels <- modifyList(default_labels, labels)

    # Set up canvas
    fig <- plotly::plot_ly(data = data, type = "scatter", mode = "lines") %>%
        plotly::config(displayModeBar = FALSE) %>%
        plotly::config(displaylogo = FALSE)

    xaxis <- list(
        zerolinecolor = colour_palette$background,
        zerolinewidth = 2,
        gridcolor = colour_palette$background,
        title = list(text = labels$xaxis, font = list(color = colour_palette$light_highlight)),
        tickfont = list(color = colour_palette$light_highlight)
        )

    yaxis_left <- list(
        zerolinecolor = colour_palette$background,
        zerolinewidth = 2,
        gridcolor = colour_palette$background,
        title = list(text = labels$yaxis, font = list(color = colour_palette$light_highlight)),
        tickfont = list(color = colour_palette$light_highlight)
      )

    # Style plot and add labels
    fig <- fig %>%
        plotly::layout(
            title = labels$title,
            showlegend = TRUE,
            hovermode = "x unified",
            xaxis = xaxis,
            yaxis = yaxis_left,
            plot_bgcolor = colour_palette$dark_highlight,
            paper_bgcolor = colour_palette$background,
            legend = list(bgcolor = colour_palette$light_highlight, orientation = "h", xanchor = "center", x = 0.5)
            )

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
#' @importFrom plotly add_trace
#' @importFrom checkmate assert_string assert_data_frame
#'
build_ts_trace_fn <- function(x, data = NULL, type = "scatter", mode = "lines") {
    checkmate::assert_string(x)
    checkmate::assert_data_frame(data, null.ok = TRUE)
    checkmate::assert_string(type)
    checkmate::assert_string(mode)

    func <- function(p, y, ...) {

        output <- plotly::add_trace(
            p,
            data = data,
            type = type,
            mode = mode,
            x = as.formula(paste0("~", x)),
            y = as.formula(paste0("~", y)),
            name = y,
            ...
        )
        return(output)
    }
    return(func)
}


# Plotting all traces and layers ------------------------------------------

#' Plots a time series with all traces at once.
#'
#' @description This works by building the trace then calling the resulting
#' function with purrr. Therefore the traces need to have the same x axis.
#'
#' @param ts_data data frame: used when adding different data to an existing plot
#' @param x_col string: name of the x axis
#' @param y_cols character: vector of the col names that will be added to the plot
#' @param labels list: e.g. `list(xaxis = "Date", yaxis = "Magnitude", title = "New Plot")`
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
#'
#' @importFrom checkmate assert_data_frame assert_string assert_character assert_list
#' @importFrom dplyr setdiff
#' @importFrom purrr reduce
plot_all_ts_traces <- function(ts_data, x_col, y_cols, y_cols_hidden = c(), labels = list()) {
    checkmate::assert_data_frame(ts_data)
    checkmate::assert_string(x_col)
    checkmate::assert_character(y_cols)
    checkmate::assert_list(labels)

    # Harden inputs
    y_cols        <- c(y_cols)
    y_cols_hidden <- c(y_cols_hidden)

    # Initalise plot
    init_plt <- blank_ts_plot(data = ts_data, labels = labels, colour_palette = get_color_pal())

    # Build tracing function
    add_ts_trace <- build_ts_trace_fn(x = x_col)

    # Generate plot for all traces
    if (length(y_cols_hidden) > 0) {
        y_cols_visible <- dplyr::setdiff(y_cols, y_cols_hidden)
        plt <- purrr::reduce(.x = y_cols_visible, .f = add_ts_trace, .init = init_plt)
        plt <- purrr::reduce(.x = y_cols_hidden, .f = add_ts_trace, visible = "legendonly", .init = plt)
    } else {
        plt <- purrr::reduce(.x = y_cols, .f = add_ts_trace, .init = init_plt)
    }

    return(plt)
}


#' Add extra a list of single argument plotly layer functions
#'
#' @description All functions should take a single plot argument
#'
#' @param plt plotly: existing plot to add layers to
#' @param layers list of functions: list of single argument functions
#'
#' @returns plotly plot
#'
#' @importFrom checkmate assert_list
add_all_layers <- function(plt, layers) {
    checkmate::assert_list(layers)

    if (length(layers) > 0) {
        for (additional_layer in layers) {
            if (!is.function(additional_layer)) {
                warning("Can only pass functions into time_series_plot_server '...'.")
                next
            }
            plt <- plt %>% additional_layer()
        }
    }

    return(plt)
}
