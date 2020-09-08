library(rmarkdown)
library(tidyverse)
library(readr)
library(tidyverse)
library(readxl)
library(zoo)
library(ggthemes)
library(extrafont)
library(kableExtra)

clu <- read_excel("county_looup.xlsx")

d_formated <- format(Sys.Date(), "%d%b%Y")

new_directory <- here::here("county_report", paste("Reports", d_formated, sep = ""))
dir.create(new_directory)



new_county_directory <- paste(new_directory, "/county_level_data", sep = "")
dir.create(new_county_directory)

new_state_directory <- paste(new_directory, "/state_level_data", sep = "")
dir.create(new_state_directory)

todays_date <- d_formated

# ++++++++++++++++++++++++++++++++++++++++++++++++++++
# this function take an html_file and outputs to pdf, 
# this was going to be used to change html report to pdfs for easier
# vieing on github
#no longer needed. 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++
# html_to_pdf <- function(html_file, pdf_file) {
#   cmd <- sprintf("pandoc %s -t latex -o %s", html_file, pdf_file)
#   system(cmd)
# }



##Loop 
# for (i in 1:nrow(clu)){
# 
#   file_name <- paste(clu$file_name[i],  "_county_report.html", sep = "")
# 
#   dir.create(here::here("county_report", new_directory))
# 
#   rmarkdown::render(input = "county_daily.Rmd",
#                     output_format =  "html_document",
#                     output_file = file_name,
#                     output_dir = new_county_directory)
# }


# us_states <- read_rds("us_states.rds")
# #Loop
# for (i in 1:nrow(us_states)){
#   file_name <- paste(us_states$Province_State[i],  "_state_report.html", sep = "")
# 
# 
#   rmarkdown::render(input = "state_daily.Rmd",
#                     output_format =  "html_document",
#                     output_file = file_name,
#                     output_dir = new_state_directory)
# }
  




#run country minning
 file_name2 <- paste("Other_Countries", todays_date, ".html", sep = "")

rmarkdown::render(input = "country_minning.Rmd",
                  output_format =  "html_document",
                  output_file = file_name2,
                  output_dir = new_directory)







#run country comparision
file_name3 <- paste("US_V_EU_", todays_date, ".html", sep = "")

rmarkdown::render(input = "country_daily.Rmd",
                  output_format =  "html_document",
                  output_file = file_name3,
                  output_dir = new_directory)




#run countries of interest
file_name4 <- paste("Select_Countys_", todays_date, ".html", sep = "")

rmarkdown::render(input = "by_county_html.Rmd",
                  output_format =  "html_document",
                  output_file = file_name4,
                  output_dir = new_directory)




#run country mpolitical analysis
file_name5 <- paste("political_analysis_", todays_date, ".html", sep = "")

rmarkdown::render(input = "political_analysis.Rmd",
                  output_format =  "html_document",
                  output_file = file_name5,
                  output_dir = new_directory)



#run country mpolitical analysis
file_name6 <- paste("data_minning_", todays_date, ".html", sep = "")

rmarkdown::render(input = "data_minning.Rmd",
                  output_format =  "html_document",
                  output_file = file_name6,
                  output_dir = new_directory)


#run greenville report to pdf
file_name7 <- "Greenville_Daily_pdf.pdf"
pdf_folder <- here::here("pdfs")

rmarkdown::render(input = "Greenville_Daily_pdf.Rmd",
                  output_format =  "pdf_document",
                  output_file = file_name7,
                  output_dir = pdf_folder)

#run u repo v us to pdf
file_name8 <- "US_V_EU.pdf"
pdf_folder <- here::here("pdfs")

rmarkdown::render(input = "US_V_EU.Rmd",
                  output_format =  "pdf_document",
                  output_file = file_name8,
                  output_dir = pdf_folder)





