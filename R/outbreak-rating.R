#
# Outbreak rating (metric)
#
# A metric that describes the outbreak magnitude of a particular point in time.
#  "outbreak rating" is a general metric and only looks at one particular
#  dimension. While it could be thought that a higher outbreak rating means more
#  deaths and more chance of spread, this kind of assumption is not ideal since
#  the metric doesn't take into account other factors that influence this.
#  For example, outbreak rating directly measures the new cases per 100k people
#  (with a max limit). A higher number of new cases will mean that there is a
#  higher chance that someone in this population will catch it. But it doesn't
#  take into account many significant factors such as where the outbreaks are in
#  the country or if there are any restrictions or stay at home orders.
# Therefore this outbreak metric should be thought of as a direct measure of
#  what it is, which is the new cases to population ratio, rather than risk of
#  spread or risk of death.
#
# TODO: historical population is available from OECD
# this is a mid-year estimate of the total population.
# will assume linear growth to impute data to a daily level.
# e.g. Country X has a population of 20 in 2019 and 30 and 2020.
#      this means July 1st 2019 the population is 20, July 1st 2020
#      the population is 30, and January 1st 2020 the population is
#      25, (from (30 - 20) / 365 *( 365/2 ) ) . This means spikes in
#      population (from mass refugee immigration for example), will
#      not be captured at a fine grain level.
#


#' Generates a dataset including daily outbreak ratings.
#'
#' @param daily_cases_w_pop data frame: includes DATE_REPOTED, COUNTRY_CODE,
#' NEW_CASES and POPULATION columns
#'
#' @returns tibble dataset with date, country, outbreak rating and outbreak description
#'
#' @seealso `calculate_outbreak_rating`, `describe_outbreak`
#'
#' @examples
#' \dontrun{
#' daily_cases_sel <- get_daily_cases() %>% dplyr::select(DATE_REPORTED, COUNTRY_CODE, NEW_CASES)
#' population_sel <- get_population() %>% dplyr::select(DATE_REPORTED, COUNTRY_CODE, COUNTRY, POPULATION)
#' daily_cases_w_pop <- dplyr::left_join(daily_cases_sel, population_sel, by = c("DATE_REPORTED", "COUNTRY_CODE"))
#' outbreak_ratings = generate_daily_outbreak_ratings(daily_cases_w_pop)
#' }
#'
#' @importFrom dplyr mutate
#'
generate_daily_outbreak_ratings <- function(daily_cases_w_pop) {
    checkmate::assert_tibble(daily_cases_w_pop)

    daily_outbreak_ratings <- daily_cases_w_pop %>%
        dplyr::mutate(OUTBREAK_RATING = calculate_outbreak_rating(new_cases = .data$NEW_CASES, population = .data$POPULATION)) %>%
        dplyr::mutate(OUTBREAK_DESC = describe_outbreak(.data$OUTBREAK_RATING))

    return(daily_outbreak_ratings)
}


#' Calculates the outbreak rating based on new cases to population ratio.
#'
#' @param new_cases numeric: number of newly reported cases
#' @param population numeric: population at the time of newly reported cases
#'
#' @returns integer between 0 and 100
#'
#' @seealso `generate_daily_outbreak_ratings`, `describe_outbreak`
#'
#' @examples
#' \dontrun{
#' outbreak_rating <- calculate_outbreak_rating(new_cases = 25, population = 100000)
#' }
#'
#' @importFrom checkmate assert_numeric
#'
calculate_outbreak_rating <- function(new_cases, population) {
    checkmate::assert_numeric(new_cases)
    checkmate::assert_numeric(population)

    per_x_population <- 100000
    min_rating <- 0
    max_rating <- 100
    unknown_rating <- NA_integer_

    outbreak_rating <- per_x_population * (new_cases / population)
    outbreak_rating <- ifelse(is.infinite(outbreak_rating), unknown_rating, outbreak_rating)
    outbreak_rating <- ifelse(outbreak_rating < min_rating, min_rating, outbreak_rating)
    outbreak_rating <- ifelse(outbreak_rating > max_rating, max_rating, outbreak_rating)
    outbreak_rating <- round(outbreak_rating, 0)

    return(outbreak_rating)
}


#' Generates a description based on the outbreak rating.
#'
#' @description Based on thresholds.
#'
#' @param outbreak_rating integer: outbreak rating generated by `calculate_outbreak_rating`
#'
#' @returns string describing the outbreak rating
#'
#' @seealso `generate_daily_outbreak_ratings`, `calculate_outbreak_rating`
#'
#' @examples
#' \dontrun{
#' describe_outbreak(c(0, 1, 29, 100, -1))
#' }
#'
#' @importFrom checkmate assert_numeric
#'
describe_outbreak <- function(outbreak_rating) {
    checkmate::assert_numeric(outbreak_rating, null.ok = TRUE)

    thresholds <- get_outbreak_rating_types()$thresholds
    labels     <- get_outbreak_rating_types()$labels
    output     <- as.character(cut(outbreak_rating, breaks = thresholds, labels = labels, right = FALSE))

    return(output)
}


#' Generates the labels, descriptions and thresholds for each outbreak rating type.
#'
#' @param label string: filters the color and threshold based on the associated label
#' @param color string: filters the label and threshold based on the associated color
#'
#' @returns list of thresholds, labels and colors
#'
#' @seealso `describe_outbreak`
#'
#' @examples
#' \dontrun{
#' get_outbreak_rating_types()
#' get_outbreak_rating_types(label = "Low")
#' get_outbreak_rating_types(color = "maroon")
#' get_outbreak_rating_types("Maximum")
#' }
#'
#' @importFrom checkmate assert_string
#'
get_outbreak_rating_types <- function(label = NULL, color = NULL) {
    checkmate::assert_string(label, null.ok = TRUE)
    checkmate::assert_string(label, null.ok = TRUE)

    # Thresholds, labels and colors
    thresholds <- c(0,              1,          10,         20,      30, .Machine$integer.max)
    labels     <- c("No new cases", "Low",      "Medium",   "High",  "Extreme")
    colors     <- c("green",      "yellow", "orange", "red", "maroon")

    # Querying for label or color. Returns all if nothing is found.
    idx <- integer(0)
    if (!is.null(label)) {
        idx <- which(labels == label)
    }

    if (!is.null(color)) {
        idx <- which(colors == color)
    }

    if (length(idx) > 0) {
        thresholds <- thresholds[idx:(idx + 1)]
        labels <- labels[idx]
        colors <- colors[idx]
    }

    # Output list
    output <- list(
        thresholds = thresholds,
        labels     = labels,
        colors     = colors
    )
    return(output)
}


# Generating outbreak shading for plots -----------------------------------

#' Generates the shading layers for the outbreak rating plot
#'
#' @param xmin date as a string in "yyyy-mm-dd": where the plot starts on the x-axis
#' @param xmax date as a string in "yyyy-mm-dd": where the plot ends on the x-axis
#'
#' @returns list: list of layers for plotly plot
#'
#' @seealso `get_outbreak_rating_types`
#'
#' @examples
#' \dontrun{
#' generate_outbreak_rating_shading_layers("2022-03-01", "2022-06-10")
#' }
#'
#' @importFrom checkmate assert_date
#'
generate_outbreak_rating_shading_layers <- function(xmin, xmax) {
    checkmate::assert_date(xmin)
    checkmate::assert_date(xmax)

    # Initalise all shading layers
    shading_layers <- list()

    # Function to initalise shading layer
    init_shading_layer <- function() {
        init_shading_layer <- list(
            type = "rect",
            opacity = 0.1,
            x0 = xmin,
            x1 = xmax,
            xref = "x",
            yref = "y"
        )

        return(init_shading_layer)
    }

    # Get outbreak rating classifications ratings and the count of ratings for
    #  looping.
    o_rate_classifications <- get_outbreak_rating_types()
    n_ratings <- length(o_rate_classifications$labels)

    for (idx in 1:n_ratings) {

        min_tresh <- o_rate_classifications$thresholds[[idx]]
        max_tresh <- min(o_rate_classifications$thresholds[[idx + 1]], 100)
        label     <- o_rate_classifications$labels[[idx]]
        color     <- o_rate_classifications$colors[[idx]]

        shading_layer <- init_shading_layer()
        shading_layer[["fillcolor"]] <- color
        shading_layer[["line"]] <- list(color = color)
        shading_layer[["y0"]] <- min_tresh
        shading_layer[["y1"]] <- max_tresh

        shading_layers <-  append(shading_layers, list(shading_layer))

    }

    return(shading_layers)
}


#' Generates a layout function to write the layers of the background for the
#' outbreak rating plotly plot
#'
#' @description
#' A higher order function that generates a configured layout function for use
#' with plotly. This is very bespoke to the outbreak rating plot and should not
#' be used in other plots.
#'
#' @param xmin date as a string in "yyyy-mm-dd": where the plot starts on the x-axis
#' @param xmax date as a string in "yyyy-mm-dd": where the plot ends on the x-axis
#'
#' @returns function: configured layout function with colored backgrounds
#'
#' @seealso `get_outbreak_rating_types`, `generate_outbreak_rating_shading_layers`
#'
#' @examples
#' \dontrun{
#' time_series_plot_server(
#'   id = "plot_ts_outbreak",
#'   ts_data = daily_outbreak_rating_ts,
#'   labels = list(yaxis = "Outbreak Rating", box_title = "Outbreak Rating", xaxis = ""),
#'   deselected_traces = c("OUTBREAK_RATING", "OUTBREAK_RATING_MA_30DAY", "OUTBREAK_RATING_MA_90DAY", "OUTBREAK_RATING_MA_180DAY"),
#'   make_outbreak_rating_shading_layer_fn( # produces the layers for background color shading
#'     xmin = min(daily_outbreak_rating_ts()[["DATE_REPORTED"]]),
#'     xmax = max(daily_outbreak_rating_ts()[["DATE_REPORTED"]])
#'   )
#' )
#' }
#' @importFrom checkmate assert_date
#' @importFrom plotly layout
#'
make_outbreak_rating_shading_layer_fn <- function(xmin, xmax) {
    checkmate::assert_date(xmin)
    checkmate::assert_date(xmax)

    plt_with_shading_fn <- function(plt) {

        plt_with_shading <- plotly::layout(
            p      = plt,
            shapes = generate_outbreak_rating_shading_layers(xmin = xmin, xmax = xmax)
        )
        return(plt_with_shading)
    }

    return(plt_with_shading_fn)
}
