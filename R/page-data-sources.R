#
# Page: Data sources
#
# Explanation of data sources used
#

dataSourcesUI <- function(id) {
    ns <- NS(id)
    data_sources <- underConstructionUI(ns("under_construction"))

    return(data_sources)
}

dataSourcesServer <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }

    return(moduleServer(id, module))
}
