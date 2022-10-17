# ---- Load libs ----
library(tidyverse)
library(devtools)
library(httr2)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all()

# ---- Download and clean ----
query_url <-
  query_urls |>
  filter(id == "nhs_iapt_july_22") |>
  pull(query)

raw <- read_csv(query_url)

nhs_iapt_22 <- raw |>
  select(
    nhs_trust22_code = ORG_CODE2,
    name = MEASURE_NAME,
    value = MEASURE_VALUE_SUPPRESSED
  ) |>
  mutate(date = "July 2022") |>
  relocate(date, .after = nhs_trust22_code) |>
  filter(nhs_trust22_code %in% geographr::points_nhs_trusts22$nhs_trust22_code)

usethis::use_data(nhs_iapt_22, overwrite = TRUE)
