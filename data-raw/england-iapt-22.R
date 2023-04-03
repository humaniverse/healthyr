# ---- Load libs ----
library(tidyverse)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
devtools::load_all()

# ---- Download and clean ----
query_url <-
  query_urls |>
  filter(id == "nhs_iapt_21_22") |>
  pull(query)

raw <- read_csv(query_url)

# Note: different providers (determined in the GROUP_TYPE col) contribute
# statistics to the same org codes on the same day. This means there are repeat
# observations for any given trust in any given reporting period that require
# averaging.
england_iapt_nhs_trusts <- raw |>
  select(
    nhs_trust22_code = ORG_CODE2,
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
  filter(nhs_trust22_code %in% geographr::points_nhs_trusts22$nhs_trust22_code)

# Replace `*` values with NA and calculate the mean
england_iapt <- england_iapt_nhs_trusts |> 
  mutate(value = if_else(value == "*", NA_character_, value)) |>
  mutate(value = as.double(value)) |> 
  group_by(nhs_trust22_code, date, name) |> 
  summarise(value = mean(value, na.rm = TRUE)) |> 
  ungroup()

usethis::use_data(england_iapt, overwrite = TRUE)
