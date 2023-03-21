#
# Color palette
#

#' Return colour palette for app theme
#' @importFrom yaml read_yaml
get_color_pal <- function() {
    yaml::read_yaml(file = system.file("config/color-palette.yaml", package = get_pkg_name()))
}