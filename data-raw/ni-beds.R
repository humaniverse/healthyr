# Northern Ireland on Health Inequalities Explorer
# Secondary care indicators - bed availability

# ---- Load libs ----
library(tidyverse)
library(devtools)
library(geographr)
library(sf)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

query_url <-
  query_urls |>
  filter(id == "ni_beds") |>
  pull(query)

# ---- Download and wrangle data ----
raw <- read_csv(query_url, skip = 2)

lookup_trusts <- geographr::boundaries_trusts_ni18 |>
  st_drop_geometry()

# Removed "Day Case" column since it included missing values and duplicate values with "Total Day Cases".
ni_beds <- raw |>
  rename(trust18_name = "HSC Trust") |>
  left_join(lookup_trusts, by = "trust18_name") |>
  select(
    trust18_code,
    date = "Quarter Ending",
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
    regular_attenders = "Regular Attenders"
  ) |>
  mutate(date = as_date(date, format = "%d/%m/%Y"))


# Save output to data/ folder
usethis::use_data(ni_beds, overwrite = TRUE)
