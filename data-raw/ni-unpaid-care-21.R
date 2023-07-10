# Provision of unpaid care (delayed discharge) in Northern Ireland

# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "ni_unpaid_care_21") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

raw <- read_excel(
  download,
  sheet = "MS-D17",
  range = "A9:AF21"
)

raw2 <- read_excel(
  download,
  sheet = "MS-D17",
  range = "A24:AF36"
)

# ---- Clean data ----
# LGD renamed ltla for consistency in package
total_hours_unpaid <- raw |>
  select(
    ltla21_name = "Geography",
    ltla21_code = "Geography code",
    total_5_and_over = "All usual residents aged 5 and over",
    count_5_and_over_0_hours = "All usual residents aged 5 and over:\r\nProvides no unpaid care",
    count_5_and_over_1to19_hours = "All usual residents aged 5 and over:\r\nProvides 1-19 hours unpaid care per week",
    count_5_and_over_20to34_hours = "All usual residents aged 5 and over:\r\nProvides 20-34 hours unpaid care per week",
    count_5_and_over_35to49_hours = "All usual residents aged 5 and over:\r\nProvides 35-49 hours unpaid care per week",
    count_5_and_over_50plus_hours = "All usual residents aged 5 and over:\r\nProvides 50+ hours unpaid care per week",
    total_5to14_years = "All usual residents aged 5-14 years",
    count_5to14_years_0_hours = "All usual residents aged 5-14 years:\r\nProvides no unpaid care",
    count_5to14_years_1to19_hours = "All usual residents aged 5-14 years:\r\nProvides 1-19 hours unpaid care per week",
    count_5to14_years_20to34_hours = "All usual residents aged 5-14 years:\r\nProvides 20-34 hours unpaid care per week",
    count_5to14_years_35to49_hours = "All usual residents aged 5-14 years:\r\nProvides 35-49 hours unpaid care per week",
    count_5to14_years_50plus_hours = "All usual residents aged 5-14 years:\r\nProvides 50+ hours unpaid care per week",
    total_15to39_years = "All usual residents aged 15-39 years",
    count_15to39_years_0_hours = "All usual residents aged 15-39 years:\r\nProvides no unpaid care",
    count_15to39_years_1to19_hours = "All usual residents aged 15-39 years:\r\nProvides 1-19 hours unpaid care per week",
    count_15to39_years_20to34_hours = "All usual residents aged 15-39 years:\r\nProvides 20-34 hours unpaid care per week",
    count_15to39_years_35to49_hours = "All usual residents aged 15-39 years:\r\nProvides 35-49 hours unpaid care per week",
    count_15to39_years_50plus_hours = "All usual residents aged 15-39 years:\r\nProvides 50+ hours unpaid care per week",
    total_40to64_years = "All usual residents aged 40-64 years",
    count_40to64_years_0_hours = "All usual residents aged 40-64 years:\r\nProvides no unpaid care",
    count_40to64_years_1to19_hours = "All usual residents aged 40-64 years:\r\nProvides 1-19 hours unpaid care per week",
    count_40to64_years_20to34_hours = "All usual residents aged 40-64 years:\r\nProvides 20-34 hours unpaid care per week",
    count_40to64_years_35to49_hours = "All usual residents aged 40-64 years:\r\nProvides 35-49 hours unpaid care per week",
    count_40to64_years_50plus_hours = "All usual residents aged 40-64 years:\r\nProvides 50+ hours unpaid care per week",
    total_65_and_over = "All usual residents aged 65+ years",
    count_65_and_over_0_hours = "All usual residents aged 65+ years:\r\nProvides no unpaid care",
    count_65_and_over_1to19_hours = "All usual residents aged 65+ years:\r\nProvides 1-19 hours unpaid care per week",
    count_65_and_over_20to34_hours = "All usual residents aged 65+ years:\r\nProvides 20-34 hours unpaid care per week",
    count_65_and_over_35to49_hours = "All usual residents aged 65+ years:\r\nProvides 35-49 hours unpaid care per week",
    count_65_and_over_50plus_hours = "All usual residents aged 65+ years:\r\nProvides 50+ hours unpaid care per week"
  ) |>
  filter(ltla21_code != "N92000002")

percent_hours_unpaid <- raw2 |>
  select(
    ltla21_code = "Geography code",
    percent_5_and_over_0_hours = "All usual residents aged 5 and over:\r\nProvides no unpaid care",
    percent_5_and_over_1to19_hours = "All usual residents aged 5 and over:\r\nProvides 1-19 hours unpaid care per week",
    percent_5_and_over_20to34_hours = "All usual residents aged 5 and over:\r\nProvides 20-34 hours unpaid care per week",
    percent_5_and_over_35to49_hours = "All usual residents aged 5 and over:\r\nProvides 35-49 hours unpaid care per week",
    percent_5_and_over_50plus_hours = "All usual residents aged 5 and over:\r\nProvides 50+ hours unpaid care per week",
    percent_5to14_years_0_hours = "All usual residents aged 5-14 years:\r\nProvides no unpaid care",
    percent_5to14_years_1to19_hours = "All usual residents aged 5-14 years:\r\nProvides 1-19 hours unpaid care per week",
    percent_5to14_years_20to34_hours = "All usual residents aged 5-14 years:\r\nProvides 20-34 hours unpaid care per week",
    percent_5to14_years_35to49_hours = "All usual residents aged 5-14 years:\r\nProvides 35-49 hours unpaid care per week",
    percent_5to14_years_50plus_hours = "All usual residents aged 5-14 years:\r\nProvides 50+ hours unpaid care per week",
    percent_15to39_years_0_hours = "All usual residents aged 15-39 years:\r\nProvides no unpaid care",
    percent_15to39_years_1to19_hours = "All usual residents aged 15-39 years:\r\nProvides 1-19 hours unpaid care per week",
    percent_15to39_years_20to34_hours = "All usual residents aged 15-39 years:\r\nProvides 20-34 hours unpaid care per week",
    percent_15to39_years_35to49_hours = "All usual residents aged 15-39 years:\r\nProvides 35-49 hours unpaid care per week",
    percent_15to39_years_50plus_hours = "All usual residents aged 15-39 years:\r\nProvides 50+ hours unpaid care per week",
    percent_40to64_years_0_hours = "All usual residents aged 40-64 years:\r\nProvides no unpaid care",
    percent_40to64_years_1to19_hours = "All usual residents aged 40-64 years:\r\nProvides 1-19 hours unpaid care per week",
    percent_40to64_years_20to34_hours = "All usual residents aged 40-64 years:\r\nProvides 20-34 hours unpaid care per week",
    percent_40to64_years_35to49_hours = "All usual residents aged 40-64 years:\r\nProvides 35-49 hours unpaid care per week",
    percent_40to64_years_50plus_hours = "All usual residents aged 40-64 years:\r\nProvides 50+ hours unpaid care per week",
    percent_65_and_over_0_hours = "All usual residents aged 65+ years:\r\nProvides no unpaid care",
    percent_65_and_over_1to19_hours = "All usual residents aged 65+ years:\r\nProvides 1-19 hours unpaid care per week",
    percent_65_and_over_20to34_hours = "All usual residents aged 65+ years:\r\nProvides 20-34 hours unpaid care per week",
    percent_65_and_over_35to49_hours = "All usual residents aged 65+ years:\r\nProvides 35-49 hours unpaid care per week",
    percent_65_and_over_50plus_hours = "All usual residents aged 65+ years:\r\nProvides 50+ hours unpaid care per week"
  ) |>
  filter(ltla21_code != "N92000002")

ni_unpaid_care_21 <-
  inner_join(
    total_hours_unpaid,
    percent_hours_unpaid,
    by = "ltla21_code"
  ) |>
  pivot_longer(
    cols = -c(ltla21_name, ltla21_code),
    names_to = "variable", values_to = "value"
  )

# ---- Save output to data/ folder ----
usethis::use_data(ni_unpaid_care_21, overwrite = TRUE)
