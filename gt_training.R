library(tidyverse) 
library(gt)
cc %>% 
  filter(Admin2 == "Greenville") %>%  
  select(Date, Difference, Admin2, Province_State) %>% 
  filter(Date > "2020-10-21") %>% 
  select(Date, Difference) %>% 
  rename('Cases per Day' = Difference) %>% 
  gt() %>% 
  fmt_date(
    columns = vars(Date), 
    date_style = 6
  ) %>%  
  grand_summary_rows(
    columns = vars('Cases per Day'),
    fns = list(
      Total = ~sum(.)),
    formatter = fmt_number,
    use_seps = FALSE
  ) %>%  
  opt_table_font(
    font = list(google_font(name = "Zilla Slab"))
  )

cc %>% 
  filter(Admin2 == "Greenville") %>%  
  select(Date, Difference, Admin2, Province_State) %>% 
  filter(Date > "2020-10-21") %>%
  summarize(Difference = sum(Difference)) %>% 
  gt::gt_preview()
