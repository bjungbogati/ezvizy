## Only run examples in interactive R sessions
  
  library(ggplot2)
  
  # single selection
  shinyApp(
    ui = fluidPage(
      varSelectInput("variable", "Variable:", diamonds),
      
      verbatimTextOutput("results_1"),
      
      plotOutput("data")
    ),
    server = function(input, output, session) {
             
      
      observeEvent(input$variable, {
        output$results_1 <-
          renderPrint(
            input$variable # This matches the input_id of variable
          )
        
      
        
        
        
      })
      
      
      output$results_1 <-
        renderPrint(
          input$rank_list_1 # This matches the input_id of the first rank list
        )
      # 
      # output$data <- renderPlot({
      #   ggplot(mtcars, aes(!!input$variable)) + geom_histogram()
      # })
    }
  )
  
#   
#   # multiple selections
#   if (FALSE) {
#     shinyApp(
#       ui = fluidPage(
#         varSelectInput("variables", "Variable:", mtcars, multiple = TRUE),
#         tableOutput("data")
#       ),
#       server = function(input, output) {
#         output$data <- renderTable({
#           if (length(input$variables) == 0) return(mtcars)
#           mtcars %>% dplyr::select(!!!input$variables)
#         }, rownames = TRUE)
#       }
#     )}
#   
# }