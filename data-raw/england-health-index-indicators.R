# ---- Load libs ----
library(tidyverse)
library(readxl)
library(sf)
library(geographr)
library(devtools)
library(httr2)
library(lubridate)

# ---- LTLA lookup table ----
lookup_ltla21 <- boundaries_ltla21 |>
  st_drop_geometry()

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "england_health_index_2021_indicators") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

raw <- read_excel(
  download,
  sheet = "Table_2_Underlying_data",
  skip = 3
)

# ---- Clean data ----
england_health_index_indicators <-
  raw |>
  select(ltla21_code = `Area code`, year = Year, indicator = `Indicator name`, value = Value)

# ---- Save output to data/ folder ----
usethis::use_data(england_health_index_indicators, overwrite = TRUE)
