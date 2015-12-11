# The shiny server file

library(shiny)
#These will load once per session. Change which we use via user input
APPL = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=AAPL&a=08&b=14&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",") #rename table.csv for any input csv file
TSLA = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=TSLA&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
YHOO = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=YHOO&a=08&b=15&c=2014&d=08&e=28&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
IBM_tick = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=IBM&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
GOOG = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=GOOG&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csvv"), header = TRUE, sep = ",")
FB = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=FB&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
LNKD = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=LNKD&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
MSFT = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=MSFT&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
CSCO = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=CSCO&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
MU = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=MU&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")


i <- 1

colu1 <- length(APPL$Close)

# Saves stock closing values

closeAPPL=c(APPL$Close)
closeTSLA=c(TSLA$Close)
closeYHOO=c(YHOO$Close)
closeIBM=c(IBM_tick$Close)
closeGOOG=c(GOOG$Close)
closeFB=c(FB$Close)
closeLNKD=c(LNKD$Close)
closeMSFT=c(MSFT$Close)
closeCSCO=c(CSCO$Close)
closeMU=c(MU$Close)


Apple <-c()
Tesla <-c()
Yahoo <-c()
IBM <- c()
Google <- c()
Facebook <- c()
Linkedin <- c()
Microsoft <- c()
Cisco <- c()
Micron <- c()


#value1 <- list()

for (i in 1:colu1){
  
  value1<- log(APPL$Close[i]/APPL$Close[i+1]) 
  Apple<- c(value1,Apple)
  
  value2<- log(TSLA$Close[i]/TSLA$Close[i+1]) 
  Tesla<- c(value2,Tesla)
  
  value3<- log(YHOO$Close[i]/YHOO$Close[i+1]) 
  Yahoo<- c(value3,Yahoo)
  
  value4<- log(IBM_tick$Close[i]/IBM_tick$Close[i+1]) 
  IBM<- c(value4,IBM)
  
  value5<- log(GOOG$Close[i]/GOOG$Close[i+1]) 
  Google<- c(value5,Google)
  
  value6<- log(FB$Close[i]/FB$Close[i+1]) 
  Facebook<- c(value6,Facebook)
  
  value7<- log(LNKD$Close[i]/LNKD$Close[i+1]) 
  Linkedin<- c(value7,Linkedin)
  
  value8<- log(MSFT$Close[i]/MSFT$Close[i+1]) 
  Microsoft<- c(value8,Microsoft)
  
  value9<- log(CSCO$Close[i]/CSCO$Close[i+1]) 
  Cisco<- c(value9,Cisco)
  
  value10<- log(MU$Close[i]/MU$Close[i+1]) 
  Micron<- c(value10,Micron)
  
  
}

shinyServer(function(input, output) {
  datasetInput <- reactive({
    switch(input$stocks,
           "AAPL" = Apple,
           "TSLA" = Tesla,
           "YHOO" = Yahoo,
           "IBM" = IBM,
           "GOOG" = Google,
           "FB" = Facebook,
           "LNKD" = Linkedin,
           "MSFT" = Microsoft,
           "CSCO" = Cisco,
           "MU" = Micron)
  })
  datasetInput_2 <- reactive({
    switch(input$compstock,
           "AAPL" = Apple,
           "TSLA" = Tesla,
           "YHOO" = Yahoo,
           "IBM" = IBM,
           "GOOG" = Google,
           "FB" = Facebook,
           "LNKD" = Linkedin,
           "MSFT" = Microsoft,
           "CSCO" = Cisco,
           "MU" = Micron)
  })
# A histogram of the log returns of the stock selected is superimposed by a normal curve as an output in the following function
  output$hist <- renderPlot({
    
    bins <- input$bins
    stock <- datasetInput()
    m<-mean(stock, na.rm=TRUE)
    std<-sqrt(var(stock, na.rm=TRUE))
    hist(stock, density=bins,breaks=bins, prob=TRUE,
         xlab="Log-Return Values", 
         ylab = "Frequencies",
         main=paste("Histogram of ",input$stocks))
    curve(dnorm(x, mean=m, sd=std), 
          col="darkblue", lwd=2, add=TRUE)

  })
  
  # The following function outputs the confidence interval about the mean for the selected confidence level and selected stock
  output$ConfidenceInterval<-renderPrint({
    
    stock <- datasetInput()
    alpha<-input$clevel/100
    z<-qnorm(1-alpha/2)
    sigma=sd(stock, na.rm=TRUE)
    xbar=mean(stock, na.rm=TRUE)
    n=colu1
    ME=(z*sigma/sqrt(n))
    UB<-(xbar+ME)
    LB<-(xbar-ME)
    paste("The confidence interval:[",LB,",",UB,"]")
    
  })
  
  # This function plots a Quantile-Quantile plot to help us infer if the data set is normally distributed
  output$NormalProbPlot <- renderPlot({ 
    stock <- datasetInput()
    period <- c()
    qqnorm(stock)
    
  })
  # Depending on the input, plots closing stock values as a function of dates for the last year 
  output$TrendPlot <- renderPlot({ 
  
    if (input$stocks == "AAPL") {
      close = closeAPPL
      days = c(APPL$Date)}
    else if (input$stocks == "TSLA"){
        
        close = closeTSLA
        days = c(TSLA$Date)
    }
    else if (input$stocks == "YHOO"){
      
      close = closeYHOO
      days = c(YHOO$Date)
    }
    else if (input$stocks == "IBM"){
      
      close = closeIBM
      days = c(IBM_tick$Date)
    }
    else if (input$stocks == "GOOG"){
      
      close = closeGOOG
      days = c(GOOG$Date)
    }
    else if (input$stocks == "FB"){
      
      close = closeFB
      days = c(FB$Date)
    }
    else if (input$stocks == "LNKD"){
      
      close = closeLNKD
      days = c(LNKD$Date)
    }
    else if (input$stocks == "MSFT"){
      
      close = closeMSFT
      days = c(MSFT$Date)
    }
    else if (input$stocks == "CSCO"){
      
      close = closeCSCO
      days = c(CSCO$Date)
    }
    else if (input$stocks == "MU"){
      
      close = closeMU
      days = c(MU$Date)
    }
    
    plot(days,close,type="l", main=input$stocks, xlab = "Time", ylab = "Closing Value",col='Green')
    
  })
  #Regression: stock v time
  timeResults <- reactive({
    stock <- datasetInput()
    time <- seq(1, length(stock), by = 1)
    lm(stock~time)
  })
  #regression summary
  output$timeStats <- renderTable({
    results <- summary(timeResults())
    data.frame(R2=results$r.squared,
               adj.R2=results$adj.r.squared,
               DOF.model=results$df[1],
               DOF.available=results$df[2],
               DOF.total=(results$df[2]-results$df[1]),
               f.value=round(results$fstatistic[1], digits=4),
               f.denom=results$fstatistic[2],
               f.numer=results$fstatistic[3],
               p=1-pf(results$fstatistic[1],
                      results$fstatistic[2],
                      results$fstatistic[3]))
  })
  # Show coefficients
  output$timeResults <- renderTable(summary(timeResults()))
  #scatter stock v time
  output$timeScatter <- renderPlot({
    stock <- datasetInput()
    time <- seq(1, length(stock), by = 1)
    plot(time, stock)
    abline(timeResults())
    })
  #Regression: stock1 v stock2
  compResults <- reactive({
    stock1 <- datasetInput()
    stock2 <- datasetInput_2()
    lm(stock1~stock2)
  })
  #regression summary
  output$compStats <- renderTable({
    results <- summary(compResults())
    data.frame(R2=results$r.squared,
               adj.R2=results$adj.r.squared,
               DOF.model=results$df[1],
               DOF.available=results$df[2],
               DOF.total=(results$df[2]-results$df[1]),
               f.value=round(results$fstatistic[1], digits=4),
               f.denom=results$fstatistic[2],
               f.numer=results$fstatistic[3],
               p=1-pf(results$fstatistic[1],
                      results$fstatistic[2],
                      results$fstatistic[3]))
  })
  # Show coefficients
  output$compResults <- renderTable(summary(compResults()))
  #scatter stock1 v stock2
  output$compScatter <- renderPlot({
    stock1 <- datasetInput()
    stock2 <- datasetInput_2()
    plot(stock1, stock2)
    abline(compResults())
  })
  
  # The following function is to assist the user in downloading the data set being analysed
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste(input$stocks, input$filetype, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      
      # Write to a file specified by the 'file' argument
      write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
    }
  )
})
