#' Shiny APP launch function
#' 
#' @description This function launchs the shiny app for the user
#' 
#' @return Shiny APP launched
#' 
#' @examples
#' \dontrun{
#' launch_app()
#' }
#'
#' @export
launch_app <- function() {
  appDir <- system.file("app", "myapp", package = "shinyCovidWorld")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `shinyCovidWorld`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}