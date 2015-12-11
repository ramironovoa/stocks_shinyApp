# The shiny UI file

library(shiny)

shinyUI(fluidPage(
  titlePanel('Histogram Displayer'),
  sidebarLayout(
    sidebarPanel(
      selectInput("stocks", "Choose a stock:", 
                  choices = c("AAPL", "TSLA", "YHOO","IBM","GOOG","FB","LNKD","MSFT","CSCO","MU")),
      radioButtons("filetype", "Download Stock file:",
                   choices = c("csv", "tsv")),
      downloadButton('downloadData', 'Download'),
      
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 100,
                  value = 30),
      
      sliderInput("clevel",
                  "Confidence Level(in %):",
                  min = 1,
                  max = 100,
                  value = 95),
      selectInput("compstock", "Choose a comparison:", 
                  choices = c("AAPL", "TSLA", "YHOO","IBM","GOOG","FB","LNKD","MSFT","CSCO","MU"))
    ),
    
    
    mainPanel(
      plotOutput('TrendPlot'),
      plotOutput('hist'),
      verbatimTextOutput('ConfidenceInterval'),
      plotOutput('NormalProbPlot'),
      plotOutput("timeScatter"),
      tableOutput("timeStats"),
      tableOutput("timeResults"),
      plotOutput("compScatter"),
      tableOutput("compStats"),
      tableOutput("compResults"),
      plotOutput("residualScatter")
    )
  )
))
