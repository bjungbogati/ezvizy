## Example shiny app with bucket list

if (!require(pacman)) { install.packages("pacman") }
pacman::p_load(shiny, stringr, dplyr, shinyjs, sortable, readr, ggplot2, tidyr)

options(shiny.maxRequestSize = 10000 * 1024^2)

ui <- fluidPage(
  tags$head(
    tags$style(HTML(".bucket-list-container {min-height: 350px;}"))
  ),
  fluidRow(
    column(
      tags$b("Exercise"),
      width = 12,
      
      selectInput("variables", 
                  label = "Select Variables", 
                  choices = c("1", "2", "3", "6")),
      
      selectInput("operator",
                  label = "Select Operator",
                  choices = c("EQUAL (EQ)" = "==",
                              "Not Equal (NE)" = "!="
                  )
      ),
      
      selectInput("values", 
                  label = "Select Values", 
                  choices = c("one", "two", "three", "five")
                  
      ), 
      
      actionButton("submitfilter", 
                   "submit filter"),
      
      actionButton("submitgroup", 
                   "submit group"),
      
      actionButton("cleargroup", 
                   "clear group"),
      
      actionButton("clearall", 
                   "clear all"),
      
      htmlOutput("bucketlist")
      
    )
  ),
  fluidRow(
    column(
      width = 12,
      tags$b("Result"),
      
      column(
        width = 12,
        
        # tags$p("input$rank_list_1"),
        # verbatimTextOutput("results_1"),
        # 
        # tags$p("input$rank_list_2"),
        # verbatimTextOutput("results_2"),
        
        tags$p("input$bucket_list_group"),
        verbatimTextOutput("results_3")
      )
    )
  )
)

server <- function(input,output, session) {
  
  output$results_3 <-
    renderPrint(
      input$bucket_list_group # Matches the group_name of the bucket list
    )
  
  # Output to filter options
  output$bucketlist <- renderUI({
    bucket_list(   
      header = "Drag and drop seleted rows to the correct location",
      group_name = "bucket_list_group",
      orientation = "horizontal",
      add_rank_list(text = "Filter Conditions",
                    labels = unique(values$list),
                    # paste0(input$variables, input$operator, "'", input$values, "'")
                    # labels = str_glue("{var}{opr}'{val}'", var = input$variables, opr = input$operator, val = input$values),
                    input_id = "filter_con"),
      add_rank_list(text = "Logical",
                    labels = c("&", "|", "!"),
                    input_id = "logical"),
      add_rank_list(text = "Grouping",
                    labels = NULL,
                    input_id = "grouping")
    )
    
  })
  
  values <- reactiveValues(df = data.frame(filter_criteria = ""))
  
  observeEvent(input$submitfilter, {
    
    if(input$submitfilter > 0){
      values$df$filter_criteria <- c(isolate(values$list), 
                       isolate(paste0(input$variables, input$operator, "'", input$values, "'")))
    }
    
  })
  
  # observeEvent(input$filter_con, {
  #   values$list <- input$filter_con
  # })
  
  observeEvent(input$submitgroup, {
    
    if(input$submitgroup > 0){
      values$list <- c(isolate(values$list), 
                       isolate(paste(input$grouping, collapse="")))
    }
    
    
  })
  
  observeEvent(input$cleargroup, {
    
    if(input$cleargroup > 0){
      
      
      
    }
    
    
  })
  
  observeEvent(input$clearall, {
    
    if(input$clearall > 0){
      # updateTextInput(session, "grouping", value = "new")
      
      values$group <- NULL
      values$list <- NULL
    }
  })
  
  
  
}


shinyApp(ui, server)