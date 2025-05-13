library(tidyverse)
library(geographr)
library(readxl)

# NOTE: seems like original data url has changed.
# the data file is downloaded and saved in data-raw/ni-underdoctored-areas.xlsx

# ---- Load number of GPs per Local Authority ----
# Table 4.2: GPs per 100,000 registered patients by Local Government District by year
raw <- list("2017" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A5:D16"),
            "2018" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A20:D31"),
            "2019" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A35:D46"),
            "2020" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A50:D61"),
            "2021" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A65:D76"),
            "2022" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A80:D91"),
            "2023" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A95:D106"),
            "2024" = read_excel("data-raw/ni-underdoctored-areas.xlsx", sheet = "4.2", range = "A110:D121")
            )

# add years as separate column
raw <- Map(function(x,y) {x$year <- y; x}, raw, names(raw))
raw <- do.call(rbind, raw)

# lookup LA codes
lad_codes_ni <- as_tibble(geographr::boundaries_ltla21) |>
  select(-geometry) |>
  filter(str_detect(ltla21_code, "^N"))

# prepare data
ni_underdoctored_areas <- raw |>
  select(ltla21_name = LGD,
         date = year,
         total_patients = "Registered patients",
         total_gp = GPs,
         ) |>
  mutate(patients_per_gp = total_patients / total_gp) |>
  left_join(lad_codes_ni) |>
  relocate(ltla21_code)

# ---- Save output to data/ folder ----
usethis::use_data(ni_underdoctored_areas, overwrite = TRUE)
