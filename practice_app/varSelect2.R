library(shiny)
library(shinyWidgets)

ui <- fluidPage(
  tags$h2("Update pickerInput"),
  
  fluidRow(
    column(
      width = 5, offset = 1,
      pickerInput(
        inputId = "p1",
        label = "Starting Letters",
        choices = LETTERS
      )
    ),
    column(
      width = 5,
      pickerInput(
        inputId = "p2",
        label = "Names of Cars",
        choices = ""
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$p1, {
    updatePickerInput(inputId = "p2",
                      choices = grep(paste0("^",input$p1), rownames(mtcars), value = TRUE))
    
  }, ignoreInit = TRUE)
}


shinyApp(ui = ui, server = server)