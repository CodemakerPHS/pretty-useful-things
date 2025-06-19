# Functions for exploratory data analysis EDA

# Pauline Ward, January 2025

library(tidyverse)
library(here)
library(openxlsx)
library(janitor)

import_work_file <- function() {
  # Read in the list of data files, and filter to those we want to process
  current_work <- readWorkbook(here("housekeeping", "work_list.xlsx")) 
  current_work <- current_work |>
    filter(str_starts(str_to_lower(status), "ok"))
  
  return(current_work)
}


# import eCASE CSV or Excel file 
import_ecase_xl_or_csv <- function(filenm, file_locn) {
  
  # using here() for reusability
  input_file_path <- here(file_locn, filenm)
  
  # Although it'd be good practice in validation, won't specify the data type of all fields, 
  # as there are too many. 
  
  # There are warnings about column names and parsers because different tumour types 
  # have some different columns, so switch off warnings. 
  
  if (str_detect(filenm, ".xlsx$")) {
    imported_data_df <- readWorkbook(input_file_path)
  } else { 
    
    suppressWarnings(
      imported_data_df <- read_csv(input_file_path, 
        col_types = cols(ID = col_character(), 
          DOB = col_date(format = "%d/%m/%Y"), 
          PATPCODE = col_character(), 
          SEX = col_character(), 
          CHINUM = col_character(), 
          REFERDATE = col_date(format = "%d/%m/%Y"), 
          MREFER = col_character(), 
          HOSP = col_character(), # location of diagnosis
          DIAGDATE = col_date(format = "%d/%m/%Y"), 
          MRI = col_character(), 
          MRIDATE = col_date(format = "%d/%m/%Y"), 
          PETSCAN = col_date(format = "%d/%m/%Y"), 
          PSTATUS = col_character(), 
          MDTDATE = col_date(format = "%d/%m/%Y"), 
          COVID = col_character(), 
          FIRSTTREATMODE = col_character(), 
          FIRSTTREATDATE = col_date(format = "%d/%m/%Y"), 
          DEFTREATDATE = col_date(format = "%d/%m/%Y"), 
          HOSPSURG = col_character(), # hospital code, 'X1010' missing?
          SURGDATE = col_date(format = "%d/%m/%Y"), 
          SURG = col_character(), 
          MORPHOL = col_character(),
          FIGO = col_character(), # stage / '99'
          MARGIN = col_character(), 
          HOSPRADIO = col_character(), # a hospital code eg S116H
          RADIOTYPE = col_character(), 
          RSTARTDATE = col_date(format = "%d/%m/%Y"), 
          RCOMPDATE = col_date(format = "%d/%m/%Y"), 
          BRACHY = col_character(), 
          HOSPSACT = col_character(),
          CHEMTYPE1 = col_character(), 
          CHEMTYPE2 = col_character(), 
          CHEMDATE1 = col_date(format = "%d/%m/%Y"), 
          CHEMDATE2 = col_date(format = "%d/%m/%Y"), 
          CHEMENDATE1 = col_date(format = "%d/%m/%Y"), 
          CHEMENDATE2 = col_date(format = "%d/%m/%Y"), 
          TRIAL = col_character(),
          DOD = col_date(format = "%d/%m/%Y"), 
          Referral_Created_Location = col_character(), # a hosp code, not in definitions document
          Notes = col_character(), # Not listed in official definitions table
          # Columns added for bladder
          SITE = col_character(), # "Can be C67.x"
          DIVERT = col_character(),
          HISTDATE = col_date(format = "%d/%m/%Y"), 
          CT = col_character(), # TNM classification T, N and M
          CN = col_character(), 
          CM = col_character(), 
          MIBCDIAGDATE = col_date(format = "%d/%m/%Y"), 
          HOSPTURB1 = col_character(),
          HOSPTURB2 = col_character(),
          TURBINTENT1 = col_character(),
          TURBINTENT2 = col_character(),
          TURBT1 = col_character(),
          TURBT2 = col_character(),
          pTTURBT = col_character(),  # alphanumeric
          pTTURBT2 = col_character(), # alphanumeric
          TURBTDATE1 = col_date(format = "%d/%m/%Y"), 
          TURBTDATE2 = col_date(format = "%d/%m/%Y"), 
          DEMUSC1 = col_character(),
          DEMUSC2 = col_character(),
          BDIAG1 = col_character(),
          BDIAG2 = col_character(),
          CTSIZE1 = col_character(),
          CTSIZE2 = col_character(),
          MULTIPLE1 = col_character(),
          MULTIPLE2 = col_character(), 
          INTRAVDATE1 = col_date(format = "%d/%m/%Y"), 
          INTRAVDATE2 = col_date(format = "%d/%m/%Y"), 
          CYSTDATE = col_date(format = "%d/%m/%Y"), 
          OPROCDATE = col_date(format = "%d/%m/%Y"), 
          ONCDATE = col_date(format = "%d/%m/%Y"), 
          RADDATE1 = col_date(format = "%d/%m/%Y"), 
          RADDATE2 = col_date(format = "%d/%m/%Y"), 
          RADDATE3 = col_date(format = "%d/%m/%Y"), 
          RCOMPDATE1 = col_date(format = "%d/%m/%Y"), 
          RCOMPDATE2 = col_date(format = "%d/%m/%Y"), 
          RCOMPDATE3 = col_date(format = "%d/%m/%Y"), 
          CHEMDATE1 = col_date(format = "%d/%m/%Y"), 
          CHEMDATE2 = col_date(format = "%d/%m/%Y"), 
          CHEMDATE3 = col_date(format = "%d/%m/%Y"), 
          CHEMENDATE1 = col_date(format = "%d/%m/%Y"), 
          CHEMENDATE2 = col_date(format = "%d/%m/%Y"), 
          CHEMENDATE3 = col_date(format = "%d/%m/%Y"), 
          CYSTODATE = col_date(format = "%d/%m/%Y"), 
          TURBTDATER = col_date(format = "%d/%m/%Y"), 
          # Error from cystopsurg2 etc, R guesses the wrong type, so force it to treat as a string here
          # Stores surgeon's GMC no. or missing value code
          PM = col_character(),
          CYSTOPSURG1 = col_character(),  
          CYSTOPSURG2 = col_character()
        )) 
    ) # suppress warnings
  }

  # Data protection: delete patient name columns, if they've not already been manually removed
  # Usually generates a warning, to be ignored.
  imported_data_df <-  within(imported_data_df, rm(PATFNAME))
  imported_data_df <-  within(imported_data_df, rm(PATSNAME))
  
  # convert field names to upper case
  colnames(imported_data_df) <- stri_trans_toupper(colnames(imported_data_df))
  
  # Get rid of erroneous space in the pT column heading 
  data_file_typo_lookup <- c(PT = "P T", PT = "P.T")
  imported_data_df <- imported_data_df |>
    rename(any_of(data_file_typo_lookup))
  
  return(imported_data_df)

}


# Read in the list of data files, and filter to those we want to process
build_data_one_tsg <- function(tum_type) {
  
  current_work <- import_work_file() |> 
    filter(str_detect(str_to_lower(tumour_type_or_TSG), tum_type)) |> 
    arrange(desc(year_of_diagnosis)) # ensure most recent year processed first
  
  input_data_files <- current_work$data_file 
  #  input_data_files
  
  ## Build data structure for multiple years 
  input_file_location <- "data"
  # Make a superstructure to contain a list of data tables, one for each year
  data_years <- list()
  
  # for each year dataset
  for (i in 1:nrow(current_work)){
    
    # initialise 
    one_tum_type_data_df <- data.table()
    # for each input file 
    this_year <-  current_work$year_of_diagnosis[i] 
    one_tum_type_data_df <- import_ecase_csv(input_data_files[i], input_file_location) 
    # add a column for year of diagnosis, to allow rules lookup
    one_tum_type_data_df <- one_tum_type_data_df |>
      mutate(qpi_diag_year = this_year)
    
    data_years[[this_year]] <- one_tum_type_data_df 
    
  }
  
  return(data_years)
}

