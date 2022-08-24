
library(shiny)
library(dplyr)
library(readr)

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Sortable"),
                sidebarLayout(
                  sidebarPanel(
                    
                    
                    
                    
                    
                  ),
                  
                  # Output: Description, lineplot, and reference
                  mainPanel(
                
                    
                    )
                )
)

# Define server function
server <- function(input, output, session) {
  
  
}

# Create Shiny object
shinyApp(ui = ui, server = server)