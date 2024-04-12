# Exploring cancer data 
# Pauline's data exploration cheat-sheet 

# Cervical screening stats from https://www.opendata.nhs.scot/dataset/scottish-cervical-screening-programme-statistics

library(readr)


cervical_screening_data_url <- "https://www.opendata.nhs.scot/dataset/874b6f70-8640-458a-81cb-83afde9ffd71/resource/7191190e-2ebd-47e4-bbca-a1eb3182408a/download/open-data-cervical-screening-uptake-201617-202122.csv" 

tbl_cerv_scrng <- read_csv(cervical_screening_data_url)



