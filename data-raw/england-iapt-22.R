# ---- Load libs ----
library(tidyverse)
library(lubridate)
library(compositr)

# ---- Create lookups ----
lookup_sicb <- geographr::lookup_lsoa11_sicbl22_icb22_ltla22 |>
  distinct(sicbl22_code_h, sicbl22_code)

# ---- Load internal sysdata.rda file with URL's ----
devtools::load_all()

# ---- Download and read ----
query_url <-
  query_urls |>
  filter(id == "nhs_iapt_22_23") |>
  pull(query)

tf <- tempfile()
download.file(query_url, tf)

raw <- read_csv(tf)

# ---- Clean ----
iapt_raw <- raw |>
  select(
    group_type = GROUP_TYPE,
    org_code1 = ORG_CODE1,
    org_code2 = ORG_CODE2,
    org_name1 = ORG_NAME1,
    org_name2 = ORG_NAME2,
    date = REPORTING_PERIOD_START,
    name = MEASURE_NAME,
    value = MEASURE_VALUE
  ) |>
  mutate(
    date = str_c(
      as.character(month(date, label = TRUE, abbr = FALSE)),
      " ",
      str_sub(date, -4)
    )
  ) |>
  mutate(value = if_else(value == "*", NA_character_, value))

# ---- Export SubICB data ----
england_sicb_iapt <- iapt_raw |>
  filter(group_type == "SubICB") |>
  filter(org_code1 %in% lookup_sicb$sicbl22_code_h) |>
  left_join(lookup_sicb, by = c("org_code1" = "sicbl22_code_h")) |>
  select(sicbl22_code, date, name, value)

usethis::use_data(england_sicb_iapt, overwrite = TRUE)

# ---- Export Trust level data ----
england_trust_iapt <- iapt_raw |>
  filter(org_code2 %in% geographr::points_nhs_trusts22$nhs_trust22_code) |>
  filter(group_type == "Provider") |>
  select(nhs_trust22_code = org_code2, date, name, value)

usethis::use_data(england_trust_iapt, overwrite = TRUE)
