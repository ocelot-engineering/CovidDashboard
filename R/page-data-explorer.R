#
# Page: Data exploration
#
# Deep dive the data in table view
#

#' Page: Data exploration ui function
#' @inherit module_docs params
#' @importFrom DT dataTableOutput
data_explorer_ui <- function(id) {
    ns <- shiny::NS(id)

    data_explorer <- shiny::fluidPage(
        shiny::fluidRow(shiny::div("TEST", class = "top-padding")),
        shiny::fluidRow(shiny::column(width = 12, DT::dataTableOutput(ns("daily_cases"))))
        # fluidRow(column(width = 12, DT::dataTableOutput(ns("vax")))),
        # fluidRow(column(width = 12, DT::dataTableOutput(ns("population"))))
    )

    return(data_explorer)
}

#' Page: Data exploration server function
#'
#' @inherit module_docs params
#' @inherit common_docs params
#'
#' @importFrom DT renderDataTable
#' @importFrom dplyr slice_head
#'
data_explorer_server <- function(id, daily_cases, vax, population) {

    module <- function(input, output, session) {
        ns <- session$ns

        output$daily_cases <- DT::renderDataTable({
            aaa = daily_cases %>% dplyr::slice_head(n = 50)
            # browser()
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

    return(shiny::moduleServer(id, module))
}
