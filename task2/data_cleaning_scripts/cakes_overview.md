# Cake Ingredient Analysis

## The Raw Data

The *raw data* came in the form of two .csv files. Table 1 (cake_ingredients_1961.csv)  contains all the different types of cake with all of the _ingredient codes_ as column headers. This file was in *wide format* and filled with _NA values_. Table 2 (cake_ingredient_code) contains a list of ingredients and their correspongding _ingredient code_, as well as a measure column. The only thing missing from this table was the `measure` value for "Sour cream cup".

## Assumptions

My first assumption was that I would have to change the format of Table 1 to *long format*. I could see there were many _NA values_ in this table and I was assuming that these ingredients were not required for the corresponding cake, as oppose to *missing information*. The brief states that the full ingredient name is required and not just the _ingredient code_. So I thought the best way to approach this is to *join* the tables using the _ingredient code_. 

Another assumption I made about table 2 was that the *missing information* in the `measure` column was meant to be "cup". I assumed that the `ingredient` listed was meant to be "Sour cream" and the `measure` was meant to be "cup". Rather than the ingredient being "Sour cream cup".


## Cleaning Proceess Overview



## Other Interesting Analyses