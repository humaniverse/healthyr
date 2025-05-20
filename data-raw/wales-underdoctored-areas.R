library(tidyverse)
library(geographr)
library(httr2)
library(readxl)

# ---- Load internal sysdata.rda file with URL's ----
pkgload::load_all()

# ---- Load GP practice locations ----
query_url <-
  query_urls |>
  filter(id == "wales_gp") |>
  pull(query)

temp_path <- tempfile(fileext = ".zip")

request(query_url) |>
  req_perform(path = temp_path)

gp_wales <- read_excel(temp_path)

# Geocode
gp_wales <-
  gp_wales |>
  mutate(postcode = str_remove(Postcode, " ")) |>
  left_join(
    geographr::lookup_postcode_oa_lsoa_msoa_ltla_2025 |> select(-oa11_code)
  ) |>
  select(-postcode)

# Aggregate into Local Authorities
wales_underdoctored_areas <- gp_wales |>
  group_by(ltla24_code) |>
  summarise(
    total_patients = sum(
      `Total Number of Patients (Including Temporary Residents)`,
      na.rm = TRUE
    ),
    total_gp = sum(CurrentRegisteredGPsInPractice, na.rm = TRUE)
  ) |>
  ungroup() |>
  mutate(patients_per_gp = total_patients / total_gp) |>
  filter(str_starts(ltla24_code, "W"))

# ---- Save output to data/ folder ----
usethis::use_data(wales_underdoctored_areas, overwrite = TRUE)
