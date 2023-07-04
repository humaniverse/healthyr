# Northern Ireland on Health Inequalities Explorer
# Secondary care indicators - bed availability

# ---- Load libs ----
library(tidyverse)
library(devtools)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

query_url <-
  query_urls |>
  filter(id == "ni_beds") |>
  pull(query)

# ---- Download and wrangle data ----
raw <- read_csv(query_url, skip=2)

# Change dataset to tidy data with all relevant information
# Removed "Day Case" column since it included missing values and duplicate values with "Total Day Cases".
ni_beds <- raw |>
  select(
    financial_year = "Financial Year",
    quarter_ending = "Quarter Ending",
    HSC = "HSC Trust",
    hospital = "Hospital",
    programme_of_care = "Programme of Care",
    specialty = "Specialty",
    total_available_beds = "Total Available Beds",
    average_available_beds = "Average Available Beds",
    total_occupied_beds = "Total Occupied Beds",
    average_occupied_beds = "Average Occupied Beds",
    total_inpatients = "Total Inpatients",
    total_day_case = "Total Day Case",
    elective_inpatient = "Elective Inpatient",
    non_elective_inpatient = "Non Elective Inpatient",
    regular_attenders = "Regular Attenders")

# Save output to data/ folder
usethis::use_data(ni_beds, overwrite = TRUE)
