# Exploratory analysis of the QPI data 
# With specific aim of identifying QPIs whose targets have been changed 
# to check these have been annotated correctly. 

# Importing and exploring hb hosp qpi and associated background data. 

library(readxl)

# Get background data 
tbl_background_data_age_gender <- read_excel("/conf/quality_indicators/Benchmarking/Cancer QPIs/Data/new_process/testing/pw_hosp_data_exploration/input/Background_Data_Age_Gender.xlsx", 
                                             sheet = "Background_Data_Age_Gender")

summary(tbl_background_data_age_gender) 

unique(tbl_background_data_age_gender$Year_C)

# Get case ascertainment data 
tbl_background_data_case <- read_excel("/conf/quality_indicators/Benchmarking/Cancer QPIs/Data/new_process/testing/pw_hosp_data_exploration/input/Background_Data_Case.xlsx", 
                                       sheet = "Background_Data_Case")

summary(tbl_background_data_case)

# Get hb_hosp file from:  
# \Benchmarking\Cancer QPIs\Data\new_process\testing\test_bladder_24\excels_for_tableau\initial_run\input 

tbl_hb_hosp_qpi <- read_excel("/conf/quality_indicators/Benchmarking/Cancer QPIs/Data/new_process/testing/pw_hosp_data_exploration/input/HB_Hosp_QPI.xlsx", 
                              sheet = "HB_Hosp_QPI", col_types = c("text", 
                                                                   "text", "text", "text", "text", "text", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "text", "text", "numeric", "text", 
                                                                   "text", "text", "numeric", "text", 
                                                                   "text", "text", "text", "text", "text", 
                                                                   "skip", "numeric", "numeric"))

summary(tbl_hb_hosp_qpi)


