#
# Example of a component using Shiny modules
#

componentUI <- function(id, ...) {
    ns <- NS(id)
    
    html_output <- html_generator(...)
    
    return(html_output)
}


componentServer <- function(id, ...) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        severFunction(...)
    }
    
    return(moduleServer(id, module))
}
