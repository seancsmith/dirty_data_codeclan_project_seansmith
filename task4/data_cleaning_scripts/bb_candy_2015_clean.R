# Candy Clean 2015

library(tidyverse)
library(janitor)
library(here)
library(readxl)
library(lubridate)
library(stringr)

bb_candy_2015 <- read_xlsx("data/raw_data/boing-boing-candy-2015.xlsx")

# Clean names

bb_candy_2015_clean_names <- bb_candy_2015 %>% 
  clean_names()

bb_candy_2015_age_str_remove <- bb_candy_2015_clean_names %>% 
  mutate(how_old_are_you = str_remove(how_old_are_you, "\\..+"))

# Rename columns
bb_candy_2015_rename_cols <- bb_candy_2015_age_str_remove %>% 
  mutate(how_old_are_you = as.numeric(how_old_are_you)) %>% 
  rename("age" = how_old_are_you,
         "going_trick_or_treating" = are_you_going_actually_going_trick_or_treating_yourself,
         "year" = timestamp
         )

# Change timestamp value to year

bb_candy_2015_date <- bb_candy_2015_rename_cols %>% 
  mutate(year = 2015)

# Relocate Netto

bb_candy_2015_relocate_netto <- bb_candy_2015_date %>% 
  relocate(necco_wafers, .after = pixy_stix)

# Select columns and order

bb_candy_2015_select <- bb_candy_2015_relocate_netto %>% 
  select(year, age, going_trick_or_treating, butterfinger:york_peppermint_patties,
                  -white_bread,
                  -vicodin, 
                  -vials_of_pure_high_fructose_corn_syrup_for_main_lining_into_your_vein,
                  -peterson_brand_sidewalk_chalk,
                  -kale_smoothie,
                  -dental_paraphenalia,
                  -cash_or_other_forms_of_legal_tender,
                  -broken_glow_stick,
                  -creepy_religious_comics_chick_tracts,
                  -whole_wheat_anything,
                  -hugs_actual_physical_hugs,
                  -generic_brand_acetaminophen,
                  -candy_that_is_clearly_just_the_stuff_given_out_for_free_at_restaurants,
                  -joy_joy_mit_iodine
           )


bb_candy_2015_order_cols <- bb_candy_2015_select %>% 
  select(year, age, going_trick_or_treating, sort(colnames(.)))

bb_candy_2015_clean <- bb_candy_2015_order_cols

