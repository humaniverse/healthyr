library(tidyverse)
library(geographr)
library(readxl)
library(compositr)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Load GP practice locations ----
query_url <-
  query_urls |>
  filter(id == "wales_gp") |>
  pull(query)

tf <- download_file(query_url, ".xlsx")

gp_wales <- read_excel(tf)

# Geocode
gp_wales <-
  gp_wales |>
  mutate(postcode = str_remove(Postcode, " ")) |>
  left_join(
    geographr::lookup_postcode_oa11_lsoa11_msoa11_ltla20 |> select(-oa11_code)
  ) |>
  select(-postcode)

# Aggregate into Local Authorities
gp_wales <-
  gp_wales |>
  group_by(ltla20_code) |>
  summarise(
    total_patients = sum(`Total Number of Patients (Including Temporary Residents)`, na.rm = TRUE),
    total_gp = sum(CurrentRegisteredGPsInPractice, na.rm = TRUE)
  ) |>
  ungroup() |>
  mutate(patients_per_gp = total_patients / total_gp)

# Calculate deciles
gp_wales <-
  gp_wales |>
  mutate(underdoctored_decile = as.integer(Hmisc::cut2(patients_per_gp, g = 10)))

# Rename
wales_underdoctored_areas <- gp_wales

# ---- Save output to data/ folder ----
usethis::use_data(wales_underdoctored_areas, overwrite = TRUE)

