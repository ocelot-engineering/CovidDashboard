# 
# Example of testing reactive expressions using testthat
#

server <- function(input, output, session) {
    xy <- reactive(input$x - input$y)
    yz <- reactive(input$z + input$y)
    xyz <- reactive(xy() * yz())
    output$out <- renderText(paste0("Result: ", xyz()))
}

testthat::test_that("reactives and output updates", {
    testServer(server, {
        session$setInputs(x = 1, y = 1, z = 1)
        testthat::expect_equal(xy(), 0)
        testthat::expect_equal(yz(), 2)
        testthat::expect_equal(output$out, "Result: 0")
    })
})
