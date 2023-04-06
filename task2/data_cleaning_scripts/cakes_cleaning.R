# Dirty Data Project - Task 2 - Cleaning Script

library(tidyverse)
library(readr)
library(janitor)
library(skimr)
library(stringr)
library(here)

# Read in the data
cake_recipes <- read_csv(here("data/raw_data/cake-ingredients-1961.csv"))
cake_codes <- read_csv(here("data/raw_data/cake_ingredient_code.csv"))

# view the data
dim(cake_recipes)
skim(cake_recipes)
summary(cake_recipes)


# Tidy in to long format
# Drop the NA values as we don't need info when ingredients are NA
# Join with the cake_codes table to get full ingredient name
# Remove the "code" leaving only the information we want

cake_recipe_clean <- cake_recipes %>% 
  pivot_longer(cols = ("AE":"ZH"),
               names_to = "code",
               values_to = "quantity") %>% 
  drop_na(quantity) %>% 
  left_join(cake_codes, by = "code") %>% 
  clean_names() %>% 
  select(cake, ingredient, measure, quantity)

# Change the measure NA values to cup as they are clearly meant to be "Sour cream - cup"
# Make all ingredients lower case

cakes_cleaned <- cake_recipe_clean %>% 
  mutate(measure = coalesce(measure, "cup")) %>% 
  mutate(ingredient = str_remove(ingredient, " cup")) %>% 
  mutate(ingredient = str_to_lower(ingredient))

# Rrite to .csv and save in clean data
write_csv(cakes_cleaned, "data/clean_data/cakes_clean.csv")

