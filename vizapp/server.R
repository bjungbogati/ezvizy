server <- function(input, output, session) {
  df <- reactive({
    req(input$uploadfile)
    upfile <- input$uploadfile
    vroom::vroom(upfile$datapath, skip = 4) %>%
      janitor::clean_names()
  }) %>%
    # bindCache(input$uploadfile, cache = cachem::cache_disk()) %>%
    bindEvent(input$uploadfile)


  output$view_table <- renderDataTable(datatable(df(),
    filter = "top",
    options = list(columnDefs = list(list(
      targets = c(1, 3), searchable = FALSE
    )))
  ))


  observeEvent(c(input$uploadfile, df()),
    {
      updateSelectInput(session,
        inputId = "variables1",
        choices = sort(names((df())))
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )


  observeEvent(input$variables1,
    {
      updateSelectInput(session,
        inputId = "values",
        choices = sort(unique(df()[[input$variables1]]))
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )

  # output$results_3 <-
  #   renderPrint(
  #     input$bucket_list_group # Matches the group_name of the bucket list
  #   )


  # Output to filter options
  output$bucketlist <- renderUI({
    bucket_list(
      header = " ",
      group_name = "bucket_list_group1",
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
          isolate(paste0(input$variables1, input$operator, "'", input$values, "'"))
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

  observeEvent(input$submit1,
    {
      data <- reactive({
        req(input$grouping)
        df() %>% filter(eval(parse(text = input$grouping)))
      }) %>%
        bindCache(input$grouping, cache = cachem::cache_disk())


      # output$tabledt <- renderText(input$variables2)

      output$table <- renderDataTable(datatable(data(),
        filter = "top",
        options = list(columnDefs = list(list(
          targets = c(1, 3), searchable = FALSE
        )))
      ))


      updateSelectInput(session,
        inputId = "variables2",
        choices = sort(names(data()))
      )

      updateTabsetPanel(session, "dashtabs",
        selected = "Pivoting"
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = FALSE
  )


  observeEvent(input$submit2,
    {

      # datap <- as.data.frame(datar$data)

      data2 <- reactive({
        df() %>%
          filter(eval(parse(text = input$grouping))) %>%
           pivot_longer(
            cols = input$variables2,
            names_to = input$namesto,
            values_to = input$valuesto
          )
      }) %>%
        bindCache(input$grouping, cache = cachem::cache_disk())


      # Sys.sleep(3)
      d <- reactiveValues(df = data2())

      output$table <- renderDataTable(datatable(d$df,
        filter = "top",
        options = list(columnDefs = list(list(
          targets = c(1, 3), searchable = FALSE
        )))
      ))


      # Output to filter options
      output$bucketlist2 <- renderUI({
        bucket_list(
          header = " ",
          group_name = "bucket_list_group2",
          orientation = "horizontal",
          add_rank_list(
            text = "Variables",
            labels = names(d$df),
            input_id = "variables3"
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
          ) #,
          # add_rank_list(
          #   text = "Size",
          #   labels = NULL,
          #   input_id = "size"
          # )
        )
      })


      updateTabsetPanel(session, "dashtabs",
        selected = "Plot"
      )


      output$plot <- renderPlot({
        req(input$xaxis, input$yaxis, input$color)

        # Plotting
        d$df %>%
          ggplot(aes_string(x = input$xaxis, y = input$yaxis, color = input$color)) +
          labs(x = "", y = "", title = "Air Quality Index of Kathmandu") +
          geom_line() +
          bbplot::bbc_style() +
          theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))
      }) %>%
        bindCache(input$xasix, input$yaxis, input$color, d$df, cache = cachem::cache_disk()) %>%
        bindEvent(input$xasix, input$yaxis, input$color, d$df)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )
}
