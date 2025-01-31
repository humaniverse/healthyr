# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Download and clean acute trust attribution lookup file
# Source: https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/ae-attendances-and-emergency-admissions-2022-23/

# Download data
query_url <-
  query_urls |>
  filter(id == "acute_trust_attribution") |>
  pull(query)

# Download xls to as a temp file
download <- tempfile(fileext = ".xls")

request(query_url) |>
  req_perform(download)

# Read the xls file
raw <-
  read_excel(
    download,
    sheet = "Attribution",
    range = "B9:G224"
  )

# Clean the df
england_ae_acute_trust_attribution <- raw |>
  rename(
    nhs_trust22_code_all = Code...2,
    nhs_trust22_code_acute = Code...4,
    proportion_attendances_attributed_to_acute_trust = `Proportion of Attendances Attributed to Acute Trust`
  ) |>
  select(-Region, -Name...3, -Name...5)

# Save output to data/ folder
usethis::use_data(england_ae_acute_trust_attribution, overwrite = TRUE)
