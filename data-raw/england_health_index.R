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
  filter(id == "england_health_index_2020") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

raw <- read_excel(
  download,
  sheet = "Table_2_Index_scores",
  range = "A3:I344"
)

# ---- Clean data ----
england_health_index <- raw |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  select(ltla21_code = `Area Code`, `2015`:`2020`) |>
  pivot_longer(!ltla21_code, names_to = "year", values_to = "overall_score")

# ---- Save output to data/ folder ----
usethis::use_data(england_health_index, overwrite = TRUE)
