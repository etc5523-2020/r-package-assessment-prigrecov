#' Data processing for charts
#'
#' @param dataset This is the dataset to be processed
#' @param group_byparameter1 This is the 1st parameter of groupby() function
#' @param group_byparameter2 This is the 2nd parameter of groupby() function
#'
#' @return The dataset processed to be used to plot the chart 
#'
#' @example
#' data-pos(covidData, Date, continent)
#' 
#' @export
data_chart <- function(dataset, group_byparameter) {
  
  char_count <- nchar(group_byparameter)
  n_input <- length(group_byparameter)
  
  stopifnot(
    char_count > 0,
    n_input > 0
  )
  
  dataset <- dataset %>%
    filter(Date >= '2020-02-01') %>%
    group_by(Date, get(group_byparameter)) %>%
    summarize(Cumulative_Cases = sum(total_cases),
              Cumulative_Deaths = sum(total_deaths),
              Daily_Cases = sum(new_cases),
              Daily_Cases_smoothed = sum(new_cases_smoothed),
              Daily_Deaths = sum(new_deaths),
              Daily_Deaths_smoothed = sum(new_deaths_smoothed),
              .groups = 'drop') %>%
    filter(!is.na(Cumulative_Cases)) %>%
    filter(!is.na(Cumulative_Deaths))
  
  dataset <- setNames(dataset, c("Date", group_byparameter,"Cumulative Cases", 
                                 "Cumulative Deaths", "Daily Cases", "Daily Cases smoothed", 
                                 "Daily Deaths", "Daily Deaths smoothed"))
  
  return (dataset) 
}