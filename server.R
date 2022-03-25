library(shiny)
library(quantmod)
library(tidyquant)
library(dplyr)

shinyServer(function(input, output) {
  
  dataInput <- reactive({
    
    #Starting date of data to be request
    start_date <- Sys.Date() - 365
    
    #Get data
    stocks = getSymbols(
      input$ticker,
      src = "yahoo",
      from = start_date,
      warnings = FALSE,
      auto.assign = FALSE
    )
    

    
    #Calculate the number of rows in dataframe, this equates to number of days
    slide_points = NROW(stocks)
    
    min = input$range[1] / 100 * slide_points
    max = input$range[2] / 100 * slide_points
    
    value = stocks[min:max, ]
    
    return (value)

  })
  
  #Indicator based on selection
  Indicator <- reactive({
    if (input$Indicator == "fiftyAVg") {
      addSMA(n = 50, col = "blue")
    }
    else if (input$Indicator == "BB") {
      addBBands(n = 20, sd = 2, maType = "SMA", draw = 'bands', on = -1)
    }
    else {
      addADX(n = 14, maType="EMA", wilder=TRUE)
    }
  })
  
  
  #Different chart type based on selection of input
  output$plot <- renderPlot({
    
    if (input$type == "Line") {
      lineChart(
        dataInput(),
        name = input$ticker,
        up.col = "black",
        dn.col = "red",
        theme = "white",
        subset = "2019-01-01/"
      )
    } else if (input$type == "CandleStick") {
      candleChart(
        dataInput(),
        name = input$ticker,
        up.col = "black",
        dn.col = "red",
        theme = "white",
        subset = "2019-01-01/"
      )
    } else if (input$type == "Bar") {
      barChart(
        dataInput(),
        name = input$ticker,
        up.col = "black",
        dn.col = "red",
        theme = "white",
        subset = "2019-01-01/"
      )
    }
    else if (input$type == "MatchStick") {
      chartSeries(
        dataInput(),
        name = input$ticker,
        type = c("auto", "matchsticks"),
        subset = '2018-01::',
        show.grid = TRUE,
        major.ticks = 'auto',
        minor.ticks = TRUE,
        multi.col = TRUE
      )
    }
    Indicator()
  })
  
  #Tab Returns in main panel selections
  output$ReturnPlot <- renderPlot({
    
  
    returns <- dataInput()
    #Charts return of chosen symbol
    chart.Bar(returns, main = "Returns", colorset = (10), legend.loc = "bottomleft")
    
  })
  
  #Tab data set in main panel selections
  output$summary <- renderTable({
    dataset <- dataInput()
    #Returns a table of stock info (Open, High, Low, Close)
    (dataset)
  })
  
})