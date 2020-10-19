#' Text box instructions function
#'
#' @param text text id 
#'
#' @return Box with instructions text set in the server code
#' 
#' @import shiny
#' @import shinydashboard
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
