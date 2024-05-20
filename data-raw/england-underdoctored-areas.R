library(tidyverse)
library(geographr)
# library(readxl)
library(compositr)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Load GP practice locations ----
query_url <-
  query_urls |>
  filter(id == "england_gp") |>
  pull(query)

tf <- download_file(query_url, ".zip")

unzip(tf, exdir = tempdir())

gp_locations <-
  read_csv(
    file.path(tempdir(), "epraccur.csv"),
    col_select = c(1, 2, 10),
    col_names = FALSE
  ) |>
  rename(
    gp_code = X1,
    gp_name = X2,
    postcode = X10
  )

# Geocode
gp_locations <-
  gp_locations |>
  mutate(postcode = str_remove(postcode, " ")) |>
  left_join(
    geographr::lookup_postcode_oa11_lsoa11_msoa11_ltla20 |> select(-oa11_code)
  ) |>
  select(-postcode)

# ---- Load GP workforce and patient list data ----
query_url <-
  query_urls |>
  filter(id == "england_gp_patients") |>
  pull(query)

tf <- download_file(query_url, ".zip")

unzip(tf, exdir = tempdir())

gp <- read_csv(file.path(tempdir(), "1 General Practice – March 2024 Practice Level - Detailed.csv"))

# Tidy up the data
gp <-
  gp |>
  select(
    gp_code = PRAC_CODE,
    total_patients = TOTAL_PATIENTS,
    gp_fte = TOTAL_GP_FTE  # Total GPs Full Time Equivalents
  ) |>

  mutate(gp_fte = as.double(gp_fte)) |>

  # Practices where gp_fte is zero or NA have missing data, so exclude them
  filter(gp_fte > 0)

# ---- Calculate patients per GP in English Local Authorities ----
# Aggregate into Local Authorities
gp_lad <-
  gp |>
  left_join(gp_locations) |>

  group_by(ltla20_code) |>
  summarise(
    total_patients = sum(total_patients, na.rm = TRUE),
    total_gp_fte = sum(gp_fte, na.rm = TRUE)
  ) |>
  ungroup() |>
  mutate(patients_per_gp = total_patients / total_gp_fte)

# Calculate deciles
gp_lad <-
  gp_lad |>
  mutate(underdoctored_decile = as.integer(Hmisc::cut2(patients_per_gp, g = 10)))

# Rename
england_underdoctored_areas <- gp_lad

# ---- Save output to data/ folder ----
usethis::use_data(england_underdoctored_areas, overwrite = TRUE)
