#
# Configuration
#

#' Returns config for project
#' @importFrom yaml read_yaml
get_config <- function() {
    yaml::read_yaml(file = system.file("config/config.yaml", package = get_pkg_name()))
}