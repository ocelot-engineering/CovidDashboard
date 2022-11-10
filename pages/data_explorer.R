#
# Page: Data exploration
#
# Deep dive the data in table view
#

dataExplorerUI <- function(id) {
    ns <- NS(id)
    data_explorer <- underConstructionUI(ns("under_construction"))
    
    return(data_explorer)
}

dataExplorerServer <- function(id) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }
    
    return(moduleServer(id, module))
}
