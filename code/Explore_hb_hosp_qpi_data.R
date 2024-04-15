# Exploratory analysis of the QPI data 
# With specific aim of identifying QPIs whose targets have been changed 
# to check these have been annotated correctly. 

# Importing and exploring hb hosp qpi and associated background data. 

library(readxl)
library(dplyr) 
library(officer)  
# and flextable? 


# Get background data 
tbl_background_data_age_gender <- readxl::read_xlsx("/conf/quality_indicators/Benchmarking/Cancer QPIs/Data/new_process/testing/pw_hosp_data_exploration/input/Background_Data_Age_Gender.xlsx", 
                                             sheet = "Background_Data_Age_Gender")

summary(tbl_background_data_age_gender) 

unique(tbl_background_data_age_gender$Year_C)

tbl_background_data_age_gender |> count(Year_C)

# Get case ascertainment data 
tbl_background_data_case <- readxl::read_xlsx("/conf/quality_indicators/Benchmarking/Cancer QPIs/Data/new_process/testing/pw_hosp_data_exploration/input/Background_Data_Case.xlsx", 
                                       sheet = "Background_Data_Case")

summary(tbl_background_data_case)

# Get hb_hosp file from:  
# previously.. \Benchmarking\Cancer QPIs\Data\new_process\testing\test_bladder_24\excels_for_tableau\initial_run\input 
# readxl::read_xlsx to unmask (because of officer) 
# skip HB_comments column 
# set final column ie QPI_subtitle to text not numeric
tbl_hb_hosp_qpi <- readxl::read_xlsx("/conf/quality_indicators/Benchmarking/Cancer QPIs/Data/new_process/testing/pw_hosp_data_exploration/input/HB_Hosp_QPI.xlsx", 
                              sheet = "HB_Hosp_QPI", 
                              col_types = c("text", 
                                            "text", "text", "text", "text", "text", 
                                            "numeric", "numeric", "numeric", 
                                            "numeric", "numeric", "numeric", 
                                            "text", "text", "numeric", "text", 
                                            "text", "text", "numeric", "text", 
                                            "text", "text", "text", "text", "text", 
                                            "skip", "numeric", "text")
                              )



summary(tbl_hb_hosp_qpi)

tbl_targets <- tbl_hb_hosp_qpi |> 
  select(Cancer, Cyear, QPI_Label_Short,QPI,  Current_Target, Target_Label, Direction) |> 
  distinct()

tbl_changed_targets <- tbl_targets |> 
  mutate(change_in_target = "not yet compared") 

# Looks like the simple way to do this comparison is with a for loop 
# https://stackoverflow.com/questions/57742819/whats-a-tidyverse-approach-to-iterating-over-rows-in-a-data-frame-when-vectoris 
# Quick way - use excel

for (i in 1:nrow(tbl_changed_targets)) {
  tbl_changed_targets[i, "change_in_target"] = "still not yet compared"
}
