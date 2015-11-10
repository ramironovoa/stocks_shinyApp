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
                  value = 30)
    ),
    
    
    mainPanel(
      plotOutput('hist'),
      plotOutput('NormalProbPlot')
    )
  )
))
