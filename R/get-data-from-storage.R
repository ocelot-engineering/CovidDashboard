#
# Get data from storage
#

# Daily cases -------------------------------------------------------------

#' Get storage location for daily cases dataset
get_daily_cases_path <- function() {
    dir <- get_config()$datasets$data_path
    cfg <- get_config()$datasets$daily_cases
    return(paste0(dir, cfg$name, ".", cfg$ext))
}

#' Get daily cases data
#' @importFrom readr read_rds
get_daily_cases <- function() {
    return(readr::read_rds(file = get_daily_cases_path()))
}


# Vaccination -------------------------------------------------------------

#' Get storage location for vaccination dataset
get_vaccination_path <- function() {
    dir <- get_config()$datasets$data_path
    cfg <- get_config()$datasets$vaccination
    return(paste0(dir, cfg$name, ".", cfg$ext))
}

#' Get vaccination data
#' @importFrom readr read_rds
get_vaccination <- function() {
    return(readr::read_rds(file = get_vaccination_path()))
}


# Populaton ---------------------------------------------------------------

#' Get storage location for population dataset
get_population_path <- function() {
    dir <- get_config()$datasets$data_path
    cfg <- get_config()$datasets$population
    return(paste0(dir, cfg$name, ".", cfg$ext))
}

#' Get population data
#' @importFrom readr read_rds
get_population <- function() {
    return(readr::read_rds(file = get_population_path()))
}