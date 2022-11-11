#
# Enhanced base utilities
#


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
