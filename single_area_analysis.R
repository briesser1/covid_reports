library(tidyverse)
library(gt)
library(extrafont)
# load fonts - every session
loadfonts(device = "win", quiet = FALSE)

df1 <- read_csv("data_world_download/COVID-19 Activity.csv",
                col_types = cols(REPORT_DATE = col_date(format = "%Y-%m-%d"),
                                 COUNTY_NAME = col_character(), COUNTY_FIPS_NUMBER = col_character(),
                                 PEOPLE_POSITIVE_CASES_COUNT = col_number(),
                                 PEOPLE_POSITIVE_NEW_CASES_COUNT = col_number(),
                                 PEOPLE_DEATH_COUNT = col_number(),
                                 PEOPLE_DEATH_NEW_COUNT = col_number()))   %>% 
  select(Date = REPORT_DATE,
         Admin2 = COUNTY_NAME,
         Province_State = PROVINCE_STATE_NAME,
         Country_Region = COUNTRY_SHORT_NAME,
         country_code = COUNTRY_ALPHA_2_CODE,
         CONTINENT_NAME,
         Cases = PEOPLE_POSITIVE_CASES_COUNT,
         Difference = PEOPLE_POSITIVE_NEW_CASES_COUNT,
         Deaths = PEOPLE_DEATH_NEW_COUNT,
         Cumulative_Deaths = PEOPLE_DEATH_COUNT,
  ) 




df1 %>%  
  filter(country_code == "US") %>%
  filter(Date >= as.Date("2020-10-25")) %>%  
  group_by(Date) %>% 
  summarize(total = sum(Difference)) %>%  
  ggplot(aes(x = Date, y = total)) +
  geom_line()



df1 %>%  
  filter(country_code == "US") %>%
  # filter(Province_State == "New York") %>%  
  filter(Admin2 %in% c("Cook")) %>% 
  filter(Date >= as.Date("2020-02-01")) %>%  
  group_by(Date, Admin2) %>% 
  summarize(total = sum(Difference)) %>% 
  ggplot(aes(x = Date, y = total, color = Admin2)) + 
  geom_line()


df1 %>%  
  # filter(CONTINENT_NAME %in% c("America", "Europe", "Asia")) %>% 
  filter(country_code == "US") %>%
  filter(Province_State == "South Carolina") %>%
  filter(Admin2 %in% c("Greenville")) %>%
  # filter(Country_Region == "France") %>% 
  filter(Date >= as.Date("2020-02-01")) %>%  
  group_by(Date, Admin2) %>% 
  summarize(total = sum(Difference), total_deaths = sum(Deaths)) %>% 
  gather(metric, value, -Date, -Admin2) %>% 
  ggplot(aes(x = Date, y = value)) + 
  scale_y_continuous(limits = c(0, NA)) +
  geom_area(alpha = .25, fill  = "red") +
  stat_smooth(color = "black", se = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  facet_wrap(Admin2 ~metric, scales = "free", ncol = 2) + 
  theme_classic() + 
  theme(text=element_text(family="Poor Richard"))
 
# 
# report_state <- "South Carolina"
# report_counties  <- c("Greenville", "Richland", "Horry", "Spartenburg")
# #state level percentages
# pop_lookup <- read_rds(here::here("population_lookup.rds"))
# 
# cc <- read_csv("data_world_download/COVID-19 Activity.csv",
#                col_types = cols(REPORT_DATE = col_date(format = "%Y-%m-%d"),
#                                 COUNTY_NAME = col_character(), COUNTY_FIPS_NUMBER = col_character(),
#                                 PEOPLE_POSITIVE_CASES_COUNT = col_number(),
#                                 PEOPLE_POSITIVE_NEW_CASES_COUNT = col_number(),
#                                 PEOPLE_DEATH_COUNT = col_number(),
#                                 PEOPLE_DEATH_NEW_COUNT = col_number()))   %>% 
#   select(Date = REPORT_DATE,
#          Admin2 = COUNTY_NAME,
#          Province_State = PROVINCE_STATE_NAME,
#          Country_Region = COUNTRY_SHORT_NAME,
#          country_code = COUNTRY_ALPHA_2_CODE,
#          CONTINENT_NAME,
#          Cases = PEOPLE_POSITIVE_CASES_COUNT,
#          Difference = PEOPLE_POSITIVE_NEW_CASES_COUNT,
#          Deaths = PEOPLE_DEATH_NEW_COUNT,
#          Cumulative_Deaths = PEOPLE_DEATH_COUNT,
#   ) %>%
#   mutate(Combined_Key = paste(Admin2, Province_State, country_code, sep = ", ")) %>%  
#   filter(country_code == "US") %>% 
#   left_join(pop_lookup, by = "Combined_Key") %>% 
#   mutate(infection_Rate  = (Cases/Population_Count)*100000) 
# 
# cc_total <- cc %>%  
#   filter(Province_State == report_state) %>% 
#   group_by(Date) %>%  
#   summarize(T_difference = sum(Difference, na.rm = TRUE))
# 
# cc_population <-cc %>%  
#   filter(Province_State == report_state) %>%  
#   group_by(Date) %>%  
#   summarize(total_population = sum(Population_Count, na.rm = TRUE)) %>%  
#   distinct(total_population) %>%  
#   pull()
# 
# cc2 <- cc %>%  
#   filter(Province_State == report_state) %>%  
#   left_join(cc_total, by = "Date") %>% 
#   mutate(state_population = cc_population) %>%  
#   mutate(percentage_of_population = Population_Count/state_population) %>% 
#   mutate(percentage_of_cAdmin2ases = Difference / T_difference) %>%  
#   mutate(percentage_of_cases = ifelse(is.na(percentage_of_cases), 0, percentage_of_cases)) %>%  
#   mutate(counties_of_interest = ifelse(Admin2 %in% report_counties, 1,0))
# 
# 
# cc2 %>% 
#   filter(Admin2 == "Greenville") 
# 
# gplot(aes(x = Date,
#              y = percentage_of_cases)) +
#   geom_point(alpha = .25) + 
#   stat_smooth() +
#   geom_hline(yintercept = percentage_of_)
#   ylim(0,.5)
         