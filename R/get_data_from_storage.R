#
# Get data from storage
#
# TODO: add docs and tests
#

get_daily_cases <- function() {
    # Get data source configurations
    data_config <- get_data_source_config()
    return(readr::read_rds(file = data_config$datasets$daily_cases$output_path))
}


get_vaccination <- function() {
    # Get data source configurations
    data_config <- get_data_source_config()
    return(readr::read_rds(file = data_config$datasets$vaccination$output_path))
}


get_population <- function() {
    # Get data source configurations
    data_config <- get_data_source_config()
    return(readr::read_rds(file = paste0(data_config$output_dir, 'population.rds')))
}
