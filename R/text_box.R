#' Text box instructions function
#'
#' @param text text id 
#'
#' @return Box with instructions text set in the server code
#'
#' @example
#' text_box(text0)
#' 
#' @export
text_box <- function(text) {
  wellPanel(
    fluidRow(
      box(title = "Instructions", width = 11, 
          htmlOutput(text))
    ))
}
