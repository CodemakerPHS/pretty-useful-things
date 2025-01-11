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

notes_output_filename <- "notes_EDA_fruit_consumption_data.txt"

output_lines <- c("Dataset comprises 66 observations of 9 variables. ", 
                 "This dataset uses integer for age, whereas we treat age as an ordinal categorical variable, using age groups.",
                 "Fields...: ")

# glimpse(fruit_n_veg_df)
# Glimpse produces too much output. 

output_lines <- append(output_lines, 
                       c("Age min ", min(fruit_n_veg_df$age), 
                             "Age max ", max(fruit_n_veg_df$age),
                          "Values for gender: ",  unique(fruit_n_veg_df$gender),  
                       "Exercise:", unique(fruit_n_veg_df$exercise)))

output_lines <- append(output_lines, 
                       c("Fruit, min and max",
                         min(fruit_n_veg_df$fruit), " ",
                         max(fruit_n_veg_df$fruit)
                         
                       )
  
)

output_lines <- append(output_lines, summary(fruit_n_veg_df))

file_conn <- file(notes_output_filename)

write_lines(output_lines, 
            file_conn,
            sep ="\n",
            append = FALSE)

# Course 3, logistic regression, uses CSV file with many variables, 
# diabetes data