library(tidyverse)
library(compositr)
library(readxl)
library(sf)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Load lookup table: Local Authority to Community Safety Partnership ----
#TODO: Move this code to {geographr}
# Source: https://geoportal.statistics.gov.uk/search?q=LUP_LAD_CSP_PFA&sort=Date%20Created%7Ccreated%7Cdesc
lookup_ltla_csp <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LAD23_CSP23_PFA23_EW_LU/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson")

lookup_ltla_csp <-
  lookup_ltla_csp |>
  st_drop_geometry() |>
  select(ltla23_code = LAD23CD, csp23_code = CSP23CD)

# ---- Load crime severity data ----
query_url <-
  query_urls |>
  filter(id == "england_wales_crime_severity") |>
  pull(query)

tf <- download_file(query_url, ".xls")

crime_severity_raw <- read_excel(tf, sheet = "Data - csp", skip = 1)

crime_severity <-
  crime_severity_raw |>
  filter(`Offence group` == "Total recorded crime") |>
  select(csp23_code = Code, crime_severity_score = `Apr '22 to \nMar '23...25`) |>

  left_join(lookup_ltla_csp) |>
  select(ltla23_code, crime_severity_score)

england_crime_severity <-
  crime_severity |>
  filter(str_detect(ltla23_code, "^E"))

wales_crime_severity <-
  crime_severity |>
  filter(str_detect(ltla23_code, "^W"))

# ---- Save output to data/ folder ----
usethis::use_data(england_crime_severity, overwrite = TRUE)
usethis::use_data(wales_crime_severity, overwrite = TRUE)
