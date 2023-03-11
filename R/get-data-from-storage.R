#
# Get data from storage
#

# Daily cases -------------------------------------------------------------

#'
get_daily_cases_path <- function() {
    dir <- get_config()$datasets$data_path
    cfg <- get_config()$datasets$daily_cases
    return(paste0(dir, cfg$name, ".", cfg$ext))
}

#' @importFrom readr read_rds
get_daily_cases <- function() {
    return(readr::read_rds(file = get_daily_cases_path()))
}


# Vaccination -------------------------------------------------------------

#'
get_vaccination_path <- function() {
    dir <- get_config()$datasets$data_path
    cfg <- get_config()$datasets$vaccination
    return(paste0(dir, cfg$name, ".", cfg$ext))
}

#' @importFrom readr read_rds
get_vaccination <- function() {
    return(readr::read_rds(file = get_vaccination_path()))
}


# Populaton ---------------------------------------------------------------

#'
get_population_path <- function() {
    dir <- get_config()$datasets$data_path
    cfg <- get_config()$datasets$population
    return(paste0(dir, cfg$name, ".", cfg$ext))
}

#' @importFrom readr read_rds
get_population <- function() {
    return(readr::read_rds(file = get_population_path()))
}