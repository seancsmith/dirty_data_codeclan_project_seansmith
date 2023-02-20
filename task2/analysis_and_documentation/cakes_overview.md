# Cake Ingredient Analysis

## The Raw Data

The *raw data* came in the form of two .csv files. Table 1 (cake_ingredients_1961.csv)  contains all the different types of cake with all of the _ingredient codes_ as column headers. This file was in *wide format* and filled with _NA values_. Table 2 (cake_ingredient_code) contains a list of ingredients and their correspongding _ingredient code_, as well as a measure column. The only thing missing from this table was the `measure` value for "Sour cream cup".

## Assumptions

My first assumption was that I would have to change the format of Table 1 to *long format*. This would make it easier to see which ingredients were required for each cake. I could see there were many _NA values_ in this table and I was assuming that these ingredients were not required for the corresponding cake, as oppose to *missing information*. The brief states that the full ingredient name is required and not just the _ingredient code_. So I thought the best way to approach this is to *join* the tables using the _ingredient code_. 

Another assumption I made about table 2 was that the *missing information* in the `measure` column was meant to be "cup". I assumed that the `ingredient` listed was meant to be "Sour cream" and the `measure` was meant to be "cup". Rather than the ingredient being "Sour cream cup".


## Cleaning Proceess Overview

1. My first step was to pivot the table in to _long format_. I chose to do this rather than clean the column headers as I knew that it would be easier keeping them in upper-case to join the tables.

2. I then decided that was the best time to get rid of _NA values_ so i used _drop_na_
 
 #  cake_recipes_long <- cake_recipes %>% 
 #    pivot_longer(cols = ("AE":"ZH"),
 #               names_to = "code",
 #               values_to = "quantity")

 # cake_recipes_dropna <- cake_recipes_long %>%
 # drop_na(quantity)
 
3. Now seemed like the time to `join` the tables, clean the header names and select only the columns I required (get rid of the _ingredient code_).
 
 
#  cake_recipes_full <- cake_recipes_dropna %>% 
#   left_join(cake_codes, by = "code")
# 
# cake_recipes_full_clean <- cake_recipes_full %>% 
#   clean_names()
# 
# cake_recipe_clean <- cake_recipes_full_clean %>% 
#   select(cake, ingredient, measure, quantity)


4. The last step in my cleaning process was dealing with the *missing information*. This was in the `measure` column corresponding to "Sour cream cup". As previously mentioned I removed the "cup" from the `ingredient` column and added it to the `measure` column.

# cake_recipe_clean_sour <- cake_recipe_clean %>% 
#   mutate(measure = coalesce(measure, "cup"))
# 
# cake_recipe_clean_cup_remove <- cake_recipe_clean_sour %>% 
#   mutate(ingredient = str_remove(ingredient, " cup"))
# 
# cakes_cleaned <- cake_recipe_clean_cup_remove

## Task Analysis

1. Which cake has the most cocoa in it?

# ```{r}
# most_cocoa_cake <- cakes %>% 
#   filter(ingredient == "Cocoa") %>% 
#   slice_max(quantity)
# ```

2. For sponge cake, how many cups of ingredients are used in total?

```{r}
sponge_cake_test <- cakes %>% 
  filter(cake == "Sponge",
         measure == "cup") %>% 
  summarise(total_quantity = sum(quantity))
```

3. How many ingredients are measured in teaspoons?

```{r}
n_in_teaspoons <- cakes %>% 
  filter(measure == "teaspoon") %>% 
  distinct(ingredient) %>% 
  summarise(n_ingredients_teaspoon = n())
```

4. Which cake has the most unique ingredients?

```{r}
most_unique_ingred <- cakes %>% 
  group_by(cake) %>% 
  summarise(total_no_ingred = n()) %>% 
  arrange(desc(total_no_ingred)) %>% 
  head(2)
```

5. Which ingredients are used only once?

```{r}
ingedients_once <- cakes %>% 
  group_by(ingredient) %>% 
  mutate(times_used = n()) %>% 
  filter(times_used == 1) %>% 
  select(ingredient, times_used)
```


## Other Interesting Analyses