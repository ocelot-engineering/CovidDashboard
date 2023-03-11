#
# Functions to build vaccination dataset
#

build_vaccination_dataset <- function() {
    url <- get_config()$datasets$vaccination$url
    url %>%
        read_csv_file(col_types = get_schema_vaccination()) %>%
        safe_write_rds_file(output_path = get_vaccination_path())

    return(invisible())
}

#' @importFrom readr cols col_date col_character col_integer col_double
get_schema_vaccination <- function() {
    schema <- readr::cols(
        COUNTRY                              = readr::col_character(),
        ISO3                                 = readr::col_character(),
        WHO_REGION                           = readr::col_character(),
        DATA_SOURCE                          = readr::col_character(),
        DATE_UPDATED                         = readr::col_date(format = "%Y-%m-%d"),
        TOTAL_VACCINATIONS                   = readr::col_double(),  # some rows larger than .Machine$integer.max (2147483647). Use double instead
        PERSONS_VACCINATED_1PLUS_DOSE        = readr::col_integer(), # source stated double but data shows otherwise
        TOTAL_VACCINATIONS_PER100            = readr::col_double(),  # source stated integer but data shows otherwise
        PERSONS_VACCINATED_1PLUS_DOSE_PER100 = readr::col_double(),
        PERSONS_FULLY_VACCINATED             = readr::col_integer(),
        PERSONS_FULLY_VACCINATED_PER100      = readr::col_double(),
        VACCINES_USED                        = readr::col_character(),
        FIRST_VACCINE_DATE                   = readr::col_date(format = "%Y-%m-%d"),
        NUMBER_VACCINES_TYPES_USED           = readr::col_integer(),
        PERSONS_BOOSTER_ADD_DOSE             = readr::col_integer(),
        PERSONS_BOOSTER_ADD_DOSE_PER100      = readr::col_double()
    )
    return(schema)
}