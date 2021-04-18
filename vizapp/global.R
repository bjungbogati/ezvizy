options(shiny.maxRequestSize = 10000 * 1024^2, 
        shiny.cache = cachem::cache_mem(max_size = 500e6), 
        # shiny.autoreload = TRUE,
        # shiny.autoreload.pattern = glob2rx(c("ui.R", "server.R")),
        shiny.autoreload.interval = 5000,
        Ncpus = 4
        )

if (!require(pacman)) {
  install.packages("pacman")
}

pacman::p_load(shiny, shinydashboard, DT, tidyr, dplyr, sortable, ggplot2)

shinyOptions()



