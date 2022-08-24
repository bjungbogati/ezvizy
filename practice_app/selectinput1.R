library(shiny)
library(ggplot2)
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select Diamonds"),
      
      selectInput("variables", 
                  label = "Choose a variable to display",
                  choices = names(diamonds)), 
      
      selectInput("values", 
                  label = "Choose a values to display",
                  choices = ""), 
      
    ),
    
    mainPanel(
      textOutput("selected_var"),
      textOutput("test")
    )
  )
)

server <- function(input, output) {
  # Create object for reactive values 
  
  
  
  rv <- reactiveValues(
    value_store = character()
  )
  # When input changes -> update
  observeEvent(input$variables, {
    output$selected_var <- renderText({ 
      paste(input$variables)
    
    })
  # rv$value_store <- input$variables
  # 

    updateSelectInput(inputId = "values", choices = unique(diamonds[[input$variables]]))  
    

    
    
    
    
    # output$test <- renderText({
    #   paste(rv$value_store) 
    # })
  })
}

shinyApp(ui = ui, server = server)