# ---- Load ----
library(statswalesr)
library(jsonlite)
library(httr)
library(RCurl)
library(dplyr)
library(readr)
library(tidyr)
library(lubridate)
library(janitor)


# ---- Function to download data from Stats Wales website ----
raw <- statswales_get_dataset("hlth0310")


# Clean the data
wales_critical_general_acute_beds <-
  raw |>
  as_tibble() |> 
  # Filter to only include data from Jan 2021 and only include high level specialty categories
  filter(Month_Code >= "202101" &
           Specialty_Hierarchy == "0"
         ) |>
  # Renaming measure variable names
  mutate(
         measure = case_when(Measure_ItemName_ENG == "Average daily occupied beds" ~ "average_daily_beds_occupied",
                             Measure_ItemName_ENG == "Average daily available beds" ~ "average_daily_beds_available",
                             Measure_ItemName_ENG == "Percentage occupancy" ~ "beds_occupancy_rate")
         ) |> 
  select(
    date = Month_ItemName_ENG, 
    hospital_code = Organisation_Code,
    hospital_name = Organisation_ItemName_ENG,
    specialty_name = Specialty_ItemName_ENG, 
    measure, Data
    ) |>
  pivot_wider(names_from = c(specialty_name, measure), values_from = Data, values_fn = list) |> 
  clean_names() 


# Save output to data/ folder
usethis::use_data(wales_critical_general_acute_beds, overwrite = TRUE)
