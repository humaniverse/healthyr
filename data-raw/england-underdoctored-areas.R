library(tidyverse)
library(geographr)
library(httr2)

# ---- Load internal sysdata.rda file with URL's ----
pkgload::load_all()

# ---- Load GP practice locations ----
query_url <-
  query_urls |>
  filter(id == "england_gp") |>
  pull(query)

temp_path <- tempfile(fileext = ".zip")

request(query_url) |>
  req_perform(path = temp_path)

unzip(temp_path, exdir = tempdir())

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
    geographr::lookup_postcode_oa_lsoa_msoa_ltla_2025 |> select(-oa11_code)
  ) |>
  select(-postcode)

# ---- Load GP workforce and patient list data ----
query_url <-
  query_urls |>
  filter(id == "england_gp_patients") |>
  pull(query)

temp_path <- tempfile(fileext = ".zip")

request(query_url) |>
  req_perform(path = temp_path)

unzip(temp_path, exdir = tempdir())

gp <- read_csv(file.path(
  tempdir(),
  "1 General Practice – March 2024 Practice Level - Detailed.csv"
))

# Tidy up the data
gp <- gp |>
  select(
    gp_code = PRAC_CODE,
    total_patients = TOTAL_PATIENTS,
    gp_fte = TOTAL_GP_FTE # Total GPs Full Time Equivalents
  ) |>
  mutate(gp_fte = as.double(gp_fte)) |>
  # Practices where gp_fte is zero or NA have missing data, so exclude them
  filter(gp_fte > 0)

# ---- Calculate patients per GP in English Local Authorities ----
# Aggregate into Local Authorities
england_underdoctored_areas <- gp |>
  left_join(gp_locations) |>
  group_by(ltla24_code) |>
  summarise(
    total_patients = sum(total_patients, na.rm = TRUE),
    total_gp_fte = sum(gp_fte, na.rm = TRUE)
  ) |>
  ungroup() |>
  mutate(patients_per_gp = total_patients / total_gp_fte)

# ---- Save output to data/ folder ----
usethis::use_data(england_underdoctored_areas, overwrite = TRUE)
