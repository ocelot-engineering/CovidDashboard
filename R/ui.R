#
# Main UI function for app
#

#' UI function
#' @keywords internal
#' @import shiny
ui <- shinydashboardPlus::dashboardPage(
    header      = header_ui(id = "app_header"),
    sidebar     = sidebar_ui(id = "left_sidebar"),
    body        = body_ui(id = "dashboard_body"),
    controlbar  = controlbar_ui(id = "controlbar"),
    title       = "COVID-19", # text displayed in chrome tab
    skin        = "midnight",
    scrollToTop = TRUE
)