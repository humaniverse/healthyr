# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)
library(lubridate)
library(janitor)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# get url from query_urls table
query_url <-
  query_urls |>
  filter(id == "mental_health_monthly") |>
  pull(query)

# download xls to as a temp file
download <- tempfile(fileext = ".zip")

request(query_url) |>
  req_perform(download)

unzip(download, exdir = tempdir())

list.files(tempdir())

measures_to_keep <- c(
  "People in contact with services at the end of the reporting period"
  # "New referrals"
)

# Load 2016 to Q1 2023
raw_historical <- read_csv(file.path(tempdir(), "MHSDS Time_Series_data_Apr_2016_MarPrf_2023.csv"))

mh_historical <-
  raw_historical |>
  filter(MEASURE_NAME %in% measures_to_keep) |>
  select(
    date = REPORTING_PERIOD_END,
    measure = MEASURE_NAME,
    count = MEASURE_VALUE
  ) |>
  mutate(count = as.integer(count)) |>
  group_by(date, measure) |>
  summarise(count = sum(count, na.rm = TRUE)) |>
  ungroup() |>

  mutate(date = dmy(date)) |>
  arrange(date)

# Load 2023 data
raw_2023 <- read_csv(file.path(tempdir(), "MHSDS Time_Series_data_Apr_2023_MarFinal_2024.csv"))

mh_2023 <-
  raw_2023 |>
  filter(MEASURE_NAME %in% measures_to_keep) |>
  select(
    date = REPORTING_PERIOD_END,
    measure = MEASURE_NAME,
    count = MEASURE_VALUE
  ) |>
  mutate(count = as.integer(count)) |>
  group_by(date, measure) |>
  summarise(count = sum(count, na.rm = TRUE)) |>
  ungroup() |>

  mutate(date = dmy(date)) |>
  arrange(date)

raw_2024 <- read_csv(file.path(tempdir(), "MHSDS Time_Series_data_Apr_2024.csv"))

mh_2024 <-
  raw_2024 |>
  filter(MEASURE_NAME %in% measures_to_keep) |>
  select(
    date = REPORTING_PERIOD_END,
    measure = MEASURE_NAME,
    count = MEASURE_VALUE
  ) |>
  mutate(count = as.integer(count)) |>
  group_by(date, measure) |>
  summarise(count = sum(count, na.rm = TRUE)) |>
  ungroup() |>

  mutate(date = dmy(date)) |>
  arrange(date)

# Combine data
england_mental_health_performance <- bind_rows(mh_historical, mh_2023, mh_2024)

# Save output to data/ folder
usethis::use_data(england_mental_health_performance, overwrite = TRUE)
