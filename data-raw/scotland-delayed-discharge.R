# ---- Load libs ----
library(tidyverse)
library(devtools)
library(lubridate)

# ---- Load internal sysdata.rda file with URLs ----
load_all(".")

# ---- Delayed Discharge Bed Days by Health Board ----
query_url <-
  query_urls |>
  filter(id == "scotland_delayed_discharge_hb") |>
  pull(query)

scotland_delayed_discharge_hb <- read_csv(query_url)

scotland_delayed_discharge_hb <-
  scotland_delayed_discharge_hb |>

  mutate(date = ym(MonthOfDelay)) |>

  select(
    hb_code = HBT,
    date,
    age_group = AgeGroup,
    delay_reason = ReasonForDelay,
    num_delayed_bed_days = NumberOfDelayedBedDays,
    average_daily_delayed_beds = AverageDailyNumberOfDelayedBeds
  )

# Save output to data/ folder
usethis::use_data(scotland_delayed_discharge_hb, overwrite = TRUE)

# ---- Delayed Discharge Bed Days by Council Area ----
query_url <-
  query_urls |>
  filter(id == "scotland_delayed_discharge_ltla") |>
  pull(query)

scotland_delayed_discharge_ltla <- read_csv(query_url)

scotland_delayed_discharge_ltla <-
  scotland_delayed_discharge_ltla |>
  mutate(date = ym(MonthOfDelay)) |>
  select(
    ltla_code = CA,
    date,
    age_group = AgeGroup,
    delay_reason = ReasonForDelay,
    num_delayed_bed_days = NumberOfDelayedBedDays,
    average_daily_delayed_beds = AverageDailyNumberOfDelayedBeds
  )

# Save output to data/ folder
usethis::use_data(scotland_delayed_discharge_ltla, overwrite = TRUE)
