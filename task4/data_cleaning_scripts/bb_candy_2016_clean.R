# Candy Clean 2016

library(tidyverse)
library(janitor)
library(here)
library(readxl)
library(lubridate)
library(stringr)

bb_candy_2016 <- read_xlsx(here("data/raw_data/boing-boing-candy-2016.xlsx"))

# Clean names
bb_candy_2016_clean_names <- bb_candy_2016 %>% 
  clean_names()

bb_candy_2016_new_headers <- bb_candy_2016_clean_names %>% 
  rename("going_trick_or_treating"  = are_you_going_actually_going_trick_or_treating_yourself,
         "gender" = your_gender,
         "age" = how_old_are_you,
         "country" = which_country_do_you_live_in,
         "state" = which_state_province_county_do_you_live_in,
         "year" = timestamp
  )

# Change age to as.numeric and remove decimal
bb_candy_2016_age_str_remove <- bb_candy_2016_new_headers %>%
  mutate(age = str_remove(age, "\\..+")) %>%
  mutate(age = as.numeric(age)) %>% 
  mutate(year = 2016)

# Select and order columns
bb_candy_2016_select <- bb_candy_2016_age_str_remove %>% 
  select(year, going_trick_or_treating, gender,
         age, country, x100_grand_bar:york_peppermint_patties,
         -white_bread, -vicodin, 
         -vials_of_pure_high_fructose_corn_syrup_for_main_lining_into_your_vein,
         -kale_smoothie,
         -dental_paraphenalia,
         -chardonnay,
         -cash_or_other_forms_of_legal_tender,
         -broken_glow_stick,
         -creepy_religious_comics_chick_tracts,
         -bonkers_the_board_game,
         -whole_wheat_anything,
         -hugs_actual_physical_hugs,
         -generic_brand_acetaminophen,
         -candy_that_is_clearly_just_the_stuff_given_out_for_free_at_restaurants,
         -joy_joy_mit_iodine
  )

bb_candy_2016_order_cols <- bb_candy_2016_select %>% 
  select(year, going_trick_or_treating, gender, age, country,
         sort(colnames(.)),
         -person_of_interest_season_3_dvd_box_set_not_including_disc_4_with_hilarious_outtakes)

bb_candy_2016_clean <- bb_candy_2016_order_cols

