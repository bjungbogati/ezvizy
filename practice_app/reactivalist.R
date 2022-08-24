require(shiny)
runApp(list(
  ui=fluidPage(
    h1('Example')
    ,textInput('txt','','Text')
    ,actionButton('add','add')
    ,actionButton('remove', 'remove')
    ,verbatimTextOutput('list')
  )
  
  ,server=function(input,output,session) {
    myValues <- reactiveValues(dList = NULL)
    observeEvent(input$add, {
      if(input$add > 0){
        myValues$dList <- c(isolate(myValues$dList), isolate(input$txt))
      }
  
    })
    
    observeEvent(input$remove, {
    if(input$remove > 0){
      
      # myValues$dList <-  c(purrr::map_chr(myValues$dList, ~ purrr::discard(.x, ~ .x %in% "")))
    
      
      
      myValues$dList <-  stringi::stri_remove_empty_na(myValues$dList)
    
    }
    })
    
        
    output$list<-renderPrint({
      myValues$dList
    })
  }
  
))