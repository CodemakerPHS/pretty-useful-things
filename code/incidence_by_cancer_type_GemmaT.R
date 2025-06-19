# inc_by_cancer_type.R
# Incidence by cancer type using SMR06
# Original author: Gemma Turner
# Original date: 2025-05-05
# R version 4.4.2
#
# This script calculates tumour incidence (number, crude rate and EASR) in Scotland,
# for 2019-2022, by cancer type

### 1 - Housekeeping ----

# 1.1 - Load packages ----

library(odbc)
library(dplyr)
library(lubridate)

# 1.2 - Load data ----

conn <- suppressWarnings(dbConnect(
  odbc(),
  dsn = "SMRA",
  uid = .rs.askForPassword("What is your user ID?"),
  pwd = .rs.askForPassword("What is your LDAP password?")
))

smr06 <- as_tibble(dbGetQuery(conn, 
                              paste("SELECT TUMOUR_NO, ICD10S_CANCER_SITE,",
                                    "INCIDENCE_DATE, ENCR_INCIDENCE_DATE,",
                                    "DATE_OF_BIRTH, POSTCODE, SEX,",
                                    "GP_PRACTICE_CODE",
                                    "FROM ANALYSIS.SMR06_PI")))

### 2 - Analysis ----

# NOTE - one individual can have multiple primary tumour registrations.
# These might be multiple tumours of the same site, diagnosed on the same date;
# they could be tumours of different sites and/or tumours diagnosed on different dates.
# Unless requested otherwise, we typically calculate incidence based on number of
# tumours rather than number of individuals. It is possible to filter for only
# one tumour per person by using the PE_PATIENT_ID, but you have to consider
# whether you want to exclude all multiple tumours or e.g. only those on the same date/same site.
# All of the analysis shown below is based on tumour counts.


# 2.1 - Prepare dataset ----

data <- smr06 %>%
  janitor::clean_names() %>%
  
  # From 2019 onwards, 'ENCR_INCIDENCE_DATE' should be used. For pre-2019 tumours,
  # or if ENCR incidence date is missing, 'INCIDENCE_DATE' should be used
  # (these are different systems for determining the date that is chosen 
  # as the date of diagnosis)
  mutate(datediag = as.Date(case_when(
    (incidence_date < "2019-01-01" | is.na(encr_incidence_date)) ~ incidence_date, 
    (incidence_date >= "2019-01-01" & !(is.na(encr_incidence_date))) ~ encr_incidence_date))) %>%
  
  # Derive additional date variables
  mutate(diagyr = as.numeric(format(as.Date(datediag, format="%Y-%m-%d"),"%Y")),
         diagmo = as.numeric(format(as.Date(datediag, format="%Y-%m-%d"),"%m")),
         diagda = as.numeric(format(as.Date(datediag, format="%Y-%m-%d"),"%d")),
         biryr = as.numeric(format(as.Date(date_of_birth, format="%Y-%m-%d"),"%Y")),
         birmo = as.numeric(format(as.Date(date_of_birth, format="%Y-%m-%d"),"%m")),
         birda = as.numeric(format(as.Date(date_of_birth, format="%Y-%m-%d"),"%d"))) %>%
  
  # Age at diagnosis should be manually derived rather than using the age variable
  # in SMR06, as that is based on INCIDENCE_DATE which can vary from ENCR_INCIDENCE_DATE
  mutate(age = as.numeric(case_when(
    (diagmo < birmo | diagmo == birmo & diagda < birda) ~ diagyr - biryr - 1, 
    (diagmo >= birmo | diagmo == birmo & diagda >= birda) ~ diagyr - biryr))) %>%
  
  # Create 5-year age groups up to 90+
  mutate(agegp_und90 = as.numeric(case_when(
    (age >= 0 & age < 95) ~ floor(age / 5), age >= 95 ~ 18))) %>%
  mutate(agegp_und90_label = (case_when(
    agegp_und90 %in% 0 ~ "Under 5",
    agegp_und90 %in% 1 ~ "5-9",
    agegp_und90 %in% 2 ~ "10-14", 
    agegp_und90 %in% 3 ~ "15-19",
    agegp_und90 %in% 4 ~ "20-24",
    agegp_und90 %in% 5 ~ "25-29", 
    agegp_und90 %in% 6 ~ "30-34",
    agegp_und90 %in% 7 ~ "35-39",
    agegp_und90 %in% 8 ~ "40-44", 
    agegp_und90 %in% 9 ~ "45-49",
    agegp_und90 %in% 10 ~ "50-54",
    agegp_und90 %in% 11 ~ "55-59", 
    agegp_und90 %in% 12 ~ "60-64",
    agegp_und90 %in% 13 ~ "65-69",
    agegp_und90 %in% 14 ~ "70-74", 
    agegp_und90 %in% 15 ~ "75-79",
    agegp_und90 %in% 16 ~ "80-84",
    agegp_und90 %in% 17 ~ "85-89", 
    agegp_und90 %in% 18 ~ "90+",
    TRUE ~ "Not Known"))) %>%
  
  mutate(icd10_4char = substr(icd10s_cancer_site, 1, 3)) %>%
  # Filter out incorrect sex-site combinations
  filter(sex %in% c(1:2) & 
           !(sex == 2 & (icd10_4char %in% c("C60","C61","C62","C63","D29","D40") | 
                           icd10s_cancer_site %in% c("D074","D075","D076")) | 
               sex == 1 & (icd10_4char %in% c("C51","C52","C53","C54","C55",
                                              "C56", "C57","C58","D06","D25",
                                              "D26","D27","D28","D39") | 
                             icd10s_cancer_site %in% c("D070","D071","D072","D073")))) %>%
  # Define cancer types using ICD-10 codes
  mutate(cancer_type = case_when(icd10_4char %in% c(paste0("C0", 0:9),
                                                    paste0("C", c(10:14, 30:32))) ~ "Head and Neck",
                                 icd10_4char %in% c("C15") ~ "Oesophageal",
                                 icd10_4char %in% c("C16") ~ "Stomach",
                                 icd10_4char %in% c("C17") ~ "Small Intestine",
                                 icd10_4char %in% c(paste0("C", 18:20)) ~ "Colorectal",
                                 icd10_4char %in% c("C21") ~ "Anal",
                                 icd10_4char %in% c("C22") ~ "Liver and intrahepatic bile ducts",
                                 icd10_4char %in% c("C23") ~ "Gallbladder",
                                 icd10_4char %in% c("C25") ~ "Pancreatic",
                                 icd10_4char %in% c(paste0("C", 33:34)) ~ "Lung",
                                 icd10_4char %in% c("C37") ~ "Thymus",
                                 icd10_4char %in% c(paste0("C", c(40, 41, 47, 49))) ~ "Bone and connective tissue",
                                 icd10_4char %in% c("C43") ~ "Melanoma Skin",
                                 icd10_4char %in% c("C44") ~ "Non-Melanoma Skin",
                                 icd10_4char %in% c("C45") ~ "Mesothelioma",
                                 icd10_4char %in% c("C50") ~ "Breast",
                                 icd10_4char %in% c("C51") ~ "Vulval",
                                 icd10_4char %in% c("C52") ~ "Vaginal",
                                 icd10_4char %in% c("C53") ~ "Cervical",
                                 icd10_4char %in% c("C54") ~ "Endometrial",
                                 icd10_4char %in% c("C56") ~ "Ovarian",
                                 icd10_4char %in% c("C60") ~ "Penile",
                                 icd10_4char %in% c("C61") ~ "Prostate",
                                 icd10_4char %in% c("C62") ~ "Testicular",
                                 icd10_4char %in% c(paste0("C", 64:65)) ~ "Kidney",
                                 icd10_4char %in% c("C67") ~ "Bladder",
                                 icd10_4char %in% c("C69") ~ "Eye",
                                 (icd10_4char %in% c(paste0("C", c(70:72)))) |
                                   (icd10s_cancer_site %in% c(paste0("C", c(751:753)))) ~ "Brain and other CNS",
                                 icd10_4char %in% c("C73") ~ "Thyroid",
                                 icd10_4char %in% c("C74") ~ "Adrenal Gland",
                                 icd10_4char %in% c(paste0("C", 77:80)) ~ "Cancer of Unknown Primary",
                                 icd10_4char %in% c("C81") ~ "Hodgkin Lymphoma",
                                 icd10_4char %in% c(paste0("C", 82:86)) ~ "Non-hodgkin Lymphoma",
                                 icd10_4char %in% c("C90") ~ "Multiple myeloma and malignant plasma cell neoplasms",
                                 icd10_4char %in% c(paste0("C", 91:95)) ~ "Leukaemia",
                                 TRUE ~ NA)) %>%
  # Remove tumour registrations for non-defined cancer types
  filter(!is.na(cancer_type)) %>%
  # You can adapt the above to include other sites or to group cancers differently
  # - https://icd.who.int/browse10/2019/en is a useful tool to identify the
  # ICD-10 code for any given cancer. Some more specific cancer types may be
  # defined based on morphology which is a separate variable - none of these
  # are included here.
  # ICD-9 codes are used to define pre-1997 tumours but as you are interested
  # in recent years, this is not irrelevant.
  # If interested in a value for All Cancers (malignant neoplasms) combined,
  # you can create a dataframe with an overall group that includes ICD-10 C00-C96.
  
  # Filter for the years of interest. There are more recent data in SMR06
  # but we have only published incidence data up to end of 2022 (working towards
  # publishing 2023 data this year) so we would not share more recent data in an IR
  filter(diagyr %in% 2019:2022)

# Duplicate data to allow "Persons" values to be calculated
data_sex <- data %>%
  rbind(data %>% 
          mutate(sex = "3"))

# Duplicate data to allow "All ages" values to be calculated
data_sex_age <- data_sex %>%
  rbind(data_sex %>% 
          mutate(agegp_und90_label = "All ages",
                 agegp_und90 = 19))


# 2.2 - Prepare Scotland population data ----

pops <- readRDS("/conf/linkage/output/lookups/Unicode/Populations/Estimates/HB2019_pop_est_1981_2023.rds") %>%
  mutate(sex = as.character(sex)) %>%
  # Create 5-year age groups
  mutate(agegp_und90 = as.numeric(case_when(
    (age >= 0 & age < 95) ~ floor(age / 5), age >= 95 ~ 18))) %>%
  mutate(agegp_und90_label = case_when(
    agegp_und90 %in% 0 ~ "Under 5",
    agegp_und90 %in% 1 ~ "5-9",
    agegp_und90 %in% 2 ~ "10-14", 
    agegp_und90 %in% 3 ~ "15-19",
    agegp_und90 %in% 4 ~ "20-24",
    agegp_und90 %in% 5 ~ "25-29", 
    agegp_und90 %in% 6 ~ "30-34",
    agegp_und90 %in% 7 ~ "35-39",
    agegp_und90 %in% 8 ~ "40-44", 
    agegp_und90 %in% 9 ~ "45-49",
    agegp_und90 %in% 10 ~ "50-54",
    agegp_und90 %in% 11 ~ "55-59", 
    agegp_und90 %in% 12 ~ "60-64",
    agegp_und90 %in% 13 ~ "65-69",
    agegp_und90 %in% 14 ~ "70-74", 
    agegp_und90 %in% 15 ~ "75-79",
    agegp_und90 %in% 16 ~ "80-84",
    agegp_und90 %in% 17 ~ "85-89", 
    agegp_und90 %in% 18 ~ "90+",
    TRUE ~ "Not Known")) %>%
  group_by(year, sex, agegp_und90, agegp_und90_label) %>%
  # Calculate population totals for 5-year age groups
  summarise(pop = sum(pop))

# Add populations for "Persons"
pops_sex <- pops %>%
  rbind(pops %>%
          mutate(sex = "3") %>%
          group_by(year, sex, agegp_und90, agegp_und90_label) %>%
          summarise(pop = sum(pop)) %>%
          ungroup())

# Add populations for "All ages"
pops_sex_age <- pops_sex %>%
  rbind(pops_sex %>%
          mutate(agegp_und90 = 19,
                 agegp_und90_label = "All ages") %>%
          group_by(year, sex, agegp_und90, agegp_und90_label) %>%
          summarise(pop = sum(pop)) %>%
          ungroup())


# 2.3 - Prepare European standard population data ----

esp <- read.csv("https://www.opendata.nhs.scot/dataset/4dd86111-7326-48c4-8763-8cc4aa190c3e/resource/29ce4cda-a831-40f4-af24-636196e05c1a/download/european_standard_population_by_sex.csv")       %>%
  # Change value format to match our dataset
  mutate(sex = case_when(Sex == "Male" ~ "1",
                         Sex == "Female" ~ "2"),
         agegp_und90_label = gsub(" years", "", AgeGroup),
         agegp_und90_label = case_when(agegp_und90_label == "0-4" ~ "Under 5",
                                       agegp_und90_label == "90plus" ~ "90+",
                                       TRUE ~ agegp_und90_label)) %>%
  select(sex, agegp_und90_label, european_standard_pop = EuropeanStandardPopulation) %>%
  group_by(sex) %>%
  # Add the total population for each sex to allow EASR to be calculated
  mutate(european_standard_pop_total = sum(european_standard_pop))


# 2.4 - Calculate rates ----

# 2.4.1 - Count number of tumours by year, sex, age and cancer type ----

data_regs <- data_sex_age %>%
  count(diagyr, agegp_und90, agegp_und90_label, sex, cancer_type) %>%
  rename(regs = n)

# 2.4.2 - Calculate crude rate ----

rates_crude <- data_regs %>%
  # Combine with Scotland population data
  left_join(pops_sex_age, by = c("diagyr" = "year", "agegp_und90", "agegp_und90_label", "sex")) %>%
  # Crude rate = number of tumour regs divided by population * 100,000
  mutate(crude_rate = regs/pop*100000)

# 2.4.3 - Calculate EASR ----

rates_easr <- rates_crude %>%
  # Combine with European standard population data
  left_join(esp, by = c("agegp_und90_label", "sex")) %>%
  # Exclude "All ages" group as this is not relevant here
  filter(agegp_und90 != 19) %>%
  # EASR = European age-standardised rates, calculated as crude rate multiplied
  # by the EASR weight (standard population size) within each sex/age group then
  # sum age group values to give a single EASR for each sex and divide by
  # total ESP (which is 100,000 for each sex)
  mutate(easr = crude_rate * european_standard_pop) %>%
  group_by(diagyr, sex, cancer_type) %>%
  summarise(easr_final = sum(easr)/mean(european_standard_pop_total)) %>%
  ungroup() %>%
  arrange(diagyr, cancer_type) %>%
  # For sex standardisation, age-sex standardised Persons rate is calculated
  # as the average of the male and female EASR values
  mutate(easr_final = case_when(sex == "3" ~ 
                                  (lag(easr_final, 2) + lag(easr_final, 1))/2,
                                TRUE ~ easr_final))


# For sex-specific cancer types, only sex-specific values are relevant
