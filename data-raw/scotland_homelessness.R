library(tidyverse)
library(compositr)
library(readxl)
library(devtools)

# ---- Load internal sysdata.rda file with URLs ----
load_all(".")

# ---- Council Area names and codes ----
#TODO: Move this code to {geographr}
scottish_ltla_names_codes <-
  geographr::boundaries_ltla21 |>
  sf::st_drop_geometry() |>
  filter(str_detect(ltla21_code, "^S")) |>

  # Match to LA names in the homelessness data
  mutate(ltla21_name = str_replace(ltla21_name, " and ", " & ")) |>
  mutate(
    ltla21_name = case_match(
      ltla21_name,
      "Na h-Eileanan Siar" ~ "Eilean Siar",
      "City of Edinburgh" ~ "Edinburgh",
      "Shetland Islands" ~ "Shetland",
      .default = ltla21_name
    )
  )

# ---- Household estimates ----
# Source: https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fhousehold-estimates
#TODO: Move this code to {demographr}
scotland_households <- read_csv("https://statistics.gov.scot/slice/observations.csv?&dataset=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fhousehold-estimates&http%3A%2F%2Fpurl.org%2Flinked-data%2Fcube%23measureType=http%3A%2F%2Fstatistics.gov.scot%2Fdef%2Fmeasure-properties%2Fcount&http%3A%2F%2Fpurl.org%2Flinked-data%2Fsdmx%2F2009%2Fdimension%23refPeriod=http%3A%2F%2Freference.data.gov.uk%2Fid%2Fyear%2F2021", skip = 7)

scotland_households <-
  scotland_households |>
  mutate(ltla21_code = str_extract(`http://purl.org/linked-data/sdmx/2009/dimension#refArea`, "S[0-9]+")) |>
  filter(str_detect(ltla21_code, "^S12")) |>
  select(
    ltla21_code,
    `Number of households` = `Which Are Occupied`
  )

# ---- Homelessness applications by local authority ----
# Source: https://www.gov.scot/publications/homelessness-in-scotland-update-to-30-september-2023/documents/
# Main page: https://www.gov.scot/collections/homelessness-statistics/
tf <- download_file("https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2024/02/homelessness-in-scotland-update-to-30-september-2023/documents/tables-to-homelessness-in-scotland-update-to-30-sep-2023/tables-to-homelessness-in-scotland-update-to-30-sep-2023/govscot%3Adocument/Homelessness%2Bin%2BScotland%2Bupdate%2Bto%2B30%2BSep%2B2023%2B-%2BFinal.xlsx", ".xlsx")

scotland_homelessness <- read_excel(tf, sheet = "T8", range = "A5:P38")

scotland_homelessness <-
  scotland_homelessness |>
  select(ltla21_name = `Local Authority`, `2022\r\nOct-Dec`:`2023\r\nJul-Sep`) |>
  filter(ltla21_name != "Scotland") |>

  rowwise() |>
  mutate(applications = sum(c_across(where(is.double)))) |>
  ungroup() |>

  left_join(scottish_ltla_names_codes) |>

  # Calculate rate
  left_join(scotland_households) |>
  mutate(`Assessed as homeless or threatened with homelessness per 1,000` = applications / `Number of households` * 1000) |>
  select(ltla21_code, `Assessed as homeless or threatened with homelessness per 1,000`)

# ---- Temporary accommodation ----
# Use more up-to-date data
scotland_temp_accom_raw <- read_excel(tf, sheet = "T15", range = "A5:P38")

scotland_temp_accom <-
  scotland_temp_accom_raw |>
  select(ltla21_name = `Local Authority`, `2022\r\n31 Dec`:`2023\r\n30 Sep`) |>
  filter(ltla21_name != "Scotland") |>

  rowwise() |>
  mutate(temp_accomm = sum(c_across(where(is.double)))) |>
  ungroup() |>

  left_join(scottish_ltla_names_codes) |>

  # Calculate rate
  left_join(scotland_households) |>
  mutate(`Households in temporary accommodation per 1,000` = temp_accomm / `Number of households` * 1000) |>
  select(ltla21_code, `Households in temporary accommodation per 1,000`)

# ---- Combine and save data ----
scotland_homelessness <-
  scotland_homelessness |>
  left_join(scotland_temp_accom)

usethis::use_data(scotland_homelessness, overwrite = TRUE)
