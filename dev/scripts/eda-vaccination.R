#
# Download data and explore
#
# 

# Setup -------------------------------------------------------------------

library(dplyr)


# Download data -----------------------------------------------------------

url <- 'https://covid19.who.int/who-data/vaccination-data.csv'

# Data dictionary: https://covid19.who.int/data. 
# See "Daily cases and deaths by date reported to WHO".
col_types = readr::cols(
    COUNTRY                              = readr::col_character()
  , ISO3                                 = readr::col_character()
  , WHO_REGION                           = readr::col_character()
  , DATA_SOURCE                          = readr::col_character()
  , DATE_UPDATED                         = readr::col_date(format = '%Y-%m-%d')
  , TOTAL_VACCINATIONS                   = readr::col_double() # some rows larger than .Machine$integer.max (2147483647). Use double instead
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

# Check max int value
.Machine$integer.max # max int is 2147483647

# Download data and make into tibble
vacc <- readr::read_csv(url, col_types = col_types)
colnames(vacc) <- toupper(colnames(vacc)) # make col names upper


# Explore data ------------------------------------------------------------

vacc %>% count() # 229

# Vaccines used look to be comma separated within the field
vacc %>% 
    select(VACCINES_USED) %>% 
    slice(1:5)


# Add population field (derived from total vaccinations per 100)
vacc <- vacc %>% mutate(POPULATION = 100 * (TOTAL_VACCINATIONS / TOTAL_VACCINATIONS_PER100))
vacc %>% select(COUNTRY, POPULATION)  
    
# Highest vaccination rate for countries with population over 1m
vacc %>% 
    filter(POPULATION > 1000000) %>%
    slice_max(PERSONS_FULLY_VACCINATED_PER100, n = 10) %>% 
    select(  COUNTRY
           , DATA_SOURCE
           , TOTAL_VACCINATIONS
           , PERSONS_FULLY_VACCINATED
           , PERSONS_FULLY_VACCINATED_PER100
           , POPULATION) %>% 
    arrange(-PERSONS_FULLY_VACCINATED_PER100)

# check different data source counts
vacc %>% group_by(DATA_SOURCE) %>% count()

# Create a fully vaccinated ranking column
# check that 1 row per country
vacc %>% count() #229
vacc %>% distinct(COUNTRY) %>% count() # 229

vacc <- vacc %>% 
    mutate(FULLY_VACCINATED_RANK = dense_rank(-PERSONS_FULLY_VACCINATED_PER100))

# See where Australia fares
vacc %>% filter(COUNTRY == "Australia") %>% 
    select(COUNTRY
         , DATA_SOURCE
         , TOTAL_VACCINATIONS
         , PERSONS_FULLY_VACCINATED
         , PERSONS_FULLY_VACCINATED_PER100
         , FULLY_VACCINATED_RANK
         , POPULATION) %>% 
    arrange(-PERSONS_FULLY_VACCINATED_PER100)


# Look at the top 20 fully vaccinated populations over 1m population
vacc %>% 
    filter(POPULATION > 1000000) %>%
    slice_max(PERSONS_FULLY_VACCINATED_PER100, n = 20) %>% 
    select(COUNTRY
           , DATA_SOURCE
           , TOTAL_VACCINATIONS
           , PERSONS_FULLY_VACCINATED
           , PERSONS_FULLY_VACCINATED_PER100
           , FULLY_VACCINATED_RANK
           , POPULATION) %>% 
    arrange(-PERSONS_FULLY_VACCINATED_PER100)
