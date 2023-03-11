#
# Configuration
#

#' Returns config for project
#' @importFrom yaml read_yaml
get_config <- function() {
    yaml::read_yaml(paste0("inst/config/config.yaml"))
}
