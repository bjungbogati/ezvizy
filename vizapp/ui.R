
header <- dashboardHeader(title = "Viz Tool")

title <- "EZVIZY"


ids1 <- c("submit filter", "submit group", "clear group", "clear all", "submit 1")


sidebar <- dashboardSidebar(
  shinyjs::useShinyjs(),
  sidebarMenu(
    id = "tabs",
    menuItem(
      startExpanded = T, "Upload", tabName = "upload", icon = icon("file"),
      column(
        width = 12,
        fileInput("uploadfile", "Choose CSV File",
          multiple = FALSE,
          accept = c(
            "text/csv",
            "text/comma-separated-values,text/plain",
            ".csv"
          )
        )
      )
    ),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
  )
)

body2 <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  tabItems(
    tabItem(
      tabName = "dashboard",
      tabsetPanel(
        id = "dashtabs",
        type = "tabs",
        
        tabPanel(
          "Viewer",
          dataTableOutput("view_table")
        ),
        
        tabPanel(
          "Filters",
          fluidRow(
            column(
              width = 2,
              selectInput("variables1",
                label = "Select Variables",
                choices = ""
              )
            ),
            column(
              width = 2,
              selectInput("operator",
                label = "Select Operator",
                choices = c(
                  "EQUAL (EQ)" = "==",
                  "Not Equal (NE)" = "!="
                )
              )
            ),
            column(
              width = 2,
              selectInput("values",
                label = "Select Values",
                choices = ""
              )
            ),
            column(
              width = 12,
              htmlOutput("bucketlist"),
              
              purrr::map(ids1, ~actionButton(gsub("\\s", "", .), tools::toTitleCase(.))),
              # 
              # 
              # actionButton(
              #   "submitfilter",
              #   "submit filter"
              # ),
              # actionButton(
              #   "submitgroup",
              #   "submit group"
              # ),
              # actionButton(
              #   "cleargroup",
              #   "clear group"
              # ),
              # actionButton(
              #   "clearall",
              #   "clear all"
              # ),
              # actionButton(
              #   "submit1",
              #   "submit"
              # ),
              textOutput("tabledt"),
              textOutput("text") # ,


              # dataTableOutput("table")
            )
          )
        ),
        tabPanel(
          "Pivoting",
          fluidRow(
            column(
              width = 12,
              selectInput("variables2",
                label = "Select Variables",
                choices = "",
                multiple = TRUE
              ),
              textInput(inputId = "namesto", label = "Names to"),
              textInput(inputId = "valuesto", label = "Values to"),
              actionButton(
                "submit2",
                "submit"
              ),
              dataTableOutput("table")
            )
          )
        ),
        tabPanel(
          "Plot",
          htmlOutput("bucketlist2"),
          plotOutput("plot")
        )
      )
    )
  )
)

ui <- function(req) {
  dashboardPage(title = title, header = header, sidebar = sidebar, body = body2, skin = "blue")
}

ui
