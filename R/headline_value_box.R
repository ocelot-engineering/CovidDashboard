#
# Headline value box
#

headline_value_box <- function(subtitle, new_cases, total_cases, perc_inc, icon, color = "light-blue") {
    value_box <- valueBox(
        value = format_num(new_cases), 
        icon = icon,
        color = color,
        subtitle = HTML(paste0(
            "<b>", subtitle, "</b>",
            "<br>",
            format_num(abs(perc_inc)*100, digits = 2), "% ", inc_or_dec(perc_inc),
            "<br>",
            format_num(total_cases, digits = 3, short = TRUE), " in total"
            ))
        )
    
    return(value_box)
}
