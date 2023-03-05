#
# Main UI function for app
#

#' UI function
#' @keywords internal
#' @import shiny
ui <- shinydashboardPlus::dashboardPage(
    header      = headerUI(id = "app_header"),
    sidebar     = sidebarUI(id = "left_sidebar"),
    body        = bodyUI(id = "dashboard_body"),
    controlbar  = controlbarUI(id = "controlbar"),
    title       = "COVID-19", # text displayed in chrome tab
    skin        = "midnight",
    scrollToTop = TRUE
)