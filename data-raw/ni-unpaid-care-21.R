# Provision of unpaid care (delayed discharge) in Northern Ireland

# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "ni_unpaid_care_21") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

raw <- read_excel(
  download,
  sheet = "MS-D17",
  range = "A9:AF21"
)

# ---- Clean data ----
# LGD renamed ltla for consistency in package
ni_unpaid_care_21 <- raw |>
  mutate(
    total_unpaid_carers = `All usual residents aged 5 and over` - `All usual residents aged 5 and over:\r\nProvides no unpaid care`,
    age_5_to_14_years = `All usual residents aged 5-14 years` - `All usual residents aged 5-14 years:\r\nProvides no unpaid care`,
    age_15_to_39_years = `All usual residents aged 15-39 years` - `All usual residents aged 15-39 years:\r\nProvides no unpaid care`,
    age_40_to_64_years = `All usual residents aged 40-64 years` - `All usual residents aged 40-64 years:\r\nProvides no unpaid care`,
    age_65_over_years = `All usual residents aged 65+ years` - `All usual residents aged 65+ years:\r\nProvides no unpaid care`
  ) |>
  select(
    ltla21_name = "Geography",
    ltla21_code = "Geography code",
    total_population = "All usual residents aged 5 and over",
    total_unpaid_carers,
    age_5_to_14_years,
    age_15_to_39_years,
    age_40_to_64_years,
    age_65_over_years) |>
  filter(ltla21_code != "N92000002")

# ---- Save output to data/ folder ----
usethis::use_data(ni_unpaid_care_21, overwrite = TRUE)
