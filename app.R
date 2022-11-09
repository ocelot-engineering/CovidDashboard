#
# Covid-19 Dashboard Web Application
#
# Please make sure to keep this script small. When adding new functionality it
#  is very unlikely you should add it to app.R.
# 

# Libraries ---------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(dplyr)
library(readr)
library(lubridate)
library(plotly)

# Sources -----------------------------------------------------------------

# Components
source("components/header.R", local = TRUE)
source("components/sidebar.R", local = TRUE)
source("components/body.R", local = TRUE)
source("components/controlbar.R", local = TRUE)

# Pages
source("pages/overview.R", local = TRUE)


# Configuration -----------------------------------------------------------


# Application -------------------------------------------------------------

ui <- shinydashboardPlus::dashboardPage(
    header      = headerUI(id = "app_header")
  , sidebar     = sidebarUI(id = "left_sidebar")
  , body        = bodyUI(id = "dashboard_body")
  , controlbar  = controlbarUI(id = "controlbar")
  , title       = "COVID-19" # text displayed in chrome tab
  , skin        = "midnight"
  , scrollToTop = TRUE
)

server <- function(input, output) {
    headerServer(id = "app_header")
    sidebarServer(id = "left_sidebar")
    bodyServer(id = "dashboard_body")
    controlbarSever(id = 'controlbar')
}

# Run the application 
shinyApp(ui = ui, server = server)
