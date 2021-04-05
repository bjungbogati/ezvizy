library(shiny)
# options(shiny.host = '0.0.0.0')
# options(shiny.port = 8888)
# 
# runApp('app')

# launch.browser = function(appUrl, browser.path='/usr/bin/google-chrome') {
#   system(sprintf('"%s" --disable-gpu --app="data:text/html,<html>
# <head>
# <title>Configuration</title>
# </head>
# <body>
# <script>window.resizeTo(800,500);window.location=\'%s\';</script>
# </body></html>"', browser.path, appUrl))
# }

launch.browser = function(appUrl, browser.path='/usr/bin/google-chrome') {
  system(sprintf('"%s" --no-sandbox --disable-gpu --disable-extensions --app="data:text/html,<html>
  <head>
    <title>System Configuration</title>
  </head>
  <body>
    <script>window.resizeTo(830,675);window.location=\'%s\';</script>
  </body></html>"', browser.path, appUrl), wait=FALSE)
}


runApp('/home/bjungbogati/R/learning/ezvizy/app', host="0.0.0.0",port=1080, launch.browser=launch.browser)















# https://stackoverflow.com/questions/42421798/run-shiny-app-from-shortcut-windows-10

# R -e "shiny::runApp('/home/bjungbogati/R/learning/ezvizy/app', launch.browser=T)"

# "path/to/R.exe" -e "shiny::runApp('path/to/shinyAppFolder', launch.browser = TRUE)"
# 
# "path/to/R.exe" -e "path/to/run.R"
