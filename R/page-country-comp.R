#
# Page: Country comparison
#
# Compare stats of multiple countries side-by-side
#

countryCompUI <- function(id) {
    ns <- NS(id)
    country_comp <- underConstructionUI(ns("under_construction"))

    return(country_comp)
}

countryCompServer <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }

    return(moduleServer(id, module))
}
