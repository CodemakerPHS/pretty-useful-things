#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# RStudio Workbench is strictly for use by Public Health Scotland staff and     
# authorised users only, and is governed by the Acceptable Usage Policy https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_acceptable_use_policy.md.
#
# This is a shared resource and is hosted on a pay-as-you-go cloud computing
# platform.  Your usage will incur direct financial cost to Public Health
# Scotland.  As such, please ensure
#
#   1. that this session is appropriately sized with the minimum number of CPUs
#      and memory required for the size and scale of your analysis;
#   2. the code you write in this script is optimal and only writes out the
#      data required, nothing more.
#   3. you close this session when not in use; idle sessions still cost PHS
#      money!
#
# For further guidance, please see https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_best_practice_with_r.md.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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


