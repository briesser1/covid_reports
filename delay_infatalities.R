library(readr)
library(tidyverse)
library(readxl)
library(zoo)
library(ggthemes)
library(extrafont)
library(pander)


pop_lookup <- read_rds(here::here("population_lookup.rds"))
tspan <-  60 
fdate <- Sys.Date() - tspan
font_family1 = "Book Antiqua"
font_color = "#011140"


#position of legend. 
legend_position = c("2020-05-15", 3000)


#load data set downloaded from Data world
cc <- read_csv("data_world_download/COVID-19 Activity.csv",
               col_types = cols(REPORT_DATE = col_date(format ="%Y-%m-%d"),
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
  filter(country_code == "US") %>% 
  mutate(Combined_Key = paste(Admin2, Province_State, country_code, sep = ", ")) %>%  
  left_join(pop_lookup, by = "Combined_Key") %>% 
  mutate(infection_Rate = (Cases/Population_Count)*100000) 

first_case <- cc %>%  
  arrange(Province_State, Admin2, Date) %>%  
  select(Date, Province_State, Admin2, Cases) %>%  
  mutate(test = ifelse(Cases == 0 & lead(Cases) > 0, 
                       "First", "Neg")) %>%  
  filter(test == "First") %>%  
  select(Province_State, Admin2, First_case = Date)


df1 <- cc %>% 
  arrange(Province_State, Admin2, Date) %>%  
  select(Date, Admin2, Province_State, Difference, Deaths) %>%  
  left_join(first_case, by = c("Admin2" = "Admin2", "Province_State" = "Province_State")) %>%  
  filter(Date > First_case) %>%  
  select(-First_case) %>%  
  mutate(Difference = ifelse(Difference < 0, 0, Difference)) %>% 
  mutate(Deaths = ifelse(Deaths < 0, 0, Deaths)) %>%  
  mutate(location_key = paste(Province_State, Admin2, sep = "_")) %>%  
  select(-Admin2, -Province_State) %>%  
  mutate(Date = unclass(Date)) %>%  
  group_by(location_key) %>%  
  mutate(Date = (Date - min(Date)) +1 ) %>% 
  ungroup() %>% 
  mutate(R1 = (Difference +
           lag(Difference) +
           lag(Difference, n = 2) +
           lag(Difference, n = 3) +
           lag(Difference, n = 4) +
           lag(Difference, n = 5) +
           lag(Difference, n = 6) +
           lag(Difference, n = 7))/7) %>% 
  mutate(R1 = ifelse(location_key == lag(location_key, n = 7),
                     R1,
                     NA))  %>% 
  mutate(R2 = (Deaths +
                 lag(Deaths) +
                 lag(Deaths, n = 2) +
                 lag(Deaths, n = 3) +
                 lag(Deaths, n = 4) +
                 lag(Deaths, n = 5) +
                 lag(Deaths, n = 6) +
                 lag(Deaths, n = 7))/7) %>% 
  mutate(R2 = ifelse(location_key == lag(location_key, n = 7),
                     R2,
                     NA))


location_key_lookup <- df1 %>%  
  distinct(location_key)

delay_in_days <- c(7:90)

days <- c(min(df1$Date)+16:max(df1$Date))

search_grid <- expand.grid(location = location_key_lookup$location_key, day = days,  dd = delay_in_days)
search_grid <- tibble::rownames_to_column(search_grid, "VALUE") %>% 
  mutate(test = day - dd) %>% 
  filter(test > 0) %>% 
  select(-test)




sample1 <- sample(search_grid$VALUE, 500)
temp1 <- search_grid %>%  
  filter(VALUE %in% sample1)

list_1 <- vector("list",length(temp1$VALUE))
list_2 <- vector("list",length(temp1$VALUE)) 

# library(magicfor)
# magic_for(print, silent=TRUE)

for(i in 1:length(temp1$VALUE)){
  x1 <- df1 %>%  
    filter(location_key == temp1$location[i]) %>%  
    mutate(R3 = lag(R2, n = temp1$dd[i])) %>%  
    filter(Date == temp1$day[i]) %>% 
    mutate(x1 = R3/R1) %>%  
    select(x1) %>%  
    pull()
  print(x1)

  list_1[[i]] <- x1
  list_2[[i]] <- temp1$dd[i]
}  

# magic_result_as_dataframe()

list_1_df <- unlist(list_1)
 list_2 <- unlist(list_2)
df2 <- data.frame(list_1, list_2)
names(df2 <- c("result", "delay_day"))
