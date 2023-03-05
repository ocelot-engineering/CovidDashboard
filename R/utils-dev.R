#
# Internal functions used for package development
#

#' Rebuilds package documentation
#' @importFrom devtools document build_readme
#' @keywords internal
rebuild_docs <- function() {
    devtools::document()
    devtools::build_readme()
    return(invisible())
}