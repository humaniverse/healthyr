# ---- Load libs ----
library(tidyverse)
library(devtools)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

query_url <-
  query_urls |>
  filter(id == "scotland_beds") |>
  pull(query)

# ---- Download and wrangle data ----
raw <- read_csv(query_url)

# Filter to make Health Board codes match with location codes. This ensures
# hospital and other statistics are dropped, keeping only the Health Board
# statistics of interest.
scotland_beds <- raw |>
  filter(HB == Location) |>
  mutate(date = yq(Quarter)) |>
  filter(HB != "SB0801" & HB != "S92000003") |>
  select(
    hb19_code = HB,
    date,
    specialty = SpecialtyName,
    average_number_available_staffed_beds = AverageAvailableStaffedBeds,
    average_number_occupied_beds = AverageOccupiedBeds,
    percent_occupied_beds = PercentageOccupancy
  ) |>
  mutate(percent_occupied_beds = percent_occupied_beds / 100)

# Save output to data/ folder
usethis::use_data(scotland_beds, overwrite = TRUE)
