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
library(forecast)
library(purrr)

# Sources -----------------------------------------------------------------

# Functions
source("R/enhanced_base_utilties.R", local = TRUE)
source_dir(dir = "./R", local = TRUE)

# Components
source_dir(dir = "./components", local = TRUE)

# Pages
source_dir(dir = "./pages", local = TRUE)

# Configuration
source_dir(dir = "./config", local = TRUE)



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
    
    # Trigger debug from javascript
    observeEvent(input$debug, {
        message("browser() triggered by javascript function debug()")
        browser()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
