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
#file_conn <- file(notes_output_filename)
sink(notes_output_filename, append = FALSE)
print("Dataset comprises 66 observations of 9 variables. ")

# Adjust sink() to not overwrite the info already written to it. 
sink(notes_output_filename, append = TRUE)
print("This dataset uses integer for age, whereas we treat age as an ordinal categorical variable, using age groups.")
# glimpse(fruit_n_veg_df)

print("Minimum age: ")
min(fruit_n_veg_df$age)
print("Maximum age:")
max(fruit_n_veg_df$age)
print("Values for gender: ")
unique(fruit_n_veg_df$gender)
print("Exercise:")
unique(fruit_n_veg_df$exercise)
print("Fruit, min and max")
min(fruit_n_veg_df$fruit)
max(fruit_n_veg_df$veg)
print("Fruit, veg, sum of fruit and veg, more than 5?")

print("Smoking")
unique(fruit_n_veg_df$smoking)
print("BMI summary")
# not summarise(fruit_n_veg_df) just says tibble 1x0
# not glimpse(fruit_n_veg) too lengthy
summary(fruit_n_veg_df)



# Course 3, logistic regression, uses CSV file with many variables, 
# diabetes data