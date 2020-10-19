#' Shiny APP embedding function
#' 
#' @return Shiny APP launched
#' 
#' @export
launch_app <- function() {
  appDir <- system.file("app", "myapp", package = "shinyCovidWorld")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `shinyCovidWorld`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}