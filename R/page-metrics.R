#
# Page: Metrics
#
# Explanation of metrics
#

metricsUI <- function(id) {
    ns <- NS(id)
    metrics <- underConstructionUI(ns("under_construction"))

    return(metrics)
}

metricsServer <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }

    return(moduleServer(id, module))
}
