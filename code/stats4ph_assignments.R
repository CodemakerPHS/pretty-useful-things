# My code for doing the work in the assignments in the Coursera specialisation 
# Stats with R for Public Health 

library(tidyverse)

# Course 1, intro, uses CSV file with six variables, 
# consumption of FFFruit and veg in relation to health. 
fruit_n_veg_df <- read_csv("data/Fy76fg6oEemYdRIT0BhLtg_17af74a00ea811e9903947c521ebe81a_cancer-data-for-MOOC-1-_1_ .csv", 
         col_types = cols(patient_id = col_character(), 
                          age = col_integer(), gender = col_character(), 
                          smoking = col_character(), exercise = col_character(), 
                          cancer = col_character(), 
                          fruit = col_double(), veg = col_double()))

notes_output_filename <- "notes_EDA_fruit_consumption_data.md"
#file_conn <- file(notes_output_filename)
sink(notes_output_filename, append = FALSE)
print("Dataset comprises 66 observations of 9 variables. \n ")

# Course 3, logistic regression, uses CSV file with many variables, 
# diabetes data