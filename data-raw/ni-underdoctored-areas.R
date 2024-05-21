library(tidyverse)
library(geographr)
library(readxl)
library(compositr)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "ni_gp") |>
  pull(query)

tf <- download_file(query_url, ".xlsx")

# ---- Load number of GPs per Local Authority ----
# Table 1.2b: GPs by Gender, Age Group and Local Government District by year
gp_ni <- read_excel(tf, sheet = "1.2", range = "A108:V119")

# Load number of registered patients per Local Authority
# Table 1.1b: Registered Patients by Gender, Age Group and Local Government District by year
gp_patients_ni <- read_excel(tf, sheet = "1.1b", range = "A108:Y119")

# Wrangle data
gp_ni <-
  gp_ni |>
  select(
    ltla21_name = `2022`,
    total_gp = `All GPs Total`
  )

gp_patients_ni <-
  gp_patients_ni |>
  select(
    ltla21_name = `2022`,
    total_patients = `All Persons Total`
  )

# Calculate patients per GP
gp_ni <-
  gp_ni |>
  left_join(gp_patients_ni) |>
  mutate(patients_per_gp = total_patients / total_gp)

# Calculate deciles
gp_ni <-
  gp_ni |>
  mutate(underdoctored_decile = as.integer(Hmisc::cut2(patients_per_gp, g = 10)))

# Lookup LA codes
lad_codes_ni <-
  geographr::boundaries_ltla21 |>
  st_drop_geometry() |>
  filter(str_detect(ltla21_code, "^N"))

gp_ni <-
  gp_ni |>
  left_join(lad_codes_ni)
