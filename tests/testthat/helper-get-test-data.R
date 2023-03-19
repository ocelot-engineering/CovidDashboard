#
# Testing helper functions for data retrieval 
#

#' Returns testing data
#' 
#' @param name string: file name without the extension. e.g. "daily cases"
#' 
#' @returns A tibble of the daily cases with the latest dates
get_test_data <- function(name) {
    # Generate test file path
    run_inside_of_testthat <- basename(normalizePath(getwd())) == "testthat" # checking current directory
    if (run_inside_of_testthat) {
        test_data_dir <- normalizePath("./test_data") # relative to testthat dir
    } else {
        test_data_dir <- normalizePath("./tests/testthat/test_data") # relative to testthat dir
    }
    
    file_path <- paste0(test_data_dir, "/", name, ".rds")
    
    if(!file.exists(file_path)) {
        available_files <- paste0(list.files(test_data_dir), collapse = ", ")
        stop(file_path, " does not exist. Files available in this directory are: ", available_files)
    }
    
    dat <- readr::read_rds(file_path)
    
    return(dat)
}
