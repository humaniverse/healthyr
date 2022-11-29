# ---- Load ----
library(statswalesr)
library(jsonlite)
library(httr)
library(RCurl)
library(dplyr)
library(readr)
library(tidyr)
library(lubridate)


# ---- Function to download data ----
raw <- statswales_get_dataset("hlth0310")


# Clean the data
wales_beds <-
  raw |>
  as_tibble() |> 
  # Filter to only include data from Jan 2021
  filter(Month_Code >= "202101" &
           # Filter to only include high level specialty categories
           Specialty_Hierarchy == "0") |>
  # Grouping specialties of less relevance together
  mutate(Specialty_Name = case_when(Specialty_ItemName_ENG == "Bone Marrow Unit" | Specialty_ItemName_ENG == "Special Care Baby Units" | 
                                 Specialty_ItemName_ENG == "Community Medicine" | Specialty_ItemName_ENG == "Occupational Medicine" | 
                                 Specialty_ItemName_ENG == "Learning Disability" | Specialty_ItemName_ENG == "Nursing Activity" | 
                                 Specialty_ItemName_ENG == "Pathology" ~ "Other Specialties",
                               TRUE ~ Specialty_ItemName_ENG),
         # Renaming measure variable
         measure = case_when(Measure_ItemName_ENG == "Average daily occupied beds" ~ "average_daily_beds_occupied",
                             Measure_ItemName_ENG == "Average daily available beds" ~ "average_daily_beds_available",
                             Measure_ItemName_ENG == "Percentage occupancy" ~ "beds_occupancy_rate")) |> 
  select(
    Date = Month_ItemName_ENG, 
    Hospital_code = Organisation_Code,
    Hospital_name = Organisation_ItemName_ENG,
    Specialty_Name, 
    Measure, Data) |>
  pivot_wider(names_from = c(Specialty_Name, Measure), values_from = Data, values_fn = list)


wales_amublance_services <-
  ambo |>
  select(
    Date = Date_ItemName_ENG,
    HB_code = Area_Code,
    HB = Area_ItemName_ENG,
    Measure_ItemName_ENG,
    Data
  ) |>
  pivot_wider(names_from = Measure_ItemName_ENG, values_from = Data) |>
  filter(HB != "WALES") |>
  select(-Date)


wales_beds |>
  write_rds("preprocess/data/wales_beds.rds")

# Save output to data/ folder
usethis::use_data(wales_beds, overwrite = TRUE)
