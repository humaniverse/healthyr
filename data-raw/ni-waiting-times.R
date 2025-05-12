#--- init ----------------------------------------------------------------------

library(geographr)
library(tidyverse)


#--- read data -----------------------------------------------------------------

# NOTE: data downloaded manually and saved to ni-waiting-times.csv
raw <- read_csv("data-raw/ni-waiting-times.csv")


#--- prepare -------------------------------------------------------------------

locations <- as_tibble(boundaries_trusts_ni18) |>
  select(-geometry)

ni_waiting_times <- raw |>
  select(trust18_name       = "Trust",
         department         = "Dept",
         date               = "Date",
         total              = "Total",
         under_4_hours      = "Under 4 Hours",
         between_4_12_hours = "Between 4 - 12 Hours",
         over_12_hours      = "Over 12 Hours"
         ) |>
  left_join(locations) |>
  relocate(trust18_code)


#--- save ----------------------------------------------------------------------

usethis::use_data(ni_waiting_times, overwrite = TRUE)
