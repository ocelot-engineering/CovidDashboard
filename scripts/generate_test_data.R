#
# Generating test data from actual dataset
#

# Generate data config to get url and col types
data_config <- get_data_source_config()
url <- data_config$datasets$daily_cases$url
col_types <- data_config$datasets$daily_cases$col_types

# Download and make into tibble
daily_cases <- readr::read_csv(url, col_types = col_types)
colnames(daily_cases) <- toupper(colnames(daily_cases)) # make col names upper

min_date <- as.Date("2020-08-24")
max_date <- as.Date("2020-08-27")

daily_cases_test <- daily_cases %>% 
    dplyr::filter(COUNTRY_CODE %in% c("AU", "BZ", "CN")) %>% 
    dplyr::filter(DATE_REPORTED %in% seq.Date(from = min_date, to = max_date, by = "day")) %>% 
    dplyr::filter(!(DATE_REPORTED == max_date & COUNTRY_CODE == "BZ")) # remove latest Belize row

readr::write_rds(x = daily_cases_test, file = "tests/testthat/test_data/daily_cases.rds")
