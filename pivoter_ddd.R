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
      
      textInput(inputId = "namesto", label = "Names to"),
      
      textInput(inputId = "valuesto", label = "Values to"),
      
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
                        
                        # %>%
                        #   filter(country == "NP") %>%
                        #   arrange(desc(date)) %>%
                        #   pivot_longer(
                        #     cols = 5:9,
                        #     names_to = "stats",
                        #     values_to = "values"
                        #   ) %>%
                        #   filter(stats %in% c("min", "max", "median"))
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
  
  
  observeEvent(input$submit,
               {
                 # output$text <- renderText({
                 #   paste(cond, class(cond), input$grouping, class(input$grouping))
                 # })
                 
                 # data <- reactive({
                 #   df() %>% filter(eval(parse(text = input$grouping)))
                 # })
                 
                 # 
                 # spec <- df() %>% build_longer_spec(
                 #   cols = c(input$variables),
                 #   names_to = input$namesto,
                 #   values_to = input$valuesto
                 # )
                 
                 # spec <- df() %>% build_longer_spec(
                 #   eval(parse(text = paste0(input$grouping)))
                 # )
                 # 
                 
                 # spec2 <- tibble(
                 #   .name = input$namesto,
                 #   .value = input$valuesto,
                 #   variable = input$variables
                 # )
                 
                 data <- reactive({
                   df() %>% pivot_longer(cols = input$variables,
                                              names_to = input$namesto,
                                              values_to = input$valuesto)
                 })
                 
                 # data <- reactive({
                 #   df() %>% pivot_longer_(spec)
                 # })
                 
                 # data <- reactive({
                 #   df() %>% pivot_longer(cols =c(count,max,median,min,variance),names_to ='names',values_to ='values')
                 # })
                 
                 
                 
                 output$table <- renderDataTable(data())
               },
               ignoreNULL = TRUE,
               ignoreInit = FALSE
  )
}

shinyApp(ui, server)
