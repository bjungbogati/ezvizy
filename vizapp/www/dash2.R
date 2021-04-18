library(shiny)
library(shinydashboard)
ui <- dashboardPage(
  dashboardHeader(title = "Dynamic sidebar"),
  dashboardSidebar(
    sidebarMenu(id="tabs",
                sidebarMenuOutput("menu")
    )
  ),
  dashboardBody(
    uiOutput("body")
  )
)
server <- function(input, output,session) {
  
  output$menu <- renderMenu({
    sidebarMenu(
      menuItem("Menu item1", tabName="m1", icon = icon("calendar"),selected = TRUE),
      menuItem("Menu item2", tabName="m2", icon = icon("database"))
    )
  })

  output$body <- renderUI({
    tabItems(
      tabItem(tabName = "m1", p("Menu content 1") ),
      tabItem(tabName = "m2", p("Menu content 2") )
    )
  })
}
shinyApp(ui, server)