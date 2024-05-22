library(tidyverse)

source("https://github.com/matthewgthomas/brclib/raw/master/R/download_wales.R")

# ---- Household estimates ----
# Dwelling stock estimates by local authority and tenure
# Source: https://statswales.gov.wales/Catalogue/Housing/Dwelling-Stock-Estimates
wales_households_raw <- download_wales("http://open.statswales.gov.wales/en-gb/dataset/hous0501")

wales_households <-
  wales_households_raw |>
  mutate(Year_Code = as.integer(Year_Code)) |>
  filter(
    Year_Code == max(Year_Code) &
      !Area_Hierarchy %in% c("0", "596") &  # Keep only Local Authorities
      Tenure_ItemName_ENG == "All tenures (Number)"
  ) |>
  select(
    Area_Code,
    ltla21_name = Area_ItemName_ENG,
    `Number of households` = Data
  ) |>
  mutate(`Number of households` = as.numeric(`Number of households`))

# ---- Homelessness ----
# Households for which assistance has been provided by outcome and household type
# Source: https://statswales.gov.wales/Catalogue/Housing/Homelessness/Statutory-Homelessness-Prevention-and-Relief
wales_homelessness_raw <- download_wales("http://open.statswales.gov.wales/en-gb/dataset/hous0413")

#!! I don't think `number of outcomes` is what we want - needs to be number of households
wales_homelessness <-
  wales_homelessness_raw |>
  filter(
    Period_Code == "2022230",
    str_detect(Area_AltCode1, "^W06"),
    Household_ItemName_ENG == "Total",
    Outcomes_ItemName_ENG == "Total prevention / Relief"
    # str_detect(Outcomes_ItemName_ENG, "Number of outcomes")
  ) |>

  mutate(Data = if_else(Data >= 0, Data, NA_real_)) |>

  group_by(Area_AltCode1, Area_Code) |>
  summarise(`Homeless or threatened with homelessness` = sum(Data, na.rm = TRUE)) |>
  ungroup()

# Calculate homelessness rate
wales_homelessness <-
  wales_homelessness |>
  left_join(wales_households) |>
  mutate(`Homeless or threatened with homelessness per 1,000` = `Homeless or threatened with homelessness` / `Number of households` * 1000) |>
  select(ltla21_code = Area_AltCode1, `Homeless or threatened with homelessness per 1,000`)

# ---- Temporary accommodation ----
# Households accommodated temporarily by accommodation type and household type
# Source: https://statswales.gov.wales/Catalogue/Housing/Homelessness/Temporary-Accommodation
wales_temp_accom_raw <- download_wales("http://open.statswales.gov.wales/en-gb/dataset/hous0420")

wales_temp_accom <-
  wales_temp_accom_raw |>
  filter(
    Period_Code == "202324Q2",
    str_detect(Area_AltCode1, "^W06"),
    Household_ItemName_ENG == "Total",
    Time_ItemName_ENG == "Total"
  ) |>

  mutate(Data = if_else(Data >= 0, Data, NA_real_)) |>

  group_by(Area_AltCode1, Area_Code) |>
  summarise(`Households in temporary accommodation` = sum(Data, na.rm = TRUE)) |>
  ungroup()

# Calculate rate
wales_temp_accom <-
  wales_temp_accom |>
  left_join(wales_households) |>
  mutate(`Households in temporary accommodation per 1,000` = `Households in temporary accommodation` / `Number of households` * 1000) |>
  select(ltla21_code = Area_AltCode1, `Households in temporary accommodation per 1,000`)

# ---- Combine and save data ----
wales_homelessness <-
  wales_homelessness |>
  left_join(wales_temp_accom)

usethis::use_data(wales_homelessness, overwrite = TRUE)
