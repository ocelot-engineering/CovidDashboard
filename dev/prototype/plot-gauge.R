#
# Plot gauge
#

plot_gauge <- function() {

    previous <- 70

    fig <- plot_ly(
        type = "indicator",
        mode = "gauge+number+delta",
        value = 88,
        title = list(text = "Risk", font = list(size = 24)),
        delta = list(reference = previous, increasing = list(color = "red"), decreasing = list(color = "green")),
        gauge = list(
            axis = list(range = list(0, 100), tickwidth = 1, tickcolor = get_color_pal()$background),
            bar = list(color = get_color_pal()$light_highlight),
            bgcolor = "white",
            borderwidth = 2,
            bordercolor = "gray",
            steps = list(
                list(range = c(0, 50), color = "green"),
                list(range = c(50, 75), color = "orange"),
                list(range = c(75, 100), color = "red")),
            threshold = list(
                line = list(color = "purple", width = 4),
                thickness = 0.75,
                value = previous)))
    fig <- fig %>%
        config(displayModeBar = FALSE) %>%
        config(displaylogo = FALSE) %>%
        layout(
            margin = list(l = 20,r = 30),
            paper_bgcolor = get_color_pal()$background, 
            font = list(color = get_color_pal()$white, family = "Arial"))

    return(fig)
}