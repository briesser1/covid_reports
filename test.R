library(tidyverse)
df2 <- cc %>%
  filter(country_code %in% c("AT", "CA", "ES")) %>% 
  group_by(Date, country_code) %>%  
  summarize(daily = sum(Difference)) %>%  
  autoplot(daily)
                
              