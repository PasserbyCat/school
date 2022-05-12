library(shiny)
library(plotly)
shinyServer(function(input,output){
  output$ui<-renderUI({
    inFile=input$file1
    if(is.null(inFile))
      return(NULL)
    data=read.table(inFile$datapath,header=T,sep=",")
    cname=colnames(data)
    list(
      selectInput("col","Select Column:",choices = cname[-1], 
      selected=cname[-1],multiple=T)#使用者可多選
    )
  })
  output$plot<-renderPlotly({
    inFile=input$file1
    if(is.null(inFile)) return(NULL)
    if(length(input$col)<1)  return(NULL)
    data=read.table(inFile$datapath,header=T,sep=",")
    ix = NULL
    for (i in 1:length(input$col)) {#此時input$col因為多選的緣故呈現vector
      ix[i] = which(colnames(data)==input$col[i])
    }
    p = plot_ly( x = data[,1], y = data[,ix[1]], name = input$col[1], type = "bar")
    if (length(input$col) == 2) {
      p = p %>% add_trace( y = data[,ix[2]], name = input$col[2]) %>%
      layout(yaxis = list(title = 'Count'), barmode = 'group')
    }
    p
  })
})
