#
# Enhanced base utilities
#


#' Sources all files in a directory
#' 
#' @param dir string: path of a directory
#' @param local boolean or environment: same as `source`. TRUE, FALSE or an 
#' environment, determining where the parsed expressions are evaluated. FALSE 
#' (the default) corresponds to the user's workspace (the global environment) 
#' and TRUE to the environment from which source is called.
#' 
#' @returns NULL (invisible)
#' @examples
#' \dontrun{
#' source_dir(dir = "./R", local = TRUE)
#' }
#' @seealso `source`
#' 
source_dir <- function(dir, local = FALSE) {
    
    # Env to source into
    envir <- if (isTRUE(local)) 
        parent.frame()
    else if (isFALSE(local)) 
        .GlobalEnv
    else if (is.environment(local)) 
        local
    else stop("'local' must be TRUE, FALSE or an environment")
    
    purrr::map(  .x    = list.files(dir, full.names = TRUE, recursive = TRUE)
               , .f    = source
               , local = envir
    )
    
    return(invisible())
}


#' Makes a formula object from a string
#' 
#' @param x string: any string, usually a column name.
#' @param prefix string: prefix of the formula
#' @param suffix string: suffix of the formula
#' 
#' @returns a formula. e.g. ~DATE
#' @examples
#' \dontrun{
#' make_formula("DATE", "~")
#' }
#' 
make_formula <- function(x, prefix = "", suffix = "") {
    checkmate::assert_string(x)
    checkmate::assert_string(prefix)
    checkmate::assert_string(suffix)
    
    return(as.formula(paste0(prefix, x, suffix)))
}
