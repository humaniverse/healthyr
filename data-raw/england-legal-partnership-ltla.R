# ---- Load libs ----
library(tidyverse)
library(geographr)
library(devtools)
library(httr2)

# ---- Load internal sysdata.rda file with URLs ----
load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "legal_partnership_status_2021") |>
  pull(query)

download <- tempfile(fileext = ".zip")

request(query_url) |>
  req_perform(download)

unzip(download, exdir = tempdir())

list.files(tempdir())

raw <- read_csv(file.path(tempdir(), "census2021-ts002-ltla.csv"))

names(raw) <- str_remove(names(raw), "Marital and civil partnership status: ")

# ---- Detailed ethnic categories ----
england_legal_partnership_21 <-
  raw |>
  select(-date, -geography) |>
  rename(ltla21_code = `geography code`,
         total_population = `Total; measures: Value`) |>
  pivot_longer(cols = -c(ltla21_code, total_population), names_to = "legal_partnership", values_to = "n") |>
  mutate(prop = n / total_population) |>
  mutate(prop = format(prop, scientific = FALSE))


# ---- Save output to data/ folder ----
usethis::use_data(england_legal_partnership_21, overwrite = TRUE)
