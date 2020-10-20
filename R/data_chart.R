globalVariables(c("covidData","Date","total_cases","total_deaths","new_cases", "new_cases_smoothed","new_deaths","new_deaths_smoothed",
                  "Cumulative_Cases", "Cumulative_Deaths"))

#' Data processing for charts
#'
#' @description This function prepares the dataset with some filters, groupings and summarizing to be used into plotting codes.
#'
#' @param dataset This is the dataset to be processed
#' @param group_byparameter This is the column of the dataset to be used inside of groupby() function together with the column "Date"
#'
#' @return The dataset processed to be used to plot the chart 
#'
#' @import dplyr
#' 
#' @examples 
#' data_chart(dataset=covidData, group_byparameter="location")
#' 
#' @export
data_chart <- function(dataset=covidData, group_byparameter) {
  
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
  
  dataset <- stats::setNames(dataset, c("Date", group_byparameter,"Cumulative Cases", 
                                 "Cumulative Deaths", "Daily Cases", "Daily Cases smoothed", 
                                 "Daily Deaths", "Daily Deaths smoothed"))
  
  return (dataset) 
}