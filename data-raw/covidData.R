## code to prepare `covidData` dataset goes here

# loading the dataset
covidData <- read.csv("data-raw/covidData.csv") 

# formatting data
covidData$Date <- as.Date(covidData$date)
covidData$Month <- months(covidData$Date)
covidData$Month = factor(covidData$Month, levels=c('December','January','February','March',
                                                     'April','May','June','July','August',
                                                     'September'))


usethis::use_data(covidData, overwrite = TRUE)
