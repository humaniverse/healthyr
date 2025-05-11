#--- init ----------------------------------------------------------------------

library(tidyverse)


#--- read data -----------------------------------------------------------------

# NOTE: data downloaded manually and saved to ni-waiting-times.csv
raw <- read_csv("ni-waiting-times.csv")


#--- prepare -------------------------------------------------------------------

ni_waiting_times <- raw |>
  select(healthboard_name   = "Dept",
         date               = "Date",
         total              = "Total",
         under_4_hours      = "Under 4 Hours",
         between_4_12_hours = "Between 4 - 12 Hours",
         over_12_hours      = "Over 12 Hours"
         )


#--- save ----------------------------------------------------------------------

usethis::use_data(ni_waiting_times, overwrite = TRUE)
