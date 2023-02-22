# bb_candy_2017_clean

library(tidyverse)
library(janitor)
library(here)
library(readxl)
library(lubridate)
library(stringr)

# Read in data
bb_candy_2017 <- read_xlsx("data/raw_data/boing-boing-candy-2017.xlsx")


# Clean names
bb_candy_2017_clean_names <- bb_candy_2017 %>% 
  clean_names()

bb_candy_2017_remove_q <- bb_candy_2017_clean_names %>% 
  names() %>% 
  str_remove("q[0-9]+_")

names(bb_candy_2017_clean_names) <- bb_candy_2017_remove_q


# Age as numeric
bb_candy_2017_age_numeric <- bb_candy_2017_clean_names %>% 
  mutate(age = round(as.numeric(age)))

# Rename columns
bb_candy_2017_rename <- bb_candy_2017_age_numeric %>% 
  rename("state" = state_province_county_etc,
         "x100_grand_bar" = "100_grand_bar",
         "going_trick_or_treating" = going_out)

# Create a year column and relocate
bb_candy_2017_create_year <- bb_candy_2017_rename %>% 
  cbind("year") %>%
  clean_names() %>% 
  mutate(year = as.numeric(year),
         year = 2017) %>% 
  relocate(year, .after = internal_id)

# Select columns required
bb_candy_2017_select <- bb_candy_2017_create_year %>% 
  select(year, going_trick_or_treating, gender, age, country,
         x100_grand_bar:york_peppermint_patties,
         -real_housewives_of_orange_county_season_9_blue_ray,
         -white_bread, -vicodin, 
         -vials_of_pure_high_fructose_corn_syrup_for_main_lining_into_your_vein,
         -kale_smoothie,
         -dental_paraphenalia,
         -chardonnay,
         -cash_or_other_forms_of_legal_tender,
         -broken_glow_stick,
         -abstained_from_m_ming,
         -creepy_religious_comics_chick_tracts,
         -bonkers_the_board_game,
         -whole_wheat_anything,
         -hugs_actual_physical_hugs,
         -generic_brand_acetaminophen,
         -candy_that_is_clearly_just_the_stuff_given_out_for_free_at_restaurants,
         -joy_joy_mit_iodine
  )

# Order the columns
bb_candy_2017_order_cols <- bb_candy_2017_select %>% 
  select(year, going_trick_or_treating, gender, age, country,
         sort(colnames(.)))

bb_candy_2017_clean <- bb_candy_2017_order_cols

#write_csv(bb_candy_2017_clean, "data/clean_data/bb_candy_2017_clean.csv")

