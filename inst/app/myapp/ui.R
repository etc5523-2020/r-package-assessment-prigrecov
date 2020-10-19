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

# loading the dataset

# preparing data for table1
data_table1 = covidData[,c("location","Date","total_cases", "new_cases", 
                            "total_deaths", "new_deaths", 
                            "total_tests", "new_tests")]

data_table1 = data_table1 %>% filter(location != "International")

# ui code  ----------------------------------------------------

# Defining the UI component for the application
navbarPage("COVID-19 ACROSS THE WORLD",
           theme = shinythemes::shinytheme("flatly"),
           
           # 1st TAB
           tabPanel("Overall World Data",
                    
                    # Instruction box tab 1
                    text_box("text0"),
                    
                    # Displaying the action buttons and its own instruction  
                    textOutput("text1"),
                    tags$head(tags$style("#text1{color: blue; font-size: 14px; font-style: bold;}")),
                    br(),
                    
                    actionButton("cases", "Positive Cases View"),
                    actionButton("deaths", "Deaths View"),
                    
                    # Displaying the plots 1 and 1B  
                    plotlyOutput("plot1", height = "530px"),
                    verbatimTextOutput("click"),
                    br(),
                    plotOutput("plot1B")
                    ),
           
           # 2nd TAB
           tabPanel("Data by Continent and Country",
                    
                    # Instruction box tab 2
                    text_box("text4"),
                    
                    br(),
                    
                    # Displaying the plot 3 and table 2 on sidebarPanel
                    sidebarLayout(
                        sidebarPanel(
                            h3('1. Data by Continent'),
                            selectInput("statistic", "Which statistic measure do you want to examine?",
                                        choices = c("Cumulative Cases", "Cumulative Deaths", "Daily Cases", 
                                                    "Daily Cases smoothed", "Daily Deaths", "Daily Deaths smoothed"),
                                        selected = "Cumulative Cases"),
                            br(),br(),
                            h3('2. Data by Country'),
                            selectInput("country", "Select a country here:", unique(data_table1$location), 
                                        selected = "Australia"),
                            plotlyOutput("plot3"),
                            br(), br(), 
                            textOutput("text2"),
                            tags$head(tags$style("#text2{color: black; font-size: 17px; font-style: bold;}")),
                            br(), 
                            tableOutput("table2"),
                            br()
                            ),
                        
                        # Displaying the plot 2 and table 1 on mainPanel
                        mainPanel(
                            plotlyOutput("plot2", width = "95%", height = "600px"),
                            br(), br(), br(), br(), 
                            textOutput("text3"),
                            tags$head(tags$style("#text3{color: black; font-size: 20px; font-style: bold;}")),
                            br(), br(),
                            dataTableOutput("table1", width = "95%"),
                            br(),br(),br()
                            )
                        )
                    ),
           
           tabPanel("About",
                    htmlOutput("about"))
           
)

