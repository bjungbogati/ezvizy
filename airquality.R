# An AQI between 0 and 50 is good. A level of 51-100 is acceptable,
# but a few people who are sensitive to certain pollutants may have reactions. ..
# . When air quality reaches 151-200, it is considered unhealthy;

library(tidyverse)

# if (!exists("np_air_quality"))
# {
# 
# np_air_quality <-
#   vroom::vroom("https://aqicn.org/data-platform/covid19/report/22562-380f2227",
#     skip = 4
#   ) %>%
#   janitor::clean_names() %>%
#   filter(country == "NP") %>%
#   arrange(desc(date))
# }

np_air_quality <-
  vroom::vroom("waqi-covid19-airqualitydata-2020.csv",
               skip = 4
  ) %>%
  janitor::clean_names() %>%
  filter(country == "NP") %>%
  arrange(desc(date))



np_air_quality_cc <- np_air_quality %>%
  pivot_longer(
    cols =c(count,max,median,min,variance),
    names_to ='names',
    values_to ='values'
  )


spec <- df() %>% build_longer_spec(
  eval(parse(text =(input$grouping)))
)





np_air_quality_cc <- np_air_quality %>%
  pivot_longer(
    cols = c(min, max, median, variance),
    names_to = "stats",
    values_to = "values"
  ) %>%
  filter(stats %in% c("min", "max", "median"))

saveRDS(np_air_quality_cc, "np_air_quality_cc.rds")

ktm_air_quality <- np_air_quality_cc %>%
  filter(
    city == "Kathmandu", specie == "pm25"
  )

ktm_air_plot <- ktm_air_quality %>%
  ggplot(aes(x = date, y = values, color = stats)) +
  geom_line() +
  labs(x = "", y = "", title = "Air Quality Index of Kathmandu") +
  bbplot::bbc_style() +
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))


bbplot::finalise_plot(
  plot_name = ktm_air_plot,
  source = paste("Data: aciqn.org | ", Sys.Date(), " | Info: AQI above 150 is unhealthy."),
  save_filepath = "fileplot.png",
  width_pixels = 760,
  height_pixels = 400,
  logo_image_path = "nm-vertical-logo.png"
)


max_polluted_city <- np_air_quality_cc %>%
  filter(
    values > 150,
    date == Sys.Date(),
    specie == "pm25", stats == "median"
  ) %>%
  mutate(city = fct_reorder(city, values)) %>%
  ggplot(aes(x = city, y = values, fill = city)) +
  geom_col() +
  geom_hline(yintercept = 150, linetype = "dashed", color = "red") +
  coord_flip() +
  labs(x = "", y = "", title = "Air Quality Index in Major Cities (Avg. pm2.5)") +
  bbplot::bbc_style() +
  theme(legend.position = "none", plot.margin = unit(c(1, 1, 1, 1), "cm"))


bbplot::finalise_plot(
  plot_name = max_polluted_city,
  source = paste("Data: aciqn.org | ", Sys.Date(), " | Info: AQI above 150 is unhealthy."),
  save_filepath = "max_polluted_city.png",
  width_pixels = 760,
  height_pixels = 400,
  logo_image_path = "nm-vertical-logo.png"
)

np_plot <- np_air_quality_cc %>%
  filter(stats %in% c("min", "max", "median")) %>%
  ggplot(aes(x = date, y = values, color = stats)) +
  geom_line() +
  labs(x = "", y = "", title = "Air Quality Index of Nepal (pm25)") +
  bbplot::bbc_style() +
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))
