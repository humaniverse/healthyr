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
scotland_beds <- read_csv(query_url)

scotland_beds <-
  scotland_beds |>
  mutate(date = yq(Quarter)) |>

  select(
    hb_code = HB,
    date,
    average_number_available_staffed_beds = AverageAvailableStaffedBeds,
    average_number_occupied_beds = AverageOccupiedBeds,
    percent_occuped_beds = PercentageOccupancy
  )

# Save output to data/ folder
usethis::use_data(scotland_beds, overwrite = TRUE)
