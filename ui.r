library(shiny)

shinyUI(fluidPage(
  titlePanel('Histogram Displayer'),
  sidebarLayout(
    sidebarPanel(
      selectInput("stocks", "Choose a stock:", 
                  choices = c("AAPL", "TSLA", "YHOO")),
      radioButtons("filetype", "Download Stock file:",
                   choices = c("csv", "tsv")),
      downloadButton('downloadData', 'Download'),
      
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 253,
                  value = 100)
    ),
    
    
    mainPanel(
      plotOutput('hist')
    )
  )
))
