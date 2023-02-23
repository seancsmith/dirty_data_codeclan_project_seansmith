# Task 6 - Cleaning Script

library(tidyverse)
library(janitor)

# Read in the data
dog_survey <- read_csv("data/raw_data/dog_survey.csv")
view(dog_survey)

# Remove empty columns
dog_survey_select <- dog_survey %>% 
  select(-...10, -...11) %>% 
  clean_names()

# Change types to numeric
dog_age_numeric <- dog_survey_select %>% 
  mutate(dog_age = as.numeric(dog_age))

dog_survey_spend_on_food <- dog_age_numeric %>% 
  rename("spend_on_food" = amount_spent_on_dog_food) %>% 
  mutate(spend_on_food = str_remove_all(spend_on_food, "£"),
         spend_on_food = as.numeric(spend_on_food))


# Remove duplicated data in dataframe
dog_survey_remove_dupes <- dog_survey_spend_on_food %>% 
  mutate(dog_dupes = duplicated(dog_survey_spend_on_food)) %>% 
  filter(dog_dupes == FALSE) %>% 
  select(-dog_dupes)

# Tidy up data in the dog_gender column for analysis
dog_survey_gender <- dog_survey_remove_dupes %>% 
  mutate(dog_gender = str_to_lower(dog_gender)) %>% 
  mutate(dog_gender = case_when(
    dog_gender == "m" ~ "male",
    dog_gender == "f" ~ "female"))

dog_gender_na <- dog_survey_gender %>% 
  mutate(dog_gender = coalesce(dog_gender, "unknown"))

# Tidy up data inside the dog_size column for analysis
dog_survey_size_clean <- dog_gender_na %>% 
  mutate(dog_size = str_to_lower(dog_size)) %>% 
  mutate(dog_size = case_when(
    dog_size == "xs" ~ dog_size,
    dog_size == "s" ~ dog_size,
    dog_size == "m" ~ dog_size,
    dog_size == "l" ~ dog_size,
    dog_size == "xl" ~ dog_size
  ))

# Change the first and last name to titles
dog_survey_names_to_titles <- dog_survey_size_clean
  mutate(first_name = str_to_title(first_name)) %>% 
  mutate(last_name = str_to_title(last_name))
  
dog_survey_clean <- dog_survey_names_to_titles

write_csv(dog_survey_clean, "data/clean_data/dog_survey_clean.csv")
  
  

