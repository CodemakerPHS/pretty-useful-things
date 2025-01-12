# My code for doing the work in the assignments in the Coursera specialisation 
# Stats with R for Public Health 
# Not using Markdown cos we're on the verge of installing Quart, shd be better I hope. 

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
# Probably better with summary()

# Produce descriptive statistics
summary(fruit_n_veg_df$bmi)

# Tabulation 
table(fruit_n_veg_df$smoking)
# Warning! table() (Base R) does not display nulls
fruit_n_veg_df$smoking
# ... so, to see nulls, you need to set an arg to not exclude nulls
table(fruit_n_veg_df$smoking, exclude = NULL)
# Plotting
hist(fruit_n_veg_df$age) 

# Create new, derived column
head(fruit_n_veg_df, 12)
fruit_n_veg_df$fruits_et_legumes <- fruit_n_veg_df$fruit + fruit_n_veg_df$veg
head(fruit_n_veg_df, 7)

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

# get_summary_continuous_varbl <- function(varbl_name, varbl_vector) {
#   
#   output_text <- c(varbl_name, ": ")
#  # output_text <- append(output_text, c("Min ", min(varbl_vector)))
#   
#   
#   return output_text
# }

unique(fruit_n_veg_df$exercise)
fruit_n_veg_df <- fruit_n_veg_df |>
  mutate(exercise = as_factor(exercise))


output_lines <- append(output_lines, summary(fruit_n_veg_df))

file_conn <- file(notes_output_filename)

write_lines(output_lines, 
            file_conn,
            sep ="\n",
            append = FALSE) 

table(fruit_n_veg_df$cancer, exclude = NULL)

# ifelse(test, yes, no)
# five_a_day becomes equal to ... if fruit&veg >= 5, 'yes', else 'no'
fruit_n_veg_df$five_a_day <- ifelse(fruit_n_veg_df$fruits_et_legumes >=5, "yes", "no" ) 
fruit_n_veg_df$five_a_day
table(fruit_n_veg_df$five_a_day)

hist(fruit_n_veg_df$fruits_et_legumes, # plot histogram of sum of fruit n veg daily consumption
     xlab = "Portions of fruit and vegetables inc broccoli",
     main = "Daily combined consumption of fruit inc kiwi and vegetables")

tutti_frutti_plot <- fruit_n_veg_df |>
  ggplot() + 
  geom_histogram(aes(x=fruits_et_legumes), binwidth = 1, fill = "#83BB26") # phs-green #83BB26
tutti_frutti_plot
# Course 3, logistic regression, uses CSV file with many variables, 
# diabetes data
