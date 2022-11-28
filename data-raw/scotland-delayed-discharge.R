# ---- Load libs ----
library(tidyverse)
library(devtools)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Function to download and clean ----
scrape_data <- function(id, sheet, range, date_start, date_end, days) {
}

# Delayed Discharge Bed Days by Health Board
# Source: https://www.opendata.nhs.scot/dataset/delayed-discharges-in-nhsscotland/resource/fd354e4b-6211-48ba-8e4f-8356a5ed4215
scotland_delayed_discharge_hb <- read_csv("https://www.opendata.nhs.scot/dataset/52591cba-fd71-48b2-bac3-e71ac108dfee/resource/fd354e4b-6211-48ba-8e4f-8356a5ed4215/download/2022-09_delayed-discharge-beddays-health-board.csv")

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

# Delayed Discharge Bed Days by Council Area
# Source: https://www.opendata.nhs.scot/dataset/delayed-discharges-in-nhsscotland/resource/513d2d71-cf73-458e-8b44-4fa9bccbf50a?inner_span=True
scotland_delayed_discharge_ltla <- read_csv("https://www.opendata.nhs.scot/dataset/52591cba-fd71-48b2-bac3-e71ac108dfee/resource/513d2d71-cf73-458e-8b44-4fa9bccbf50a/download/2022-09_delayed-discharge-beddays-council-area.csv")

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
