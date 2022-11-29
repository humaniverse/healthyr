# ---- Load ----
library(statswalesr)
library(tidyverse)
library(jsonlite)
library(httr)
library(RCurl)
library(tidyr)
library(lubridate)


# ---- Function to download data from Stats Wales website ----
raw <- raw <- statswales_get_dataset("hlth1308")

# ---- Clean data ----
wales_ambulance_waiting_times <-
  raw |>
  as_tibble() |>
  # Filter to only include data from Jan 2021
  filter(Date_SortOrder >= "202101") |> 
  select(
    Date = Date_ItemName_ENG,
    HB_code = Area_Code,
    HB = Area_ItemName_ENG,
    Measure_ItemName_ENG,
    Data
  ) |>
  pivot_wider(names_from = Measure_ItemName_ENG, values_from = Data) |> 
  clean_names()


# Save output to data/ folder
usethis::use_data(wales_ambulance_waiting_times, overwrite = TRUE)
