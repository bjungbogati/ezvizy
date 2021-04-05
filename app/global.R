options(shiny.maxRequestSize = 10000 * 1024^2)
options(shiny.host = '127.0.0.1')
options(shiny.port = 8888)
options(Ncpus = 4)
# option(shiny.autoreload.pattern = glob2rx("ui.R"))


if (!require(pacman)) { install.packages("pacman") }
pacman::p_load(shiny, dplyr, readr, ggplot2, tidyr)

