library(readr)
library(tidyverse)
library(readxl)
library(zoo)
library(ggthemes)
library(extrafont)
library(patchwork)
library(kableExtra)


poly1 <- map_data("county") %>% 
  rename(Admin2 = subregion, Province_State = region)





pop_lookup <- read_rds(here::here("population_lookup.rds"))

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
  ) %>%
  mutate(Combined_Key = paste(Admin2, Province_State, country_code, sep = ", ")) %>%  
  left_join(pop_lookup, by = "Combined_Key") %>%
  filter(country_code == "US") %>% 
  mutate(Admin2 = str_to_lower(Admin2)) %>%
  mutate(Province_State = str_to_lower(Province_State)) %>%  
  left_join(poly1, by = c("Province_State" = "Province_State",
                          "Admin2" = "Admin2"))



ggplot() + geom_polygon(
  data = df1, 
  aes(
    x=long,
    y=lat,
    group=group
  ),
  color ="blue", 
  fill = "lightblue", 
  size = .1
)
