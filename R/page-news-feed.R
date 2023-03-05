#
# Page: News Feed
#
# Feed of notifications received. Header notifications will link to here.
#

newsFeedUI <- function(id) {
    ns <- NS(id)
    news_feed <- underConstructionUI(ns("under_construction"))

    return(news_feed)
}

newsFeedServer <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }

    return(moduleServer(id, module))
}
