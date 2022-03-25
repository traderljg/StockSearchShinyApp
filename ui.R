library(shinyWidgets)
library(shiny)
library(quantmod)
library(tidyquant)
library(dplyr)

shinyUI(fluidPage(
  titlePanel("Stock Charts"),
  #Side Bar
  sidebarLayout(
    sidebarPanel(
      
      #Stock search bar
      textInput("ticker", "Search For A Stock Using Symbol", "BAC"),
      
      
      #Chart Type Input Bar On Side Bar
      selectInput(
        inputId = "type",
        label = "Select A Chart Type",
        c("CandleStick", "Line", "Bar", "MatchStick")
      ),
      
      #Range Slider Bar
      helpText("Specify Range"),
      sliderInput(
        "range",
        "Range:",
        min = 0,
        max = 100,
        value = c(0, 100)
      ),
      
      #Indicators
      radioButtons(
        "Indicator",
        "Choose Indicator",
        c(
          "50-day" = "fiftyAVg",
          "Bolinger Bands" = "BB",
          "ADX" = "Ind_ADX"
        ),
        
      ),
      
      
    ),
    
    
    #Main Chart
    mainPanel(
      #Tab set
      tabsetPanel(
        tabPanel(
          "Chart",
          plotOutput("plot")
        ), 
        tabPanel("Returns",
                 
                 plotOutput("ReturnPlot")
        ),
        tabPanel("Data Set (OHLC)",
                 tableOutput("summary")
        )
        
                )
            )
    
  )
)
)

