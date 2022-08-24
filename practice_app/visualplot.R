## Example shiny app with bucket list

if (!require(pacman)) {
  install.packages("pacman")
}
pacman::p_load(shiny, stringr, dplyr, shinyjs, sortable, readr, ggplot2, tidyr)

options(shiny.maxRequestSize = 10000 * 1024^2)

ui <- fluidPage(
  tags$head(
    tags$style(HTML(".bucket-list-container {min-height: 350px;}"))
  ),
  fluidRow(
    column(
      tags$b("Advanced Pivoting Dashboard"),
      width = 12,
      
      fileInput("uploadfile", "Choose CSV File",
                multiple = FALSE,
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv"
                )
      ),
      
      selectizeInput("variables",
                     label = "Select Variables",
                     choices = "",
                     multiple = TRUE
      ),
      
      textInput(inputId = "title", label = "Title"),
      
      # textInput(inputId = "valuesto", label = "Values to"),
      
      actionButton(
        "submit",
        "submit"
      ),
      
      dataTableOutput("table")
      # ,textOutput("result")
    )
  )
)

server <- function(input, output, session) {
  
  
  df <- eventReactive(input$uploadfile,
                      {
                        req(input$uploadfile)
                        upfile <- input$uploadfile
                        readr::read_csv(upfile$datapath, skip = 4) %>%
                          janitor::clean_names()
                      },
                      ignoreNULL = TRUE,
                      ignoreInit = FALSE
  )
  
  
  observeEvent(c(input$uploadfile, df()),
               {
                 updateSelectInput(session,
                                   inputId = "variables",
                                   choices = sort(names(df()))
                 )
               },
               ignoreNULL = TRUE,
               ignoreInit = FALSE
  )
  
  
  
  
  
  
  
  
}

shinyApp(ui, server)
