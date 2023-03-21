#
# File creation, reading, updating and deleting
#

# Creation ----------------------------------------------------------------

#' Write a dataset.
#'
#' Ensure that if function fails original dataset if not lost
#'
#' @param dat tibble: df to be written
#' @param output_path string: Path to write file to
#'
#' @returns invisible NULL
#'
#' @importFrom checkmate assert_tibble assert_path_for_output
#' @importFrom readr write_rds
#'
safe_write_rds_file <- function(dat, output_path) {
    checkmate::assert_tibble(dat)
    checkmate::assert_path_for_output(output_path, overwrite = TRUE, extension = "rds")

    message("Preparing ", basename(output_path))

    # Check for previous files and backup
    bu_file_path <- generate_backup_path(output_path)
    rename_file(from = output_path, to = bu_file_path)

    # Try to write file
    tryCatch({
        readr::write_rds(x = dat, file = output_path, compress = "none")
        delete_file(file_path = bu_file_path)
    }, error = function(err) {
        warning("Failed due to: ", err[["message"]], "Rolling back changes.")
        rename_file(from = bu_file_path, to = output_path)
    })

    return(invisible())
}


# Reading -----------------------------------------------------------------

#' Read data from url and clean up column names
#' @importFrom readr read_csv
#' @inherit readr::read_csv params
read_csv_file <- function(file, col_types) {
    dat <- readr::read_csv(file = file, col_types = col_types)
    colnames(dat) <- toupper(colnames(dat))

    return(dat)
}

# Update ------------------------------------------------------------------

#' Rename a file if it exists
#' @inherit base::file.rename params
rename_file <- function(from, to) {
    if (file.exists(from)) {
        file.rename(from = from, to = to)
    } else {
        message("Does not exist: ", from)
    }
    return(invisible())
}

#' Updates a path to have timestamp prefix in front of the file name.
#'
#' @param path string: a string representing a file path
#'
#' @returns a string of a file path
#'
#' @importFrom checkmate assert_string
#' @importFrom stringr str_extract_all
#'
generate_backup_path <- function(path) {
    checkmate::assert_string(path)

    timestamp <- paste0(stringr::str_extract_all(Sys.time(), "\\d", simplify = TRUE), collapse = "")
    backup_path <- paste0(dirname(path), "/bu_", timestamp, "_", basename(path))

    return(backup_path)
}


# Deletion ----------------------------------------------------------------

#' Deletes a file if it exists
#' @inherit base::file.remove params
delete_file <- function(file_path) {
    if (file.exists(file_path)) {
        message("Deleting: ", file_path)
        file.remove(file_path)
    } else {
        message("Does not exist: ", file_path)
    }
    return(invisible())
}