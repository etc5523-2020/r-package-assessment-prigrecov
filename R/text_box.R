#' Text box instructions function
#' 
#' @description This function gives you a box in the wellPanel with text inside 
#' 
#' @param text This is the text id for the text to be written inside the box
#'
#' @return Box with instructions text inside to be set in the server logic unit
#' 
#' @import shiny
#' @import shinydashboard
#' 
#' @examples  
#' text = "text0"
#' text_box(text)
#' 
#' @export
text_box <- function(text) {
  
  char_count <- nchar(text)
  n_input <- length(text)
  
  stopifnot(
    char_count > 0,
    n_input > 0
  )
  
  wellPanel(
    fluidRow(
      box(title = "Instructions", width = 11, 
          htmlOutput(text))
    ))
}
