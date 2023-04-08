#
# Functions to build daily cases dataset
#

#' Download and write the daily cases dataset
#' @importFrom dplyr summarise pull filter
#' @importFrom lubridate floor_date
#' @importFrom rlang .data .env
build_daily_cases_dataset <- function() {

    config <-  get_config()$datasets$daily_cases
    dat_raw <- config$url %>% read_csv_file(col_types = get_schema_daily_cases())
    max_date <- dat_raw %>%
        dplyr::summarise(MAX_DATE = max(.data$DATE_REPORTED)) %>%
        dplyr::pull("MAX_DATE") %>%
        lubridate::floor_date(unit = "weeks", week_start = config$week_start)

    dat_filt <- dat %>% dplyr::filter(.data$DATE_REPORTED <= .env$max_date)

    dat_filt %>% safe_write_rds_file(output_path = get_daily_cases_path())

    return(invisible())
}

#' Get schema for daily cases dataset
#' @importFrom readr cols col_date col_character col_integer
get_schema_daily_cases <- function() {
    schema <- readr::cols(
        Date_reported     = readr::col_date(format = "%Y-%m-%d"),
        Country_code      = readr::col_character(),
        Country           = readr::col_character(),
        WHO_region        = readr::col_character(),
        New_cases         = readr::col_integer(),
        Cumulative_cases  = readr::col_integer(),
        New_deaths        = readr::col_integer(),
        Cumulative_deaths = readr::col_integer()
    )
    return(schema)
}