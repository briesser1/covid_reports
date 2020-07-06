
#download and load data from data.world
library("data.world")
sql_stmt <- qry_sql("SELECT * FROM covid_19_activity")
df <- data.world::query(sql_stmt, "covid-19-data-resource-hub/covid-19-case-counts")
file_name <- "C:/Users/Riesser/Documents/covid_reports/data_world_download/COVID-19 Activity.csv"
write.csv(df, file = file_name)


library("data.world")
sql_stmt <- qry_sql("SELECT * FROM `3_covid_tracking_project_historical_testing_numbers_and_covid_deaths_by_state`")
df <- data.world::query(sql_stmt, "associatedpress/covid-tracking-project-testing-in-states")
file_name <- "C:/Users/Riesser/Documents/covid_reports/data_world_download/ap_by_county_testing.csv"
write.csv(df, file = file_name)

