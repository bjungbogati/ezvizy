library(shiny)
library(shinyBS)

launch.browser = function(appUrl, browser.path='/opt/meetsidekick.com/sidekick/sidekick-browser') {
  system(sprintf('"%s" --disable-gpu --app="data:text/html,<html>
<head>
<title>Configuration</title>
</head>
<body>
<script>window.resizeTo(800,500);window.location=\'%s\';</script>
</body></html>"', browser.path, appUrl))
}

shinyApp(
  
  ui = fluidPage(
    fluidRow(
      br(),
      wellPanel(
        fluidRow(
          h4('User Information')
        ),
        fluidRow(
          column(4,
                 textInput('Name', 'Full Name', value = "")
          ),
          column(4,
                 numericInput('accNum', 'Account Number', value = "")
          ),
          column(4,
                 textInput('token', 'Account Token', value = "")
          )
        )
      )
    ),
    
    fluidRow(
      column(12,
             actionButton('save', 'Save')
      )
    ),
    bsTooltip(id = "accNum", title = "Enter Lending Club account number", 
              placement = "bottom", trigger = "hover")
    # tags$head(tags$style(type="text/css", "#accNum {width: 100px}"))
  ), 
  
  server = function(input, output, session) {
    session$onSessionEnded(function() {
      stopApp()
    })
    observe({
      if (input$save == 0)
        return()
      isolate({
        j<<-input$accNum
      })
    })
    
  },
  options = list(launch.browser=launch.browser)
)