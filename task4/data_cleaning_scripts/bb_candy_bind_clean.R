library(tidyverse)
library(janitor)
library(here)
library(readxl)
library(lubridate)
library(stringr)

source("data_cleaning_scripts/bb_candy_2015_clean.R")
source("data_cleaning_scripts/bb_candy_2016_clean.R")
source("data_cleaning_scripts/bb_candy_2017_clean.R")

# Bind the three dataframes
bb_candy_bind  <- bind_rows(bb_candy_2015_clean,
                            bb_candy_2016_clean, 
                            bb_candy_2017_clean)


# Order the columns
bb_candy_bind_order <- bb_candy_bind %>% 
  select(year, going_trick_or_treating, gender, age, country,
         sort(colnames(.)))

# Replace any numbers to "other"
bb_candy_bind_number_replace <- bb_candy_bind_order %>% 
  mutate(change_to_na = str_detect(country, "[0-9]"), .after = country) %>%  
  mutate(country = ifelse(change_to_na, "other", country))

# Convert all countries to lower case
bb_candy_bind_str_to_lower <- bb_candy_bind_number_replace %>% 
  mutate(country = str_to_lower(country))

# Remove all punctuation
bb_candy_bind_remove_punct <- bb_candy_bind_str_to_lower %>% 
  mutate(country = str_remove_all(country, "[:punct:]"))

# convert all misspelled countries to the appropriate one 
bb_candy_bind_str_replace_usa <- bb_candy_bind_remove_punct %>% 
  mutate(country = str_replace_all(country, ".*usa.*", "usa"),
         country = str_replace_all(country, "united s.*", "usa"),
         country = str_replace_all(country, "unites.*", "usa"),
         country = str_replace_all(country, "unied states", "usa"),
         country = str_replace_all(country, "unite states", "usa"),
         country = str_replace_all(country, ".merica", "usa"),
         country = str_replace_all(country, ".*usa", "usa"),
         country = str_replace_all(country, "u s.*", "usa"),
         country = str_replace_all(country, "^us$", "usa"),
# End of str_replace using regex
         country = str_replace_all(country, "unhinged states", "usa"),
         country = str_replace_all(country, "ahemamerca", "usa"),
         country = str_replace_all(country, "u s a", "usa"),
         country = str_replace_all(country, ".usa", "usa"),
         country = str_replace_all(country, "murica", "usa"),
         country = str_replace_all(country, "new york", "usa"),
         country = str_replace_all(country, "new jersey", "usa"),
         country = str_replace_all(country, "california", "usa"),
         country = str_replace_all(country, "north carolina", "usa"),
         country = str_replace_all(country, "pittsburgh", "usa"),
         country = str_replace_all(country, "murrika", "usa"),
         country = str_replace_all(country, "murica", "usa"),
         country = str_replace_all(country, "nusa", "usa"),
         country = str_replace_all(country, "alaska", "usa"),
         country = str_replace_all(country, "trumpistan", "usa"),
         country = str_replace_all(country, "merica", "usa"),
         country = str_replace_all(country, "units states", "usa"),
         country = str_replace_all(country, "usaa", "usa"),
         country = str_replace_all(country, "us of a", "usa"),
         country = str_replace_all(country, "ussa", "usa")
  )

bb_candy_bind_str_replace_canada <- bb_candy_bind_str_replace_usa %>% 
  mutate(country = str_replace_all(country, "canada`", "canada"),
         country = str_replace_all(country, "soviet canuckistan", "canada"),
         country = str_replace_all(country, "soviet canada", "canada"))

bb_candy_bind_str_replace_uk <- bb_candy_bind_str_replace_canada %>%
  mutate(country = str_replace_all(country, "united kingdom", "uk"),
         country = str_replace_all(country, "united kindom", "uk"),
         country = str_replace_all(country, "scotland", "uk"),
         country = str_replace_all(country, "england", "uk")
  )

# Convert all other countries to "other"
bb_candy_bind_case_country <- bb_candy_bind_str_replace_uk %>%
  mutate(country = case_when(
    country == "usa" ~ country,
    country == "uk" ~ country,
    country == "canada" ~ country,
    country == country ~ "other"))

# Remove the columns that are not required
bb_candy_bind_column_remove <- bb_candy_bind_case_country %>% 
  select(-change_to_na, -any_full_sized_candy_bar) 


# Filter the age column
bb_candy_age_filter <- bb_candy_bind_column_remove %>%
  mutate(age = case_when(
    age < 2 ~ NA_real_,
    age > 110 ~ NA_real_,
    TRUE ~ age
  ))


# Pivot the table to long format to reduce the number of columns
bb_candy_bind_pivot_test <- bb_candy_age_filter %>% 
  pivot_longer(cols = (6:108),
               names_to = "candy",
               values_to = "rating")


# Consolidate the names of the candy
bb_candy_bind_candy_removal <- bb_candy_bind_pivot_test %>% 
  mutate(candy = case_when(
    candy == "anonymous_brown_globs_that_come_in_black_and_orange_wrappers" ~ "mary_janes",
    candy == "anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes" ~ "mary_janes",
    candy == "boxo_raisins" ~ "box_o_raisins",
    candy == "blue_m_ms" ~ "m_ms_blue",
    candy == "green_party_m_ms" ~ "m_ms_green",
    candy == "independent_m_ms" ~ "m_ms",
    candy == "mint_m_ms" ~ "m_ms_mint",
    candy == "peanut_m_m_s" ~ "m_ms_peanut",
    candy == "red_m_ms" ~ "m_ms_red",
    candy == "regular_m_ms" ~ "m_ms",
    candy == "third_party_m_ms" ~ "m_ms",
    candy == "sweetums_a_friend_to_diabetes" ~ "sweetums",
    candy == "bonkers_the_candy" ~ "bonkers",
    candy == "gummy_bears_straight_up" ~ "gummy_bears",
    candy == "hershey_s_kissables" ~ "hersheys_kissables",
    candy == "hershey_s_milk_chocolate" ~ "hersheys_milk_chocolate",
    candy == "bonkers_the_candy" ~ "bonkers",
    candy == "licorice_yes_black" ~ "licorice_black",
    candy == "tolberone_something_or_other" ~ "toblerone",
    TRUE ~ candy
  ))

# Drop NA values from "rating" as we don't only need information on rated candy
bb_candy_bind_only_ratings <- bb_candy_bind_candy_removal %>% 
  drop_na(rating)

# Convert all ratings to lower case
bb_candy_bind_rating_to_lower <- bb_candy_bind_only_ratings %>% 
  mutate(rating = str_to_lower(rating))

bb_candy_bind_gender_tidy <- bb_candy_bind_rating_to_lower %>% 
  mutate(gender = str_to_lower(gender)) %>% 
  mutate(gender = case_when(
    gender == "female" ~ gender,
    gender == "male" ~ gender,
    gender == "i'd rather not say" ~ "other",
    TRUE ~ gender
  ))

bb_candy_bind_clean <- bb_candy_bind_gender_tidy

write_csv(bb_candy_bind_clean, "data/clean_data/bb_candy_bind_clean.csv")


