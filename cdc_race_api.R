library(httr)
library(jsonlite)
library(tidyverse)

res <- GET("https://data.cdc.gov/resource/pj7m-y5uh.json")
rawToChar(res$content)
data <- fromJSON(rawToChar(res$content))

us <- data %>%  
  filter(state == "United States") %>% 
  select(-data_as_of,
         -start_week, 
         -end_week,
         -footnote,
         -state) %>%  
  gather(metric, value, -indicator)
  


