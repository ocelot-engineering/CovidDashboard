#
# Data manipulation for daily cases
#
# Common methods for manipulating daily cases data
#
# TODO: add tests


#' Takes daily cases and returns the latest rows for each country
#' 
#' @param daily_cases tibble: daily cases from WHO
#' @param lag int: number of days back the latest info should be lagged. I.e. 1 
#' day back will give the latest info as if running yesterday. Can be positive 
#' or negative, but will always go back.
#' 
#' @returns A tibble of the daily cases with the latest dates
#' @examples
#' \dontrun{
#' daily_cases <- get_daily_cases()
#' latest_rows_by_country <- get_latest_info_by_country(daily_cases, lag = 1)
#' }
#' 
get_latest_info_by_country <- function(daily_cases, lag = 0) {
    checkmate::assert_tibble(daily_cases)
    checkmate::assert_int(lag)
    
    # Get the maximum date. This is used for filtering out dates later than 
    #  the lag allows
    max_date <- daily_cases %>% 
        dplyr::summarise(MAX_DATE = max(DATE_REPORTED)) %>% 
        dplyr::pull(MAX_DATE)
    max_date <- max_date - abs(lag)
    
    # Get latest dates by country
    latest_dates_by_country <- daily_cases %>% 
        dplyr::filter(DATE_REPORTED <= max_date) %>% 
        dplyr::group_by(COUNTRY_CODE) %>% 
        dplyr::summarise(DATE_REPORTED = max(DATE_REPORTED))
    
    # Get latest date rows
    latest_rows_by_country <- dplyr::left_join(x = latest_dates_by_country, 
                                               y = daily_cases, 
                                               by = c("DATE_REPORTED", "COUNTRY_CODE"),
                                               keep = FALSE)
    
    return(latest_rows_by_country)
}
