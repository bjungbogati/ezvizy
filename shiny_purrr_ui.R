library(shiny)
library(purrr)


dists <- c("save it", "save me")
ui <- fluidPage(
  ## Here both purrr::map and lapply work...
  # lapply(dists, function(x) actionButton(x, x)),
  purrr::map(dists, ~actionButton(gsub("\\s", "", .), tools::toTitleCase(.))),
  hr(),
  plotOutput("plot")
)

server <- function(input, output){
  v <- reactiveValues(data = NULL)
  
  ## But here, only lapply works. With purrr, only the last button 
  ## makes the plot.
  # lapply(dists, function(x) {
  #   observeEvent(input[[x]], {
  #     v$data <- do.call(x, list(100))
  #   })
  # })
  
  purrr::map(dists, function(x) {
    observeEvent(input[[x]], {
      v$data <- do.call(x, list(100))
    })
  })
  
  output$plot <- renderPlot({
    if (is.null(v$data)) return()
    hist(v$data)
  })
}

shinyApp(ui, server)