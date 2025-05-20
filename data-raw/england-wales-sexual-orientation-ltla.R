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
  filter(id == "sexual_orientation_2021") |>
  pull(query)

download <- tempfile(fileext = ".zip")

request(query_url) |>
  req_perform(download)

unzip(download, exdir = tempdir())

list.files(tempdir())

raw <- read_csv(file.path(tempdir(), "census2021-ts077-ltla.csv"))

names(raw) <- str_remove(names(raw), "Sexual orientation: ")

# ---- Detailed ethnic categories ----
sexual_orientation_21 <-
  raw |>
  select(-date, -geography) |>
  rename(
    ltla21_code = `geography code`,
    total_residents = `Total: All usual residents aged 16 years and over`
  ) |>
  pivot_longer(cols = -c(ltla21_code, total_residents), names_to = "sexual_orientation", values_to = "n") |>
  mutate(prop = n / total_residents) |>
  mutate(prop = format(prop, scientific = FALSE))

england_sexual_orientation_21 <- sexual_orientation_21 |>
  filter(str_detect(ltla21_code, "^E"))

wales_sexual_orientation_21 <- sexual_orientation_21 |>
  filter(str_detect(ltla21_code, "^W"))

# ---- Save output to data/ folder ----
usethis::use_data(england_sexual_orientation_21, overwrite = TRUE)
usethis::use_data(wales_sexual_orientation_21, overwrite = TRUE)
