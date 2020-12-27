library(readr)
library(tidyverse)
library(ggpubr)
library(covid19us)
library(geofacet)
library(gganimate)

#https://api.covidtracking.com/v1/states/daily.csv

us_pop <- 

daily <- get_states_daily()

df2 <- daily %>% 
  filter(state %in% c("SC")) %>% 
  select(date,
        state,
        positive,
        positive_tests_people_antigen,
        total_test_results,
         total_test_results_source,
         hospitalized_currently,
         on_ventilator_currently,
         death_confirmed,
         death_increase,
         total_tests_people_viral,
         recovered,
         in_icu_currently
  ) %>% 
  ggplot(aes(x = date, y = hospitalized_currently, color = state)) +
  geom_point() + 
  geom_line() + 
  facet_wrap(~ state) +
  scale_y_continuous(labels = scales::comma) +
  theme_pubclean() +
  theme(legend.position = "none") 
# transition_reveal(date, keep_last = FALSE)
  # facet_wrap(~ state  , scales = "fixed") + 


        # nframes = [...or pick it here])
df2 


# run by metric -----------------------------------------------------------

df3 <- daily %>%  
  filter(state %in% c("SC")) %>%  
  select(date,
         state,
         positive_increase,
         positive,
         total_test_results,
         hospitalized_currently,
         death_increase,
         in_icu_currently
  ) %>% 
  gather(metric, value, -date, -state) %>%  
  ggplot(aes(x = date, y = value, colour = state)) + 
          geom_line() + 
          facet_wrap(~ metric, scales = "free") +
  scale_y_continuous(labels = scales::comma) +
  theme_pubclean() 
# theme(legend.position = "bottom") + 
#   transition_reveal(date, keep_last = FALSE)

df3
  

# geo facet ---------------------------------------------------------------


df4 <- daily %>%  
  select(date, state, hospitalized_currently) %>% 
  filter(date > "2020-08-01") %>% 
  ggplot(aes(x = date, y = hospitalized_currently))  +
  geom_line() + 
  facet_geo(~ state) +
  theme_pubclean()  
df4
