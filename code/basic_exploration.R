# basic exploratory steps
# For brand-new or large datasets
# Pauline Ward, January 2025

# Run all the usual steps to explore data, 
# for each variable in the imported tibble


library(tidyverse)
library(purrr) 
library(janitor)

source(exploration_functions.R)


# Specify the CSV filename
#input_data_filename <- "QPICervical_all_01oct2021_to_30sep2022.csv" # from live not test


input_file_location <- "../../input_data"
output_file_location <- "../../output"


# Call the function to import the file and generate a tibble from it, 
# allows R to guess the field types
# import the data
data_df <- import_file_now(input_data_filename, input_file_location)




summary(data_df)

# If none of the fields are continuous, summary() etc wd be pointless 
# so split them out
#continuous_data_df <- data_df |>
#  select()


# use purr to call the functions for each variable