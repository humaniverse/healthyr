library(tidyverse)
library(geographr)
library(readxl)
library(compositr)
library(sf)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Load number of GPs ----
query_url <-
  query_urls |>
  filter(id == "scotland_gp") |>
  pull(query)

tf <- download_file(query_url, ".xlsx")

# Number of GPs by Local Authority
gp_scotland <- read_excel(tf, sheet = "Data", skip = 2)

# ---- Load number of patients ----
query_url <-
  query_urls |>
  filter(id == "scotland_gp_patients") |>
  pull(query)

tf <- download_file(query_url, ".xlsx")

gp_patients_scotland <- read_excel(tf, sheet = "Data", skip = 2)

# ---- Calculate underdoctored areas ----
gp_scotland <-
  gp_scotland |>
  filter(Gender == "All" & Designation == "All GPs") |>
  select(
    ltla21_name = `Local Authority`,
    total_gp = `2022`
  )

gp_patients_scotland <-
  gp_patients_scotland |>
  filter(Year == max(Year) & `Practice type` == "All") |>
  select(
    ltla21_name = `Local Authority`,
    total_patients = `All ages`
  )

# Calculate patients per GP
gp_scotland <-
  gp_scotland |>
  left_join(gp_patients_scotland) |>
  mutate(patients_per_gp = total_patients / total_gp)

gp_scotland <-
  gp_scotland |>
  filter(ltla21_name != "Scotland")

# Lookup LA codes
lad_codes_scotland <-
  geographr::boundaries_ltla21 |>
  st_drop_geometry() |>
  filter(str_detect(ltla21_code, "^S"))

gp_scotland <-
  gp_scotland |>
  left_join(lad_codes_scotland)

# Calculate deciles
gp_scotland <-
  gp_scotland |>
  mutate(underdoctored_decile = as.integer(Hmisc::cut2(patients_per_gp, g = 10)))

# Rename
scotland_underdoctored_areas <- gp_scotland |>
  relocate(ltla21_code) |>
  select(-ltla21_name)

# ---- Save output to data/ folder ----
usethis::use_data(scotland_underdoctored_areas, overwrite = TRUE)
