#
# Time series plot
#
# TODO
# TODO switch from raw to smooth
# TODO add log y scale switch

blank_ts_plot <- function(dat) {
    
    fig <- plot_ly() %>%
        config(displayModeBar = FALSE) %>% 
        config(displaylogo = FALSE) # %>%
        # add_trace(data = dat, type = 'scatter', mode = 'lines', fill = 'tozeroy', x = ~DATE_REPORTED, y = ~NEW_CASES, name = 'NEW CASES') %>%
        # add_trace(data = dat, type = 'scatter', mode = 'lines', fill = 'tozeroy', x = ~DATE_REPORTED, y = ~NEW_DEATHS, name = 'NEW DEATHS', yaxis = "y2")
        # add_trace(data = dat, type = 'scatter', mode = 'lines', x = ~DATE_REPORTED, y = ~NEW_CASES, name = 'NEW CASES')
    
    xaxis <- list(
        zerolinecolor = '#ffff'
      , zerolinewidth = 2
      , gridcolor = 'ffff')
    
    yaxis_left <- list(
        zerolinecolor = '#ffff'
      , zerolinewidth = 2
      , gridcolor = 'ffff')
    
    yaxis_right <- list(
        overlaying = "y"
      , side = "right"
      , title = "<b>Reported Deaths</b> Deaths")
    
    # options(warn = -1)
    fig <- fig %>%
        layout(
            showlegend = FALSE,
            xaxis = xaxis,
            yaxis = yaxis_left,
            yaxis2 = yaxis_right,
            plot_bgcolor = colour_pallet$dark_highlight,
            paper_bgcolor = colour_pallet$light_highlight)
    
    
    return(fig)
}


