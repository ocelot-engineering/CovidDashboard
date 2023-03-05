#
# Generating test data from actual dataset
#

data_config <- get_data_source_config()

# Daily cases -------------------------------------------------------------

# Configure
min_date <- as.Date("2020-08-24")
max_date <- as.Date("2020-08-27")
countries <- c("AU", "BZ", "CN")

# Download and make into tibble
daily_cases <- readr::read_csv(
    file      = data_config$datasets$daily_cases$url, 
    col_types = data_config$datasets$daily_cases$col_types
    )
colnames(daily_cases) <- toupper(colnames(daily_cases)) # make col names upper

daily_cases_test <- daily_cases %>% 
    dplyr::filter(COUNTRY_CODE %in% countries) %>% 
    dplyr::filter(DATE_REPORTED %in% seq.Date(from = min_date, to = max_date, by = "day")) %>% 
    dplyr::filter(!(DATE_REPORTED == max_date & COUNTRY_CODE == "BZ")) # remove latest Belize row

readr::write_rds(x = daily_cases_test, file = "tests/testthat/test_data/daily_cases.rds")



# Vaccines ----------------------------------------------------------------

vacc <- readr::read_csv(
    file = data_config$datasets$vaccination$url, 
    col_types = data_config$datasets$vaccination$col_types
    )
colnames(vacc) <- toupper(colnames(vacc)) # make col names upper

vacc_test <- vacc # TODO: update when vacc tests are built

readr::write_rds(x = vacc_test, file = "tests/testthat/test_data/vaccination.rds")


# Population --------------------------------------------------------------

daily_cases_test <- readr::read_rds("tests/testthat/test_data/daily_cases.rds")
vacc_test        <- readr::read_rds("tests/testthat/test_data/vaccination.rds")

population_test <- generate_population_feature(daily_cases = daily_cases_test, vacc = vacc_test)

readr::write_rds(x = population_test, file = "tests/testthat/test_data/population.rds")
