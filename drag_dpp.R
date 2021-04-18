## Example shiny app with bucket list

if (!require(pacman)) {
  install.packages("pacman")
}

pacman::p_load(shiny, stringr, dplyr, shinyjs, sortable, readr, ggplot2, tidyr)

options(shiny.maxRequestSize = 10000 * 1024^2)

ui <- fluidPage(
  tags$head(
    tags$style(HTML(" /* .bucket-list-container {min-height: 350px;} */"))
  ),
  fluidRow(
    column(
      tags$b("Advanced Filter Dashboard"),
      width = 12,

      fileInput("uploadfile", "Choose CSV File",
        multiple = FALSE,
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv"
        )
      )
    ), 
    
    column(
      width=2, 
      
      selectInput("variables",
                  label = "Select Variables",
                  choices = ""
      )
      
      
    ), 
    
    
    column(
      width=2,
    
      selectInput("operator",
                  label = "Select Operator",
                  choices = c(
                    "EQUAL (EQ)" = "==",
                    "Not Equal (NE)" = "!="
                  )
      )
      
    ),
    
    column(
      width=2,
      
      selectInput("values",
                  label = "Select Values",
                  choices = ""
      )
      
    ), 
    
    
    column(
      width=12,
      
      htmlOutput("bucketlist"),
      
      actionButton(
        "submitfilter",
        "submit filter"
      ),
      
      actionButton(
        "submitgroup",
        "submit group"
      ),
      
      actionButton(
        "cleargroup",
        "clear group"
      ),
      
      actionButton(
        "clearall",
        "clear all"
      ),
      
      actionButton(
        "submit",
        "submit"
      ),
      
      textOutput("text"),
      
      
      dataTableOutput("table")
    )
  )
  # 
  # ,
  # 
  # fluidRow(
  #   column(
  #     width = 12,
  #     tags$b("Result"),
  # 
  #     column(
  #       width = 12,
  # 
  #       tags$p("input$bucket_list_group"),
  #       verbatimTextOutput("results_3")
  #     )
  #   )
  # )
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


  observeEvent(input$variables,
    {
      updateSelectInput(session,
        inputId = "values",
        choices = sort(unique(df()[[input$variables]]))
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )

  output$results_3 <-
    renderPrint(
      input$bucket_list_group # Matches the group_name of the bucket list
    )


  # Output to filter options
  output$bucketlist <- renderUI({
    bucket_list(
      header = " ",
      group_name = "bucket_list_group",
      orientation = "horizontal",
      add_rank_list(
        text = "Filter Conditions",
        labels = unique(values$list),
        input_id = "filter_con"
      ),
      add_rank_list(
        text = "Logical",
        labels = c("&", "|", "!"),
        input_id = "logical"
      ),
      add_rank_list(
        text = "Grouping",
        labels = NULL,
        input_id = "grouping"
      )
    )
  })


  values <- reactiveValues(list = NULL)

  observeEvent(input$submitfilter,
    {
      req(df())

      if (input$submitfilter > 0) {
        values$list <- c(
          isolate(values$list),
          isolate(paste0(input$variables, input$operator, "'", input$values, "'"))
        )
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )

  observeEvent(input$submitgroup,
    {
      req(df(), input$grouping != "")
      if (input$submitgroup > 0) {
        values$list <- c(
          isolate(values$list),
          isolate(paste("(", paste0(input$grouping, collapse = ""), ")"))
        )
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )

  observeEvent(input$cleargroup,
    {
      req(df(), values$list != "")
      if (input$cleargroup > 0) {
        values$list <- values$list %>%
          purrr::map(~ purrr::discard(.x, ~ .x %in% input$grouping)) %>%
          purrr::compact()
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )

  observeEvent(input$clearall,
    {
      req(df(), values$list != "")
      if (input$clearall > 0) {
        values$list <- NULL
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )

  observeEvent(input$submit,
    {

      # output$text <- renderText({
      #   paste(cond, class(cond), input$grouping, class(input$grouping))
      # })

      data <- reactive({
        df() %>% filter(eval(parse(text = input$grouping)))
      })

      output$table <- renderDataTable(data())
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )
}


shinyApp(ui, server)
