#
# Color palette
#

#' @importFrom yaml read_yaml
get_color_pal <- function() {
    yaml::read_yaml(paste0("inst/config/color-palette.yaml"))
}