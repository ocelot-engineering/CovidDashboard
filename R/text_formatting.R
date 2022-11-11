#
# Text formatting
#
# TODO add tests


#' Formats a number to more readable
#' 
#' @param num integer or numeric scalar: number will be formatted to string
#' @param digits a positive integer indicating how many significant digits are to be used for numeric and complex x. The default, NULL, uses getOption("digits"). 
#' @param short if TRUE trims the string down and applies a suffix. E.g. 11100000 -> 11.1M
#' 
#' @returns string: string of a number formatted nicely
#' 
#' @examples
#' \dontrun{
#' format_num(1111, digits = 1, short = TRUE)
#' format_num(123456789, short = FALSE)
#' format_num(1234567890, digits = 3, short = TRUE)
#' }
#' 
format_num <- function(num, digits = NULL, short = FALSE) {
    
    output <- if(short) {
        magnitude <- nchar(num)
        
        formatting <- if (dplyr::between(magnitude, 4, 6)) {
            list("K", 3)
        } else if (dplyr::between(magnitude, 7, 9)) {
            list("M", 6)
        } else if (magnitude >= 10) {
            list("B", 9)
        } else {
            list("", 0)
        }
        names(formatting) <- c("suffix", "power")
        
        paste0(format(num/10^formatting$power, digits = digits), formatting$suffix, sep = "")
    } else {
        format(num, digits = digits, big.mark = ",")
    }

    return(output)
}


#' Checks if a number is positive or negative and returns increase or decrease
#' 
#' @param num integer or numeric scalar: number will be formatted to string
#' 
#' @returns string: either increase, decrease or ""
#' 
#' @examples
#' \dontrun{
#' inc_or_dec(1)
#' nc_or_dec(-1)
#' inc_or_dec(0)
#' }
#' 
inc_or_dec <- function(num) {
    text <- if (num > 0) {
        "increase"
    } else if (num < 0) {
        "decrease"
    } else {
        "change"
    }
    
    return(text)
}
