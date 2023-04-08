#
# Headline value box
#

#' Create a headline value box
#' @param subtitle string: subtitle of value box e.g. "New Cases"
#' @param new_cases numeric: increase value
#' @param total_cases numeric: total value
#' @param perc_inc numeric: percentage increase
#' @param icon icon tag
#' @importFrom shinydashboard valueBox
headline_value_box <- function(subtitle, new_cases, total_cases, total_suffix = "in total", perc_inc, icon, color = "light-blue") {

    total_msg <- if (!is.null(total_cases)) {
        paste0("<br>", format_num(total_cases, digits = 3, short = TRUE), " ", total_suffix)
    } else {
        "<br><br>"
    }

    perc_inc_msg <- if (!is.null(perc_inc)) {
        paste0("<br>", format_num(abs(perc_inc) * 100, digits = 2), "% ", inc_or_dec(perc_inc))
    } else {
        "<br><br>"
    }

    value_box <- shinydashboard::valueBox(
        value = format_num(new_cases),
        icon = icon,
        color = color,
        subtitle = HTML(paste0(
            "<b>", subtitle, "</b>",
            total_msg,
            perc_inc_msg
            ))
        )

    return(value_box)
}

