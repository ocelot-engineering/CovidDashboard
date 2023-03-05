#
# Page: Data exploration
#
# Deep dive the data in table view
#

dataExplorerUI <- function(id) {
    ns <- NS(id)

    data_explorer <- fluidPage(
        fluidRow(div("TEST", class = "top-padding")),
        fluidRow(column(width = 12, DT::dataTableOutput(ns("daily_cases"))))
        # fluidRow(column(width = 12, DT::dataTableOutput(ns("vax")))),
        # fluidRow(column(width = 12, DT::dataTableOutput(ns("population"))))
    )

    return(data_explorer)
}

dataExplorerServer <- function(id, daily_cases, vax, population) {

    module <- function(input, output, session) {
        ns <- session$ns

        output$daily_cases <- DT::renderDataTable({
            aaa = daily_cases %>% slice_head(n = 50)
            browser()
            DT::datatable(
                data = aaa, 
                # options = list(lengthMenu = c(5, 30, 50), pageLength = 5),
                style = "bootstrap4",
                editable = FALSE,
            )
        }, server = TRUE)

        # output$vax <- DT::renderDataTable({
        #     DT::datatable(
        #         data = vax, 
        #         # options = list(lengthMenu = c(5, 30, 50), pageLength = 5),
        #         style = "bootstrap4",
        #         editable = FALSE
        #     )
        # })
        # 
        # output$population <- DT::renderDataTable({
        #     DT::datatable(
        #         data = population, 
        #         # options = list(lengthMenu = c(5, 30, 50), pageLength = 5),
        #         style = "bootstrap4",
        #         editable = FALSE
        #     )
        # })
    }

    return(moduleServer(id, module))
}
