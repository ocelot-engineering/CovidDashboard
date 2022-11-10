#
# Page: Vaccines
#
# Understand where to find reliable, up-to-date and accurate information about
#  vaccines
#

vaccinesUI <- function(id) {
    ns <- NS(id)
    vaccine <- underConstructionUI(ns("under_construction"))
    
    return(vaccine)
}

vaccinesServer <- function(id) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }
    
    return(moduleServer(id, module))
}
