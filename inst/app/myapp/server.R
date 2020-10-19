########################################################
# ETC5523 - COMMUNICATING WITH DATA                    #
# SHINY ASSESSMENT                                     #
# STUDENT: PRISCILA GRECOV                             #
# STUDENT ID: 29880858                                 #
########################################################

# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Libraries  ----------------------------------------------------
library(shiny)
library(plotly)
library(dplyr)
library(ggthemes)
library(ggplot2)
library(scales)
library(DT)
library(knitr)
library(kableExtra)
library(tidyverse)
library(ggridges)
library(viridis)
library(shinydashboard)

# COVID data ----------------------------------------------------

# # loading the dataset
# covid_data <- read.csv("owid-covid-data.csv")
# 
# # formatting data
# covid_data$Date <- as.Date(covid_data$date)
# covid_data$Month <- months(covid_data$Date)
# covid_data$Month = factor(covid_data$Month, levels=c('December','January','February','March',
#                                                      'April','May','June','July','August',
#                                                      'September'))
# preparing data for plot1
data1 <- covidData %>%
    filter(location == "World") %>%
    group_by(Date) %>%
    summarize(Cumulative_Cases = sum(total_cases),
              Cumulative_Deaths = sum(total_deaths),
              Daily_Cases = sum(new_cases),
              Daily_Deaths = sum(new_deaths),
              .groups = 'drop') 


# preparing data for plot2
# data2 <- covidData %>%
#     filter(continent != "") %>%
#     filter(Date >= '2020-02-01') %>%
#     group_by(Date, continent) %>%
#     summarize(Cumulative_Cases = sum(total_cases),
#               Cumulative_Deaths = sum(total_deaths),
#               Daily_Cases = sum(new_cases),
#               Daily_Cases_smoothed = sum(new_cases_smoothed),
#               Daily_Deaths = sum(new_deaths),
#               Daily_Deaths_smoothed = sum(new_deaths_smoothed),
#               .groups = 'drop') %>%
#     filter(!is.na(Cumulative_Cases)) %>%
#     filter(!is.na(Cumulative_Deaths)) 
# 
# data2 <- setNames(data2, c("Date","Continent","Cumulative Cases", 
#                            "Cumulative Deaths", "Daily Cases", "Daily Cases smoothed", 
#                            "Daily Deaths", "Daily Deaths smoothed"))

data2 <- covidData %>% filter(continent != "")

data2 <- data_chart(dataset=data2, group_byparameter1="Date", group_byparameter2="continent") 

# preparing data for plot3
# data3 <- covidData %>%
#     filter(Date >= '2020-02-01') %>%
#     group_by(Date, location) %>%
#     summarize(Cumulative_Cases = sum(total_cases),
#               Cumulative_Deaths = sum(total_deaths),
#               Daily_Cases = sum(new_cases),
#               Daily_Cases_smoothed = sum(new_cases_smoothed),
#               Daily_Deaths = sum(new_deaths),
#               Daily_Deaths_smoothed = sum(new_deaths_smoothed),
#               .groups = 'drop') %>%
#     filter(!is.na(Cumulative_Cases)) %>%
#     filter(!is.na(Cumulative_Deaths)) 
# 
# data3 <- setNames(data3, c("Date","location","Cumulative Cases", 
#                            "Cumulative Deaths", "Daily Cases", "Daily Cases smoothed", 
#                            "Daily Deaths", "Daily Deaths smoothed"))

data3 <- data_chart(covidData, group_byparameter1="Date", group_byparameter2="location")

# preparing data for table1
data_table1 = covidData[,c("location","Date","total_cases", "new_cases", 
                            "total_deaths", "new_deaths", 
                            "total_tests", "new_tests")] 

data_table1 = data_table1 %>% filter(location != "International")


# sever code  ----------------------------------------------------

# Defining the server logic required to draw the 3 plots and 2 tables
function(input, output, session) {
    
    ### TAB 1 - Overall World Data
    
    output$text0 <- renderText({
        paste("By the buttons, the user can choose if she wants to 
              see the <i>global</i> <b>COVID-19 positive cases</b> data or the <b>COVID-19 
              deaths</b> data displayed on the charts of this panel.", 
              "<br>", 
              "<li><b>Graph 1:</b> displays, at the same time, the evolution of <b>daily</b> data series <i>(shown by bars)</i> and <b>accumulated</b> data
              series <i>(indicated by line)</i> for the selected information. When clicking with the cursor in any data point, the <i>x</i> 
              and <i>y</i> values are displayed in pop-ups labels and also in the interactive text box just below the graph.</li>",
              "<li><b>Graph 1B:</b> summarizes the same data displaying how the <i>distribution</i> of this selected data series evolutes 
              across the months, plotting a <b>grid of density curves</b> of the picked data series. This vision permits analyzing 
              the evolution of <b>averages</b> and <b>dispersion/variance</b> of the selected data.</li>")
    })
    
    output$text1 <- renderText({
        paste("Click on which data do you want to visualize in graphs below:")
    })
    
    output$plot1 <- renderPlotly({
        graph_world1 <- data1 %>%
            plot_ly() %>%
            add_bars(x = data1$Date, y = data1$Daily_Cases, name="daily") %>%
            add_lines(x = data1$Date, y = data1$Cumulative_Cases, yaxis = "y2", name="accumulated") %>%
            layout(
                title = 'Graph 1: Evolution of COVID-19 positive cases in the World', 
                yaxis2 = list(
                    tickfont = list(color = "orange"),
                    titlefont=list(color="orange"),
                    overlaying = "y",
                    side = "right",
                    title = "total of accumulated cases"),
                yaxis = list(title='daily qty of new cases', color="blue")
            )
        
        graph_world1 %>%
            config(displayModeBar = F)
    })
    
    output$plot1B <- renderPlot({
        covid_data_world <- covidData %>%
            filter(location == "World") %>%
            filter(Date > '2019-12-31')
        ridgePlot <- ggplot(covid_data_world, aes(x = new_cases_smoothed, y = Month, fill = Month)) + 
            geom_density_ridges(scale = 4, bandwidth = 4570) +
            scale_fill_viridis(alpha = 0.7, discrete = TRUE) +
            theme_ridges(font_size = 17) + 
            labs(title = 'Graph 1B: Global New Cases Distribution over Months (smoothed data)') +
            scale_x_continuous(labels = scales::label_comma()) +
            ylab("") +
            xlab('qty of new cases') +
            theme(legend.position = "none")
        ridgePlot
    })
    
    observeEvent(input$cases, {
        
        output$plot1 <- renderPlotly({
            graph_world1 <- data1 %>%
                plot_ly() %>%
                add_bars(x = data1$Date, y = data1$Daily_Cases, name="daily") %>%
                add_lines(x = data1$Date, y = data1$Cumulative_Cases, yaxis = "y2", name="accumulated") %>%
                layout(
                    title = 'Graph 1: Evolution of COVID-19 positive cases in the World', 
                    yaxis2 = list(
                        tickfont = list(color = "orange"),
                        titlefont=list(color="orange"),
                        overlaying = "y",
                        side = "right",
                        title = "total of accumulated cases"),
                    yaxis = list(title='daily qty of new cases', color="blue")
                )
            
            graph_world1 %>%
                config(displayModeBar = F)
        })
        
        output$plot1B <- renderPlot({
            covid_data_world <- covidData %>%
                filter(location == "World") %>%
                filter(Date > '2019-12-31')
            ridgePlot <- ggplot(covid_data_world, aes(x = new_cases_smoothed, y = Month, fill = Month)) + 
                geom_density_ridges(scale = 4, bandwidth = 4570) +
                scale_fill_viridis(alpha = 0.7, discrete = TRUE) +
                theme_ridges(font_size = 17) + 
                labs(title = 'Graph 1B: Global New Cases Distribution over Months (smoothed data)') +
                scale_x_continuous(labels = scales::label_comma()) +
                ylab("") +
                xlab('qty of new cases') +
                theme(legend.position = "none")
            ridgePlot
        })
    })
    
    observeEvent(input$deaths, {
        
        output$plot1 <- renderPlotly({
            graph_world1 <- data1 %>%
                plot_ly() %>%
                add_bars(x = data1$Date, y = data1$Daily_Deaths, name="daily") %>%
                add_lines(x = data1$Date, y = data1$Cumulative_Deaths, yaxis = "y2", name="accumulated") %>%
                layout(
                    title = 'Graph 1: Evolution of COVID-19 deaths in the World', 
                    yaxis2 = list(
                        tickfont = list(color = "orange"),
                        titlefont=list(color="orange"),
                        overlaying = "y",
                        side = "right",
                        title = "total of accumulated deaths"),
                    yaxis = list(title='daily qty of new deaths', color="blue")
                )
            
            graph_world1 %>%
                config(displayModeBar = F)
        })
        
        output$plot1B <- renderPlot({
            covid_data_world <- covidData %>%
                filter(location == "World") %>%
                filter(Date > '2019-12-31')
            ridgePlot <- ggplot(covid_data_world, aes(x = new_deaths_smoothed, y = Month, fill = Month)) + 
                geom_density_ridges(scale = 4, bandwidth = 173) +
                scale_fill_viridis(alpha = 0.7, discrete = TRUE) +
                theme_ridges(font_size = 17) + 
                labs(title = 'Graph 1B: Global New Deaths Distribution over Months (smoothed data)') +
                scale_x_continuous(labels = scales::label_comma()) +
                ylab("") +
                xlab('qty of new deaths') +
                theme(legend.position = "none")
            ridgePlot
        })
        
    })
    
    
    output$click <- renderPrint({
        d <- event_data("plotly_click")
        if (is.null(d)) return("Click a point in line or bar of the graph above to see the values here.") else print(d,row.names = FALSE)
        
    })
    
    ### TAB 2 - Data by Continent and Country
    
    output$text4 <- renderText({
        paste("In this panel, the data is displayed by <b>Continent</b> <i>(Graph 2)</i> and by <b>Country</b> <i>(Graph 3 and Tables 1 and 2)</i>.", 
              "<br>", 
              "In the <b>1st input selection box</b>, the user can <b>select</b> one of 6 <b>measures</b> available. The measure chosen will be plotted 
              in the <i>multiple line chart (Graph 2)</i> for all the six continents, and in <i>Graph 3</i> for the <b>country selected</b> 
              on the <b>2nd input selection box</b>.",
              "<br>", 
              "<li><b>Graph 2:</b> permits analyzing the evolution of the chosen statistic data over time and across all continents at the same time. Pop-up labels are
              displayed when clicking over the data points.</li>",
              "<li><b>Graph 3:</b> changes according to the user choices for country and statistic measure. This plot allows us to observe the combined evolution 
              of the chosen statistic measure over time for each country selected by the user. It also displays pop-up labels when clicking over the data points.</li>",
              "<li><b>Table 1:</b> compiles the complete daily time-series information of confirmed cases, deaths and tests, recorded in the daily and accumulated basis, 
              for the country selected. This interactive table is designed for user data exploration, being possible filtering, 
              searching, and sorting the full data in many ways. Therefore, users can explore the entire data recordings by themselves, for each one of 210 countries.</li>",
              "<li><b>Table 2:</b> shows, for the same country selected by the user, a more concise information of the monthly average of new positive cases and deaths 
              and the maximum levels achieved on the month — a summary view of average and maximum recordings evolution over the months, for each country</li>")
    })
    
    output$plot2 <- renderPlotly({
        data2$qty <- unlist(data2[input$statistic])
        graph_Continent <- ggplot(data = data2, 
                                  aes(x = Date, y = qty))+
            geom_line(aes(color=continent))+
            xlab("") +
            ylab("") +
            scale_x_date(date_labels = "%d-%m", date_breaks  ="10 days", limits = as.Date(c('2020-02-01','2020-09-30'))) +
            scale_y_continuous(labels = scales::label_comma()) +
            theme_economist() + scale_colour_economist() +
            theme(axis.text.x=element_text(angle=60, hjust=1, size = 10),
                  legend.title=element_blank(), legend.text=element_text(size=9),
                  plot.title = element_text(size = 13, face = "plain")) +
            labs(title = paste("Graph 2: ", input$statistic, "per Continent"),
                 subtitle = "(click over the lines to see the data details)") 
        ggplotly(graph_Continent) %>% 
            config(displayModeBar = F)
    })
    
   
    output$plot3 <- renderPlotly({
        
        data3b <- data3 %>% filter(location == input$country)
        data3b$qty <- unlist(data3b[input$statistic])
        graph_Country <- ggplot(data = data3b, 
                                  aes(x = Date, y = qty))+
            geom_col(fill="skyblue3") +
            xlab("") +
            ylab("") +
            scale_x_date(date_labels = "%d-%m", date_breaks  ="10 days", limits = as.Date(c('2020-02-01','2020-09-30'))) +
            scale_y_continuous(labels = scales::label_comma()) +
            theme_bw() +
            theme(axis.text.x=element_text(angle=60, hjust=1, size = 8),
                  legend.title=element_blank(), legend.text=element_text(size=9),
                  plot.title = element_text(size = 11)) +
            labs(title = paste("Graph 3: ", input$statistic, "of", input$country),
                 subtitle = "(click over the lines to see the data details)") 
        ggplotly(graph_Country, source = "src") %>% 
            config(displayModeBar = F)
    })
    
    
    output$text3 <- renderText({
        paste("TABLE 1: Analytical daily data by Country")
    })
    
    
    output$table1 <- renderDataTable({
        data_table1B <- data_table1 %>% filter(location == input$country)
        datatable(data_table1B[,-1],
                  filter = 'top',
                  options = list(pageLength = 10, autoWidth = TRUE,
                                 order = list(list(1, 'desc'))),
                  rownames = FALSE,
                  caption = paste('Daily COVID-19 Data for', toupper(input$country)),
                  colnames = c('Date', 'Total Cases', 'New Cases', 'Total Deaths', 'New Deaths',
                               'Total Tests', 'New Tests')
        ) %>%
            formatCurrency(c('total_cases', 'new_cases', 'total_deaths', 'new_deaths', 'total_tests', 'new_tests'),
                           currency = "", interval = 3, mark = ",", digits = 0)
    })
    
    output$text2 <- renderText({
        paste("TABLE 2: Summary of Monthly Statistics by Country")
    })
    
    output$table2 <- function() {
        req(input$country)
        cols <- c('Month', 'new_cases', 'new_deaths')
        data_table2 <- covidData %>% filter(location == input$country)
        data_table2 <- data_table2[cols]
        
        data_table2 %>% 
            group_by(Month) %>% 
            summarise(
                Average1 = comma(round(mean(new_cases, na.rm=TRUE),0)),
                Maximum1 = comma(round(max(new_cases, na.rm=TRUE),0)),
                Average2 = comma(round(mean(new_deaths, na.rm=TRUE),0)),
                Maximum2 = comma(round(max(new_deaths, na.rm=TRUE),0)),
                ) %>%
            knitr::kable("html", align = "lrrrr", booktabs = TRUE,
                         caption = paste("Summary COVID-19 Data for", toupper(input$country), "(Dec/19 - Sep/20)")) %>%
            kable_styling(full_width = T,) %>%
            kable_styling(bootstrap_options = c("striped", "hover")) %>%
            add_header_above(c(" ", "New Cases" = 2, "New Deaths" = 2))
    }
    
    ### TAB 3 - About
    
    output$about <- renderText({
        paste('<b>AUTHOR:</b>',
              '<br>',
              'My name is Priscila Grecov, and I am a Master student at Monash University (Australia), majoring in Data Science.',
              '<br>',
              'This project is my Shiny assessment product conducted while coursing the "ETC5523-Communicating with Data" unit.',
              '<br>',
              '<br>',
              '<b>THE CORONAVIRUS DASHBOARD:</b>',
              '<br>',
              'This Shiny App aims to provide an overview analysis of the Novel Coronavirus pandemic across the world using some interactive 
              graphs and tables as visualization tools for this, which were built using the Shiny framework in R.', 
              '<br>',
              'It starts by analyzing the 
              progress of Covid-19 positive cases and deaths globally. After that, it progresses detailing the data by continent, 
              comparing the evolution of new cases and deaths, in a daily and accumulated basis, through the six continents. 
              Later, we are zooming the data country by country with more granulated data to explore the evolution of this pandemic 
              over each one of 210 countries contained in the dataset. The analysis was done using a date range from the commencing 
              of pandemic data recording (end of December of 2019) up to 30 September 2020. The interactive graphs and tables allow 
              updating the data and views according to a change/selection from user input provided by shiny features, permitting a 
              customized data exploration according to the user interest.',
              '</b>',
              '<br>',
              '<br>',
              '<li><u>DATA SOURCE</u>:',
              '<br>',
              '<ul>The raw input data used for this application are retrieved from this <a href="https://github.com/owid/covid-19-data/tree/master/public/data"> GitHub repo</a>.',
              '<br>',
              'The <i>"Our World in Data"</i> (<a href="https://ourworldindata.org">https://ourworldindata.org</a>) is the organization that maintains this data, which is updated daily and includes data on confirmed cases, deaths, 
              and testing, as well as other variables of potential interest from several countries across the world.</ul></li>',
              '<li><u>DEPLOYMENT AND REPRODUCIBILITY</u>:',
              '<br>',
              '<ul>The dashboard was deployed to Github docs, then the code behind it is available on this 
              <a href="https://github.com/etc5523-2020/shiny-assessment-prigrecov">repo</a> .',
              '<br>',
              'If you wish to deploy the code, clone it following the 
              instructions on the README content of this repo.</ul></li>',
              '<br>',
              'For any question or feedback, you can either open an <a href="https://github.com/etc5523-2020/shiny-assessment-prigrecov/issues">issue</a> 
              or contact me by email: pgre0007@student.monash.edu'
              )
        
    })
}





