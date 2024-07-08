# A script for processing core information about Scottish Health Boards 
# inc population, HB names, hospitals, boundaries 
# in a re-useable way. 
# What does the style guide say? 
# as per https://public-health-scotland.github.io/knowledge-base/docs/R


library(readr)
library(dplyr)
library(kableExtra)
library(stringr)
library(here)

# Code for Scotland among Health Board codes
Scotland_str <- "S92000003"

# Get data 

# Maybe try using phsopendata::get_dataset() 
# as per https://public-health-scotland.github.io/knowledge-base/docs/R?doc=Recommended%20R%20Packages.md

# ... and 
# https://github.com/Public-Health-Scotland/phsopendata 

# Get HB geographical codes and names from opendata.nhs just the CSV file 
# https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc/download/hb14_hb19.csv

hb_names_url <- "https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc/download/hb14_hb19.csv"
hb_names_tbl <- read_csv(hb_names_url)

# Get HB boundaries 
# from Scottish govt spatial data website https://spatialdata.gov.scot/geonetwork/srv/api/records/f12c3826-4b4b-40e6-bf4f-77b9ed01dc14
hb_bounds_url <- "https://maps.gov.scot/ATOM/shapefiles/SG_NHS_HealthBoards_2019.zip"
# As the above is a Shapefile, just store the url for now. 

# Get HB populations

# estimates for mid-year 2022, published June 2024
hb_popn_url <- "https://www.opendata.nhs.scot/dataset/7f010430-6ce1-4813-b25c-f7f335bdc4dc/resource/27a72cc8-d6d8-430c-8b4f-3109a9ceadb1/download/hb2019_pop_est_26032024.csv"

# old file, earlier year
# hb_popn_url <- "https://www.opendata.nhs.scot/dataset/7f010430-6ce1-4813-b25c-f7f335bdc4dc/resource/27a72cc8-d6d8-430c-8b4f-3109a9ceadb1/download/hb2019_pop_est_15072022.csv"
hb_popn_tbl <- read_csv(hb_popn_url) 
latest_year <- max(unique(hb_popn_tbl$Year))
hb_popn_tbl <- hb_popn_tbl |>
  left_join(hb_names_tbl, by = "HB")

hb_popn_tbl_latest <- hb_popn_tbl |> 
  select(Year, HBName, Sex, AllAges, HB) |> 
  filter(Year == latest_year) |> 
  filter(Sex == "All")
#  filter(HB != Scotland_str)

Scot_popn <- hb_popn_tbl_latest |> 
  filter(HB == Scotland_str) |> 
  select(AllAges)
Scot_popn <- Scot_popn$AllAges
  
kbl(hb_popn_tbl_latest)
sum_of_hb_popns <- sum(hb_popn_tbl_latest$AllAges) - Scot_popn
sum_of_hb_popns

hb_popn_tbl_latest <- hb_popn_tbl_latest |>
  mutate(Popn_as_a_percent_of_Scotland = AllAges / Scot_popn) |>
  select(HBName, Population = AllAges, Popn_as_a_percent_of_Scotland, Year, Sex, HB_code = HB)

  

# Write out CSV. NB gitignore will direct this file to not be uploaded
write_csv(hb_popn_tbl_latest, here("data", "health_board_populations.csv"))
