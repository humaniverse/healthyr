# ---- Load libs ----
library(tidyverse)
library(sf)
library(readxl)
library(devtools)
library(httr2)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all()

# ---- Trust lookup table ----
trust_lookup <- geographr::boundaries_trusts_ni18 |>
  st_drop_geometry()

# ---- Function to download and clean ----
query_url <-
  query_urls |>
  filter(id == "ni_bed_occupancy_21_22") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

# Read
raw <-
  read_excel(
    download,
    sheet = "2a",
    range = "B7:J68"
  )

beds <- raw |>
  select(
    trust18_name = `Hospital/\r\nHSC Trust`,
    beds_available_count = `Average\r\nAvailable\r\nBeds`,
    beds_occupied_count = `Average\r\nOccupied\r\nBeds`,
    beds_occupied_percentage = `%\r\nOccupancy`
  ) |>
  mutate(date = "2021/22")

# Extract trust information
beds_trusts <-
  beds |>
  filter(str_detect(trust18_name, "HSCT")) |>
  mutate(trust18_name = str_remove_all(trust18_name, " HSCT")) |>
  right_join(trust_lookup) |>
  relocate(trust18_code, date) |>
  select(-trust18_name)

# Format table cells
ni_bed_occupancy <- beds_trusts |>
  mutate(
    across(.cols = starts_with("beds_"), as.numeric),
    across(.cols = ends_with("_count"), round),
    beds_occupied_percentage = round(beds_occupied_percentage, 3) / 100
  )

# Save output to data/ folder
usethis::use_data(ni_bed_occupancy, overwrite = TRUE)
