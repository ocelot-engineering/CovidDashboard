#
# UI Sizing
#
# R functions to size UI components
#

ui_fit_in_valuebox <- function(..., width = 4) {
    output <- shiny::div(
        class = paste0("col-sm-", width),
        shiny::div(class = "small-box", ...)
        )
    return(output)
}

