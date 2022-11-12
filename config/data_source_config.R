#
# Data source configuration
# 
# This script contains the location and schemas of the data sources
#

source("config/proj_config.R", local = TRUE)

# Base URL ----------------------------------------------------------------

base_url <- 'https://covid19.who.int/'
output_dir <- proj_config$data_path


# Datasets and schemas ----------------------------------------------------

daily_cases = list(
    url = paste0(base_url, 'WHO-COVID-19-global-data.csv')
  , output_path = paste0(output_dir, 'daily_cases.rds')
  , col_types = readr::cols(
      Date_reported     = readr::col_date(format = '%Y-%m-%d')
    , Country_code      = readr::col_character()
    , Country           = readr::col_character()
    , WHO_region        = readr::col_character()
    , New_cases         = readr::col_integer()
    , Cumulative_cases  = readr::col_integer()
    , New_deaths        = readr::col_integer()
    , Cumulative_deaths = readr::col_integer()
    )
)

vaccination = list(
    url = paste0(base_url, 'who-data/vaccination-data.csv')
  , output_path = paste0(output_dir, 'vaccination.rds')
  , col_types = readr::cols(
      COUNTRY                              = readr::col_character()
    , ISO3                                 = readr::col_character()
    , WHO_REGION                           = readr::col_character()
    , DATA_SOURCE                          = readr::col_character()
    , DATE_UPDATED                         = readr::col_date(format = '%Y-%m-%d')
    , TOTAL_VACCINATIONS                   = readr::col_double()  # some rows larger than .Machine$integer.max (2147483647). Use double instead
    , PERSONS_VACCINATED_1PLUS_DOSE        = readr::col_integer() # source stated double but data shows otherwise
    , TOTAL_VACCINATIONS_PER100            = readr::col_double()  # source stated integer but data shows otherwise
    , PERSONS_VACCINATED_1PLUS_DOSE_PER100 = readr::col_double()
    , PERSONS_FULLY_VACCINATED             = readr::col_integer()
    , PERSONS_FULLY_VACCINATED_PER100      = readr::col_double()
    , VACCINES_USED                        = readr::col_character()
    , FIRST_VACCINE_DATE                   = readr::col_date(format = '%Y-%m-%d')
    , NUMBER_VACCINES_TYPES_USED           = readr::col_integer()
    , PERSONS_BOOSTER_ADD_DOSE             = readr::col_integer()
    , PERSONS_BOOSTER_ADD_DOSE_PER100      = readr::col_double() 
    )
)

# Data config output ------------------------------------------------------

data_config <- list(
    base_url = base_url
  , output_dir = output_dir
  , datasets = list(
      daily_cases = daily_cases
    , vaccination = vaccination
  ) 
)
