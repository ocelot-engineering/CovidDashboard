#
# Page: Overview
#
# Starting page of the dashboard that gives a world overview of COVID.
#

overviewUI <- function(id) {
    ns <- NS(id)
    
    overview <- fluidPage(
        fluidRow(
            column(width = 12, p("TODO"))
        ),
        fluidRow(
            column(width = 12, p("TODO"))
        )
    )
    
    return(overview)
}

overviewServer <- function(id) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        output <- NULL
        return(output)
    }
    
    return(moduleServer(id, module))
}

