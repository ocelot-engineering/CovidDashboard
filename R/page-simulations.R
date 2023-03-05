#
# Page: Simulations
#
# Simulate impacts given actions such as mask mandates and stay at home orders.
#

simulationsUI <- function(id) {
    ns <- NS(id)
    simulations <- underConstructionUI(ns("under_construction"))

    return(simulations)
}

simulationsServer <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }

    return(moduleServer(id, module))
}
