#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Working through HOPR - Hands-On Programming with R   
# Ch. 2
# https://rstudio-education.github.io/hopr/basics.html#objects
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

library(janitor) 
library(openxlsx)
library(tidyverse)

# 2.2 Objects 
# Even simple variables that you save are objects. 

a <- 3

die <- 1:6

die
die + 4
die * 5

die * die


# 2.3 Functions 

round_half_up(3.1415)

sample(x = 1:4399, size = 8)

args(round_half_up)
args(write.xlsx)
args(ggplot)
args(str_detect)
?round_half_up
?str_detect

# 2.4 Writing your own functions 

