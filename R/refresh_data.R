#
# Refreshing the underlying data from WHO
#
# TODO: write tests


#' Source and return the data source config object
#' 
#' @returns A list with data source configurations
#' @examples
#' get_data_source_config()
#' 
get_data_source_config <- function() {
    source('config/data_source_config.R', local = TRUE)
    return(data_config)
}


#' Refresh all underlying data.
#' 
#' @returns NULL.
#' 
refresh_all_data <- function() {
    # Get data source configurations
    data_config <- get_data_source_config()
    
    # Check if dir exists
    if(!dir.exists(data_config$output_dir)) {
        warning('Output directory was not initalised so was created during refresh data call.')
        dir.create(data_config$output_dir, mode = "0777")
    }
    
    # Refresh from configs
    purrr::map(.x = data_config$datasets, .f = refresh_dataset_from_config)
    
    return(invisible())
}


#' Refreshes a single dataset from a data source config.
#' 
#' @param data_config A data source config, which is a list containing url and col_types.
#' 
#' @returns invisible NULL
#' 
refresh_dataset_from_config <- function(data_config) {
    checkmate::assert_list(data_config)
    checkmate::assert_string(data_config$url)
    checkmate::assert_class(data_config$col_types, "col_spec")
    checkmate::assert_path_for_output(data_config$output_path, overwrite = TRUE, extension = 'rds')
    
    # Read data from url and clean up col names
    dat <- readr::read_csv(file = data_config$url, col_types = data_config$col_types)
    colnames(dat) <- toupper(colnames(dat))
    
    # Refresh dataset
    refresh_dataset(
        dat         = dat
      , output_path = data_config$output_path
    )
    
    return(invisible())
}


#' Refreshes a single dataset.
#' 
#' @param dat tibble: df to be written
#' @param output_path string: Path to write file to.
#' 
#' @returns invisible NULL
#' @examples
#' 
refresh_dataset <- function(dat, output_path) {
    checkmate::assert_tibble(dat)
    checkmate::assert_path_for_output(output_path, overwrite = TRUE, extension = 'rds')
    
    message('Preparing ', basename(output_path))
    
    # Check for previous files and backup
    bu_file_path <- generate_backup_path(output_path)
    if (file.exists(output_path)) {
        file.rename(from = output_path, to = bu_file_path)
    }
    
    # TODO: validating data
    # if (new_data_is_invalid) { rollback to backup}
    
    # Write data as RDS to retain tibble information
    readr::write_rds(x = dat, file = output_path, compress = "none")
    
    # Clear out old data
    if (file.exists(bu_file_path)) {
        message('Deleting ', bu_file_path)
        file.remove(bu_file_path)
    }
    
    return(invisible())
}


#' Updates a path to have timestamp prefix in front of the file name.
#' 
#' @param path string: a string representing a file path
#' 
#' @returns a string of a file path
#' 
generate_backup_path = function(path) {
    checkmate::assert_string(path)
    
    timestamp <- paste0(stringr::str_extract_all(Sys.time(), '\\d', simplify = TRUE), collapse ="")
    backup_path <- paste0(dirname(path), '/bu_', timestamp, '_', basename(path))
    
    return(backup_path)
}
