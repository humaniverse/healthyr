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
  filter(id == "england_disability_2021") |>
  pull(query)

download <- tempfile(fileext = ".zip")

request(query_url) |>
  req_perform(download)

unzip(download, exdir = tempdir())

list.files(tempdir())

raw <- read_csv(file.path(tempdir(), "census2021-ts038-ltla.csv"))

names(raw) <- str_remove(names(raw), "Disability: ")

# ---- Detailed ethnic categories ----
england_disability_21 <-
  raw |>
  select(ltla21_code = `geography code`,
         total_residents = `Total: All usual residents`, !contains(":"), -date, -geography) |>
  pivot_longer(cols = -c(ltla21_code, total_residents), names_to = "disability_level", values_to = "n") |>
  mutate(prop = n / total_residents)


# ---- Save output to data/ folder ----
usethis::use_data(england_disability_21, overwrite = TRUE)
