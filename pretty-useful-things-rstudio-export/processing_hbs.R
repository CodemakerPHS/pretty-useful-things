# A script for processing core information about Scottish Health Boards 
# inc population, HB names, hospitals, boundaries 
# in a re-useable way. 
# 

library(tidyverse)

# Get data 

# Maybe try using phsopendata::get_dataset()

# Get HB geographical codes and names from opendata.nhs just the CSV file 
# https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc/download/hb14_hb19.csv

hb_names_url <- "https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc/download/hb14_hb19.csv"
hb_names_tbl <- read_csv(hb_names_url)

# Get HB boundaries 
# from Scottish govt spatial data website https://spatialdata.gov.scot/geonetwork/srv/api/records/f12c3826-4b4b-40e6-bf4f-77b9ed01dc14
hb_bounds_url <- "https://maps.gov.scot/ATOM/shapefiles/SG_NHS_HealthBoards_2019.zip"
# As the above is a Shapefile, just store the url for now. 

# Get HB populations 
hb_popn_url <- "https://www.opendata.nhs.scot/dataset/7f010430-6ce1-4813-b25c-f7f335bdc4dc/resource/27a72cc8-d6d8-430c-8b4f-3109a9ceadb1/download/hb2019_pop_est_15072022.csv"
hb_popn_tbl <- read_csv(hb_popn_url)
