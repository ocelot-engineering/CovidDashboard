#
# Download daily cases data and exploration
#

# Setup -------------------------------------------------------------------

library(dplyr)


# Download data -----------------------------------------------------------

url <- 'https://covid19.who.int/WHO-COVID-19-global-data.csv'

# Data dictionary: https://covid19.who.int/data. 
# See "Daily cases and deaths by date reported to WHO".
col_types = readr::cols(
    Date_reported     = readr::col_date(format = '%Y-%m-%d')
  , Country_code      = readr::col_character()
  , Country           = readr::col_character()
  , WHO_region        = readr::col_character()
  , New_cases         = readr::col_integer()
  , Cumulative_cases  = readr::col_integer()
  , New_deaths        = readr::col_integer()
  , Cumulative_deaths = readr::col_integer()
)

# Download and make into tibble
dat <- readr::read_csv(url, col_types = col_types)

colnames(dat) <- toupper(colnames(dat)) # make col names upper

# Explore data ------------------------------------------------------------

COUNTRY_CODE_SEL <- 'AU'

cases <- dat %>% 
    filter(COUNTRY_CODE == COUNTRY_CODE_SEL) %>% 
    select(COUNTRY_CODE, DATE_REPORTED, NEW_CASES)

deaths <- dat %>% 
    filter(COUNTRY_CODE == COUNTRY_CODE_SEL) %>% 
    select(COUNTRY_CODE, DATE_REPORTED, NEW_DEATHS)

cases_deaths <- left_join(cases, deaths, by = c("COUNTRY_CODE", "DATE_REPORTED"))

cases_deaths <- cases_deaths %>% 
    group_by(COUNTRY_CODE) %>% 
    mutate(CUM_CASES = cumsum(NEW_CASES), CUM_DEATHS = cumsum(NEW_DEATHS))


# See date for max new cases and deaths
# cases_deaths_summary <- rbind(
#     cases_deaths %>% filter(NEW_DEATHS == max(NEW_DEATHS))
#   , cases_deaths %>% filter(NEW_CASES == max(NEW_CASES))
# )

cases_deaths_summary <- rbind(
    cases_deaths %>% slice_max(NEW_DEATHS)
  , cases_deaths %>% slice_max(NEW_CASES)
)

cases_deaths_summary
