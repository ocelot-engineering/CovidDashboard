#
# Headline numbers
# 
# Functions to generate the headline numbers for the app, such as latest reported
# case and death numbers and how they compare to the previous day
# 
# TODO: Add tests for functions
# TODO: Vaccine numbers


#' Calculates the latest new case numbers
#' 
#' Note that this is the latest new case numbers for each country. Lets say you
#' have Australia, Brazil and Chile. If Australia and Brazil are up-to-date and 
#' have info for the Friday, but Chile's latest info is for the previous 
#' Wednesday, the new case numbers will include Australia and Brazil's Friday 
#' numbers as well as Brazil's Wednesday numbers.
#' 
#' This could cause new cases to "persist" until later information comes in, but 
#' it prevents a sudden drop in case numbers due to lack of reporting. Hence the 
#' reason to include the latest numbers instead of excluding that country.
#' 
#' @param daily_cases tibble: daily cases from WHO
#' 
#' @returns list: new_cases = latest number of new cases, total_cases: total confirmed
#' cases, perc_inc = daily % increase
#' 
#' @examples
#' \dontrun{
#' daily_cases <- get_daily_cases()
#' output <- calc_cases(daily_cases)
#' }
#' 
calc_cases <- function(daily_cases) {
    checkmate::assert_tibble(daily_cases)
    
    output <- calc_new_and_total(  daily_cases = daily_cases
                                 , new_col = "NEW_CASES"
                                 , total_col = "CUMULATIVE_CASES")
    
    return(output)
}


#' Calculates the latest new death numbers
#' 
#' Note that this is the latest new death numbers for each country. Lets say you
#' have Australia, Brazil and Chile. If Australia and Brazil are up-to-date and 
#' have info for the Friday, but Chile's latest info is for the previous 
#' Wednesday, the new case numbers will include Australia and Brazil's Friday 
#' numbers as well as Brazil's Wednesday numbers.
#' 
#' This could cause new cases to "persist" until later information comes in, but 
#' it prevents a sudden drop in case numbers due to lack of reporting. Hence the 
#' reason to include the latest numbers instead of excluding that country.
#' 
#' @param daily_cases tibble: daily cases from WHO
#' 
#' @returns list: new = latest number of new deaths, total: total confirmed
#' deaths, perc_inc = daily % increase
#' 
#' @examples
#' \dontrun{
#' daily_cases <- get_daily_cases()
#' output <- calc_deaths(daily_cases)
#' }
#' 
calc_deaths <- function(daily_cases) {
    checkmate::assert_tibble(daily_cases)
    
    output <- calc_new_and_total(  daily_cases = daily_cases
                                 , new_col = "NEW_DEATHS"
                                 , total_col = "CUMULATIVE_DEATHS")
    
    return(output)
}


#' Calculates the latest new case or death numbers
#' 
#' Note that this is the latest new case numbers for each country. Lets say you
#' have Australia, Brazil and Chile. If Australia and Brazil are up-to-date and 
#' have info for the Friday, but Chile's latest info is for the previous 
#' Wednesday, the new case numbers will include Australia and Brazil's Friday 
#' numbers as well as Brazil's Wednesday numbers.
#' 
#' This could cause new cases to "persist" until later information comes in, but 
#' it prevents a sudden drop in case numbers due to lack of reporting. Hence the 
#' reason to include the latest numbers instead of excluding that country.
#' 
#' @param daily_cases tibble: daily cases from WHO
#' 
#' @returns list: new = latest number of new cases, total: total confirmed
#' cases, perc_inc = daily % increase
#' 
#' @examples
#' \dontrun{
#' daily_cases <- get_daily_cases()
#' deaths <- calc_new_and_total(  daily_cases = daily_cases
#'                              , new_col = "NEW_DEATHS"
#'                              , total_col = "CUMULATIVE_DEATHS")
#' }
#' 
calc_new_and_total <- function(daily_cases, new_col, total_col) {
    checkmate::assert_tibble(daily_cases)
    checkmate::assert_string(new_col)
    checkmate::assert_string(total_col)
    
    # Get latest numbers for new cases and total cases
    latest_rows_by_country <- get_latest_info_by_country(daily_cases, lag = 0)
    latest_new_and_total_cases <- latest_rows_by_country %>% 
        dplyr::summarise(  NEW_CASES        = sum(get(new_col))
                         , CUMULATIVE_CASES = sum(get(total_col))
                         , LATEST_DATE      = max(DATE_REPORTED))
    
    # Get yesterday's numbers for new cases and total cases
    yesterday_rows_by_country <- get_latest_info_by_country(daily_cases, lag = 1)
    yesterday_new_and_total_cases <- yesterday_rows_by_country %>% 
        dplyr::summarise(  NEW_CASES        = sum(get(new_col))
                         , CUMULATIVE_CASES = sum(get(total_col))
                         , LATEST_DATE      = max(DATE_REPORTED))
    
    # Get the percentage change from yesterdays new case numbers
    latest_new_cases <- latest_new_and_total_cases %>% pull(NEW_CASES)
    yester_new_cases <- yesterday_new_and_total_cases %>% pull(NEW_CASES)
    perc_inc <- (latest_new_cases - yester_new_cases) / yester_new_cases 
    
    # Prepare output list
    output <- list(
        new_cases   = latest_new_cases
      , total_cases = latest_new_and_total_cases %>% pull(CUMULATIVE_CASES)
      , perc_inc    = perc_inc
    )
    
    return(output)
}


calc_vax <- function() {
    # TODO: latest vax numbers
}
