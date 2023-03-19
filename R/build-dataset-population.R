#
# Functions to build population dataset
#

#'
build_population_dataset <- function() {
    daily_cases <- get_daily_cases()
    vaccination <- get_vaccination()
    population <- generate_population_data(daily_cases = daily_cases, vacc = vaccination)
    population %>% safe_write_rds_file(output_path = get_population_path())

    return(invisible())
}

#' @importFrom dplyr mutate select left_join all_of filter distinct summarise pull count
generate_population_data <- function(daily_cases = get_daily_cases(), vacc = get_vaccination()) {
    # NOTE: this feature will not be generated in the near future. It will
    # instead be retrieved from a reliable data source (such as OECD).
    # In the meantime will we assume the population is static over time (which
    # is a very rough assumption).
    #
    # Steps for this are
    # 1. Estimate the current population from vaccination data (since it has per 100 people figures)
    # 2. Get historical dates from daily cases
    # 3. Assume the current population has not changed has been static for all dates
    # 4. For any countries that cannot have their population calculated, estimate from their total deaths

    # Estimate current population from vaccination data ------------------------
    population <- vacc %>%
        dplyr::mutate(POPULATION = 100 * (TOTAL_VACCINATIONS / TOTAL_VACCINATIONS_PER100)) %>%
        dplyr::select(dplyr::all_of(c("COUNTRY", "POPULATION")))

    # Get dates and country codes from daily cases
    population_hist <- daily_cases %>%
        dplyr::select(dplyr::all_of(c("DATE_REPORTED", "COUNTRY_CODE", "COUNTRY"))) %>%
        dplyr::left_join(population, by = c("COUNTRY"))

    # Impute missing population ------------------------------------------------
    # This a rough placeholder for better imputation. Population will be 
    # estimated from the mean cumulative death rate. 
    # AVG_DEATH_RATE = mean(LATEST_TOTAL_DEATHS/POPULATION) # all countries with population not NA
    # IMPUTED_POPULATION = LATEST_TOTAL_DEATHS / AVG_DEATH_RATE # all counties with population NA

    # Calculate average death rate from countries that have population numbers
    latest_rows_by_country <- get_latest_info_by_country(daily_cases = daily_cases, lag = 0)

    non_na_population_countries <- population_hist %>%
        dplyr::filter(!is.na(POPULATION)) %>%
        dplyr::select(dplyr::all_of(c("COUNTRY", "POPULATION"))) %>%
        dplyr::distinct()

    non_na_population <- dplyr::inner_join(non_na_population_countries, latest_rows_by_country, by = c("COUNTRY"))

    non_na_population <- non_na_population %>% 
        dplyr::mutate(DEATH_RATE = CUMULATIVE_DEATHS/POPULATION)

    avg_death_rate <- non_na_population %>% 
        dplyr::summarise(DEATH_RATE = mean(DEATH_RATE)) %>% 
        dplyr::pull(DEATH_RATE)

    # Estimate population with average death rate
    na_population_countries <- population_hist %>% 
        dplyr::filter(is.na(POPULATION)) %>% 
        dplyr::select(COUNTRY) %>% 
        dplyr::distinct()

    na_population <- dplyr::inner_join(na_population_countries, latest_rows_by_country, by = c("COUNTRY"))

    estimated_na_pop <- na_population %>% 
        dplyr::select(COUNTRY, CUMULATIVE_DEATHS) %>% 
        dplyr::mutate(ESTIMATED_POPULATION = CUMULATIVE_DEATHS/avg_death_rate) %>% 
        dplyr::select(COUNTRY, ESTIMATED_POPULATION)

    # Impute missing population
    population_hist_imp <- dplyr::left_join(population_hist, estimated_na_pop, by = c("COUNTRY")) %>% 
        dplyr::mutate(POPULATION = ifelse(is.na(POPULATION), ESTIMATED_POPULATION, POPULATION))

    # Check imputation ---------------------------------------------------------
    reamining_missing <- population_hist_imp %>% 
        dplyr::filter(is.na(POPULATION)) %>% 
        dplyr::count()

    if (reamining_missing > 0) {
        warning("Some population information cannot be imputed.")
    }

    # Drop unneeded cols -------------------------------------------------------
    output <- population_hist_imp %>%
        dplyr::select(dplyr::all_of(c("DATE_REPORTED", "COUNTRY_CODE", "COUNTRY", "POPULATION")))

    return(output)
}
