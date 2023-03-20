#
# Data manipulation for daily cases
#
# Common methods for manipulating daily cases data
#

#' Takes daily cases and returns the latest rows for each country
#'
#' @inherit common_docs params
#' @param lag int: number of days back the latest info should be lagged. I.e. 1
#' day back will give the latest info as if running yesterday. Can be positive
#' or negative, but will always go back.
#'
#' @returns tibble: the daily cases with the latest dates
#' @examples
#' \dontrun{
#' daily_cases <- get_daily_cases()
#' latest_rows_by_country <- get_latest_info_by_country(daily_cases, lag = 1)
#' }
#' @importFrom checkmate assert_tibble assert_int
#' @importFrom dplyr summarise pull filter group_by left_join
#'
get_latest_info_by_country <- function(daily_cases, lag = 0) {
    checkmate::assert_tibble(daily_cases)
    checkmate::assert_int(lag)

    # Get the maximum date. This is used for filtering out dates later than
    #  the lag allows
    max_date <- daily_cases %>% 
        dplyr::summarise(MAX_DATE = max(.data$DATE_REPORTED)) %>%
        dplyr::pull(dplyr::all_of("MAX_DATE"))
    max_date <- max_date - abs(lag)

    # Get latest dates by country
    latest_dates_by_country <- daily_cases %>%
        dplyr::filter(.data$DATE_REPORTED <= .env$max_date) %>%
        dplyr::group_by(.data$COUNTRY_CODE) %>%
        dplyr::summarise(DATE_REPORTED = max(.data$DATE_REPORTED))

    # Get latest date rows
    latest_rows_by_country <- dplyr::left_join(
        x = latest_dates_by_country,
        y = daily_cases,
        by = c("DATE_REPORTED", "COUNTRY_CODE"),
        keep = FALSE
    )

    return(latest_rows_by_country)
}


#' Takes daily cases and returns the daily aggregation
#'
#' @param daily_cases tibble: daily cases from WHO
#' @param agg function: aggregation function. e.g. sum or mean.
#' @param cols_sel: character vector: aggregation columns
#' @param days_back int: number of days back the series should extent to
#'
#' @returns A tibble of the daily cases aggregated
#'
#' @examples
#' \dontrun{
#' daily_cases <- get_daily_cases()
#' get_daily_agg(daily_cases, agg = sum, cols_sel = c("NEW_CASES"), days_back = 30)
#' get_daily_agg(daily_cases, agg = mean)
#' }
#' @importFrom checkmate assert_tibble assert_character assert_int
#' @importFrom dplyr summarise filter group_by summarise across
#'
get_daily_agg <- function(daily_cases, agg = sum, cols_sel = c("NEW_CASES", "NEW_DEATHS"), days_back = 365 * 2) {
    checkmate::assert_tibble(daily_cases)
    checkmate::assert_character(cols_sel)
    checkmate::assert_int(days_back)

    # Get max date to filter all dates that occur before days_back
    max_date <- daily_cases %>%
        dplyr::summarise(MAX_DATE = max(.data$DATE_REPORTED)) %>%
        dplyr::pull(dplyr::all_of("MAX_DATE"))

    dat <- daily_cases %>%
        dplyr::filter(.data$DATE_REPORTED > .env$max_date - .env$days_back) %>% # only take past 2 years by default
        dplyr::group_by(.data$DATE_REPORTED) %>%
        dplyr::summarise(dplyr::across(cols_sel, agg)) # aggregate all cols selected

    return(dat)
}

#' Takes daily cases time series and performaing moving average smoothing
#'
#' @param daily_cases_ts tibble: daily cases time series (1 date per row)
#' @param cols_used: character vector: columns to be smoothed
#' @param orders int vector: order of smoothing (each element will produce a new column)
#'
#' @returns tibble: the daily cases time series smoothed with original columns
#'
#' @examples
#' \dontrun{
#' daily_cases <- get_daily_cases()
#' daily_cases_ts <- get_daily_agg(daily_cases, cols_sel = c("NEW_CASES", "NEW_DEATHS"))
#' daily_cases_ts_smoothed <- add_ma_smoothing(daily_cases_ts)
#'
#' daily_cases <- get_daily_cases()
#' daily_cases_ts <- get_daily_agg(daily_cases, cols_sel = c("NEW_CASES"))
#' daily_cases_ts_smoothed <- add_ma_smoothing(daily_cases_ts, cols_used = c("NEW_CASES"), orders = c(10, 20, 100))
#' plot(daily_cases_ts_smoothed$NEW_CASES, type = 'l')
#' lines(daily_cases_ts_smoothed$NEW_CASES_MA_10DAY, col = "red")
#' lines(daily_cases_ts_smoothed$NEW_CASES_MA_20DAY, col = "green")
#' lines(daily_cases_ts_smoothed$NEW_CASES_MA_100DAY, col = "purple")
#' }
#'
#' @importFrom checkmate assert_tibble assert_character assert_integerish
#' @importFrom forecast ma
#' @importFrom dplyr mutate across all_of
#'
add_ma_smoothing <- function(daily_cases_ts, cols_used = c("NEW_CASES", "NEW_DEATHS"), orders = c(3, 7, 30, 60)) {
    checkmate::assert_tibble(daily_cases_ts)
    checkmate::assert_character(cols_used)
    checkmate::assert_integerish(orders)

    # Function factory to create moving avg functions with different orders
    generate_ma_fn <- function(order) {
        ma_fn <- function(x) {
            return(forecast::ma(x, order))
        }
        return(ma_fn)
    }

    # List of moving average functions to run
    moving_avg_fns <- lapply(orders, generate_ma_fn)
    names(moving_avg_fns) <- paste0("MA_", orders, "DAY") # for col names in output

    # Add moving average cols
    output <- daily_cases_ts %>%
        dplyr::mutate(dplyr::across(.cols = dplyr::all_of(cols_used), moving_avg_fns))

    return(output)
}


#' Smooth columns in daily cases data
#'
#' @param daily_agg tibble: daily cases time series (1 date per row)
#' @param cols_used: character vector: columns to be smoothed
#' @param custom_ma_orders int vector: order of smoothing (each element will produce a new column)
#'
#' @returns tibble: the daily cases time series smoothed with original columns
#'
#' @importFrom dplyr select all_of
#' @importFrom rlang .data .env
smooth_daily_agg <- function(daily_agg, cols_used, custom_ma_orders = c()) {
    # Moving average orders
    def_ma_orders <- c(7, 30, 90)
    ma_orders <- unique(c(def_ma_orders, custom_ma_orders))

    daily_agg_smoothed <- daily_agg %>% 
        dplyr::select(DATE_REPORTED, dplyr::all_of(cols_used)) %>% 
        add_ma_smoothing(cols_used = c(cols_used), orders = ma_orders)

    return(daily_agg_smoothed)
}
