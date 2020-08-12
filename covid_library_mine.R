library(COVID19)
library(tidyverse)
library(skimr)

cd_city_us <- covid19("US", level = 3)
states_df <- covid19("US", level = 2) 
states_df <- states_df %>%  ungroup()
skim(states_df)

names(cd_city_us)

df1 <- cd_city_us %>% 
    filter(administrative_area_level_2 == "South Carolina") %>% 
    filter(administrative_area_level_3 == "Greenville")
skim(df1)
View(names(df1))



states_df %>% 
  ggplot(aes(x = date, y = 	confirmed, colour = administrative_area_level_2)) +
  geom_line() + 
  theme(legend.position = "none")


states_df %>%  
  filter(date == max(date)) %>%  
  select(administrative_area_level_2, confirmed) %>%  
  top_n(5) %>% 
  ggplot(aes(x = administrative_area_level_2, y = confirmed)) + 
  geom_col()
