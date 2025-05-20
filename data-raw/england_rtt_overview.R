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
  filter(id == "rtt_overview") |>
  pull(query)

# download xls to as a temp file
download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

# read the xls file
raw <- read_excel(download, skip = 11)

england_rtt_overview <-
  raw |>
  select(
    month = `...2`,
    # `Median wait (weeks)` = `Median wait (weeks)...3`,
    `No. within 18 weeks` = `No. within 18 weeks...5`,
    `No. > 18 weeks`,
    `No. > 52 weeks` = `No. > 52 weeks...11`,
    `Total waiting` = `Total waiting (mil)`
  ) |>

  # Fix dates
  filter(!is.na(month)) |>
  mutate(
    month = if_else(
      str_detect(month, "Feb"),
      ym("2024-02"),
      janitor::convert_to_date(month, string_conversion_failure = "warning")
    )
  ) |>

  pivot_longer(cols = -month, names_to = "type_of_wait", values_to = "count") |>
  mutate(count = as.integer(count)) |>
  drop_na()

# Save output to data/ folder
usethis::use_data(england_rtt_overview, overwrite = TRUE)
