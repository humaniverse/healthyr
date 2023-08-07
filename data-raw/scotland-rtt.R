library(tidyverse)
library(lubridate)

# Download monthly RTT data by Health Board from https://www.opendata.nhs.scot/dataset/18-weeks-referral-to-treatment
raw <- read_csv("https://www.opendata.nhs.scot/dataset/aa8b22e8-8a02-484d-a6c8-0a0154a6249d/resource/f2598c24-bf00-4171-b7ef-a469bbacbf6c/download/open_data_18_weeks_rtt_march23.csv")

scotland_rtt <- raw |>
  filter(HBT == "S92000003") |> # national waiting lists
  mutate(
    Year = str_sub(Month, 1, 4) |> as.integer(),
    Month = month.abb[as.integer(str_sub(Month, 5, 6))],
    Date = my(paste0(Month, Year)),
    performance_over = 1 - (Performance / 100)
  ) |>
  select(
    date = Date,
    year = Year,
    month = Month,
    waits_over_18_weeks_count = Over18Weeks,
    waits_over_18_weeks_percent = performance_over
  )

# Waiting lists by Health Board
scotland_rtt_hb <- raw |>
  filter(HBT != "S92000003") |> # Don't include national waiting lists
  mutate(
    Year = str_sub(Month, 1, 4) |> as.integer(),
    Month = month.abb[as.integer(str_sub(Month, 5, 6))],
    Date = my(paste0(Month, Year)),
    performance_over = 1 - (Performance / 100)
  ) |>
  select(
    hb19_code = HBT,
    date = Date,
    year = Year,
    month = Month,
    specialty = Specialty,
    waits_over_18_weeks_count = Over18Weeks,
    waits_over_18_weeks_percent = performance_over
  )

# Save output to data/ folder
usethis::use_data(scotland_rtt, overwrite = TRUE)
usethis::use_data(scotland_rtt_hb, overwrite = TRUE)
