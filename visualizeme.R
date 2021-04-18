## Example shiny app with bucket list

if (!require(pacman)) {
  install.packages("pacman")
}
pacman::p_load(shiny, stringr, dplyr, shinyjs, sortable, readr, ggplot2, tidyr)

options(shiny.maxRequestSize = 10000 * 1024^2)

ui <- fluidPage(
  tags$head(
    tags$style(HTML(".bucket-list-container {min-height: 350px;}
                    
.default-sortable.bucket-list.bucket-list-vertical .rank-list-container {
    display: block !important;
    flex: 1 0 auto !important;
}

.default-sortable .rank-list-title {
    flex: 0 0 auto  !important;
    float: right  !important;
    color: #c5c5c5 !important;
    font-weight: bold !important;
    font-size: 20px !important;
    margin: 0 10px !important;
}

.default-sortable .rank-list-item {
    border-radius: 5px !important;
    display: block !important;
    padding: 0px 10px !important;
    background-color: #f8f8f8 !important;
    border: 1px solid #ddd !important;
    overflow: hidden !important;
    width: auto !important;
    float: left !important;
    margin: 0 5px !important;
*}
                    
    .default-sortable.rank-list-container {
    background-color: transparent !important;
    border: 2px dashed #ddd !important;
    padding: 0px !important;
    margin: 5px !important;
    flex-flow: column nowrap !important;
}

 .default-sortable .rank-list.rank-list-empty {
    border-style: none !important;
 }                   

.column_2, .column_3, .column_4, .column_5 {
  width:250px;
}
    
                   "))
  ),
  fluidRow(
    column(
      tags$b("Advanced Vizualization"),
      width = 12,

      fileInput("uploadfile", "Choose CSV File",
        multiple = FALSE,
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv"
        )
      ),

      htmlOutput("bucketlist"),
      textOutput("text"),
      dataTableOutput("table"),
      plotOutput("plot")
    )
  ),

  fluidRow(
    column(
      width = 12,
      tags$b("Result"),

      column(
        width = 12,

        tags$p("input$bucket_list_group"),
        verbatimTextOutput("results_3")
      )
    )
  )
)

server <- function(input, output, session) {
  df <- eventReactive(input$uploadfile,
    {
      req(input$uploadfile)
      upfile <- input$uploadfile
      readr::read_csv(upfile$datapath, skip = 4) %>%
        janitor::clean_names() %>%
        filter(country == "NP") %>%
        arrange(desc(date)) %>%
        pivot_longer(
          cols = 5:9,
          names_to = "stats",
          values_to = "values"
        ) %>%
        filter(stats %in% c("min", "max", "median"))
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
        text = "Variables",
        labels = sort(names(df())),
        input_id = "variables"
      ),
      add_rank_list(
        text = "X-axis",
        labels = NULL,
        input_id = "xaxis"
      ),
      add_rank_list(
        text = "Y-axis",
        labels = NULL,
        input_id = "yaxis"
      ),
      add_rank_list(
        text = "Fill",
        labels = NULL,
        input_id = "fill"
      ),
      add_rank_list(
        text = "Color",
        labels = NULL,
        input_id = "color"
      )
      # ,
      # add_rank_list(
      #   text = "Size",
      #   labels = NULL,
      #   input_id = "size"
      # )
    )
  })


  output$plot <- renderPlot({
    req(input$xaxis)

    # Plotting

    plot <- df() %>%
      filter(
        city == "Kathmandu", specie == "pm25"
      ) %>%
      ggplot(aes_string(x = input$xaxis, y = input$yaxis, color = input$color)) +
      labs(x = "", y = "", title = "Air Quality Index of Kathmandu")

    plot +
      geom_line()
  })
}


shinyApp(ui, server)
