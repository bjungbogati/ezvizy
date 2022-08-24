library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Application title
  titlePanel("EZVIZY - Data Viz Tool"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput("uploadfile", "Choose CSV File",
        multiple = FALSE,
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv"
        )
      ), 
      
      selectInput(
        inputId = "city",
        label = "City",
        choices = ""
      ),
      
      selectInput(
        inputId = "specie",
        label = "Specie",
        choices = "pm25"
      ),
      
      selectInput(
        inputId = "xaxis",
        label = "xaxis",
        choices = ""
      ),
      
      selectInput(
        inputId = "yaxis",
        label = "xaxis",
        choices = ""
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
     
      
      tableOutput('contents'),
      
      plotOutput("plots")
    )
  )
))
