
# Dirty Data Project - Task 2

library(tidyverse)
library(readr)
library(janitor)
library(skimr)
library(stringr)

# Read in the data

cake_recipes <- read_csv("data/raw_data/cake-ingredients-1961.csv")
cake_codes <- read_csv("data/raw_data/cake_ingredient_code.csv")

# view the data

dim(cake_recipes)
skim(cake_recipes)
summary(cake_recipes)

# Tidy in to long format

cake_recipes_long <- cake_recipes %>% 
  pivot_longer(cols = ("AE":"ZH"),
               names_to = "code",
               values_to = "quantity")


# Drop the NA values as we don't need info when ingredients are NA

cake_recipes_dropna <- cake_recipes_long %>% 
  drop_na(quantity)


# Join with the cake_codes table to get full ingredient name

cake_recipes_full <- cake_recipes_dropna %>% 
  left_join(cake_codes, by = "code")


# Clean the headers

cake_recipes_full_clean <- cake_recipes_full %>% 
  clean_names()

# Remove the "code" leaving only the information we want

cake_recipe_clean <- cake_recipes_full_clean %>% 
  select(cake, ingredient, measure, quantity)
cake_recipe_clean

# change the measure NA values to cup as they are clearly meant to be "Sour cream - cup"

cake_recipe_clean_sour <- cake_recipe_clean %>% 
  mutate(measure = coalesce(measure, "cup"))


# remove the "cup" from "Sour cream cup"

cake_recipe_clean_cup_remove <- cake_recipe_clean_sour %>% 
  mutate(ingredient = str_remove(ingredient, " cup"))

# data is now fully clean

cakes_cleaned <- cake_recipe_clean_cup_remove

# write to .csv and save in clean data

write_csv(cakes_cleaned, "data/clean_data/cakes_clean.csv")

