
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    df <- eventReactive(input$uploadfile, {
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
    })
    
    observeEvent(c(input$uploadfile, df()), {
        
        updateSelectInput(session, "city",
                          label = "Select City",
                          choices = unique(df()$city)
                          ,
                          selected = "Kathmandu"
        )
        
        updateSelectInput(session, "specie",
            
                          choices = unique(df()$specie)
                          ,
                          selected = "pm25"
        )
        
        
        updateSelectInput(session, "xaxis",
                          label = paste("Select X-axis Variable", length(names(df()))),
                          choices = names(df())
                          ,
                          selected = "date"
        )
        
        updateSelectInput(session, "yaxis",
                          label = paste("Select Y-axis Variable", length(names(df()))),
                          choices = names(df())
                          ,
                          selected = "values"
        )
    })
    
    
    viz_filter <- reactive({ 
        req(input$city, input$specie)
            df() %>%
            filter(city == input$city, specie == input$specie)
    })
    
    
    # output$contents <- renderTable({
    #     head(df())
    # })
    
    output$plots <- renderPlot({
  
        
        viz_filter() %>%
        ggplot(aes_string(x = input$xaxis, y = input$yaxis,  color = "stats")) +
        geom_line() +
        labs(x = "", y = "", title = "Air Quality Index (pm2.5)") +
        bbplot::bbc_style() +
        theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))
        
})
    
    session$onSessionEnded(stopApp)

})