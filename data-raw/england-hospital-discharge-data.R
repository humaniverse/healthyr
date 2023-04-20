# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Function to download and clean ----
scrape_data <- function(id, sheet, number_of_areas, range, date_start, date_end, days) {
  # Download
  query_url <-
    query_urls |>
    filter(id == {{ id }}) |>
    pull(query)

  download <- tempfile(fileext = ".xlsx")

  request(query_url) |>
    req_perform(download)

  # Read
  raw_trusts <-
    read_excel(
      download,
      sheet = sheet,
      range = range
    )

  # Make the data "long"
  long <-
    raw_trusts |>
    rename(code = 1) |>
    select(-2) |>
    pivot_longer(cols = !code)

  # Create a vector of dates and variable names to assign to raw data
  # Note: - 121 Trusts across 4 variables
  #       - 42 ICBs across 4 variables
  dates <-
    seq(from = ymd(date_start), to = ymd(date_end), by = "days") |>
    rep(times = number_of_areas, each = 4)

  # Note: 30 days (of April) across 121 Trusts
  variables <-
    c(
      "Do not meet criteria to reside",
      "Discharged by 17:00",
      "Discharged between 17:01 and 23:59",
      "Number of patients remaining in hospital that do not meet criteria to reside"
    ) |>
    rep(times = days * number_of_areas)

  # Add dates and variable names and filter to variable of interest
  data <-
    long |>
    mutate(date = dates, name = variables) |>
    pivot_wider(names_from = "name", values_from = "value")

  return(data)
}

# ---- Trust level data ----
# - Iterate over all data sets and return as a dataframe
# Generate a dataframe with function arguments
trust_df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_hospital_discharge")) |> pull(id),
    sheet = rep("Table 2", 12),
    number_of_areas = rep(121, 12),
    range = c("C61:DT182", "C60:DX181", "C60:DT181", "C60:DX181", "C60:DX181", "C59:DT180", "C60:DX181", "C59:DT180", "C59:DX180", "C59:DX180", "C59:DL180", "C59:DX180"),
    date_start = c("2022-04-01", "2022-05-01", "2022-06-01", "2022-07-01", "2022-08-01", "2022-09-01", "2022-10-01", "2022-11-01", "2022-12-01", "2023-01-01", "2023-02-01", "2023-03-01"),
    date_end = c("2022-04-30", "2022-05-31", "2022-06-30", "2022-07-31", "2022-08-31", "2022-09-30", "2022-10-31", "2022-11-30", "2022-12-31", "2023-01-31", "2023-02-28", "2023-03-31"),
    days = c(30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31)
  )

# Build dataframe with all months
england_trust_discharge_data <- pmap_dfr(trust_df, scrape_data)

# - Criteria to reside
trust_criteria_to_reside <-
  england_trust_discharge_data |>
  select(
    nhs_trust22_code = code,
    date,
    do_not_meet_criteria_to_reside = `Do not meet criteria to reside`
  )

# Two clear outliers exist in the data, presumably from data entry errors
trust_criteria_to_reside |>
  arrange(desc(do_not_meet_criteria_to_reside))

# Replace outliers with previous value in series
england_trust_criteria_to_reside <-
  trust_criteria_to_reside |>
  mutate(
    do_not_meet_criteria_to_reside = case_when(
      nhs_trust22_code == "RXQ" & date == "2022-06-15" ~ NA_real_,
      nhs_trust22_code == "RH8" & date == "2022-05-22" ~ NA_real_,
      TRUE ~ do_not_meet_criteria_to_reside
    )
  ) |>
  fill(do_not_meet_criteria_to_reside)

# Save output to data/ folder
usethis::use_data(england_trust_criteria_to_reside, overwrite = TRUE)

# - Number discharged
trust_discharged_patients <-
  england_trust_discharge_data |>
  select(
    nhs_trust22_code = code,
    date,
    discharged_by_1700 = `Discharged by 17:00`,
    discharged_between_1701_2359 = `Discharged between 17:01 and 23:59`
  )

england_trust_discharged_patients <-
  trust_discharged_patients |>
  rowwise() |>
  mutate(discharged_total = sum(c_across(starts_with("discharged")))) |>
  ungroup()

# Save output to data/ folder
usethis::use_data(england_trust_discharged_patients, overwrite = TRUE)

# ---- ICB level data ----
# Older 'h' codes are provided in the data that need replacing with newer ICB
# codes.
# Source: https://geoportal.statistics.gov.uk/datasets/ons::lsoa-2011-to-sub-icb-locations-to-integrated-care-boards-july-2022-lookup-in-england/explore
lookup_icb_codes <- geographr::lookup_lsoa11_sicbl22_icb22_ltla22 |> 
  distinct(icb22_code, icb22_code_h)

# - Iterate over all data sets and return as a dataframe
# Generate a dataframe with function arguments
icb_df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_hospital_discharge")) |> pull(id),
    sheet = rep("Table 2", 12),
    number_of_areas = rep(42, 12),
    range = c("C17:DT59", "C16:DX58", "C16:DT58", "C16:DX58", "C16:DX58", "C15:DT57", "C16:DX58", "C15:DT57", "C15:DX57", "C15:DX57", "C15:DL57", "C15:DX57"),
    date_start = c("2022-04-01", "2022-05-01", "2022-06-01", "2022-07-01", "2022-08-01", "2022-09-01", "2022-10-01", "2022-11-01", "2022-12-01", "2023-01-01", "2023-02-01", "2023-03-01"),
    date_end = c("2022-04-30", "2022-05-31", "2022-06-30", "2022-07-31", "2022-08-31", "2022-09-30", "2022-10-31", "2022-11-30", "2022-12-31", "2023-01-31", "2023-02-28", "2023-03-31"),
    days = c(30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31)
  )

# Build dataframe with all months
england_icb_discharge_data <- pmap_dfr(icb_df, scrape_data)

# - Criteria to reside
icb_criteria_to_reside <-
  england_icb_discharge_data |>
  select(
    icb22_code_h = code,
    date,
    do_not_meet_criteria_to_reside = `Do not meet criteria to reside`
  )

# Replace old 'h' codes with new icb codes
england_icb_criteria_to_reside <- icb_criteria_to_reside |>
  left_join(lookup_icb_codes) |>
  relocate(icb22_code) |>
  select(-icb22_code_h)

# Save output to data/ folder
usethis::use_data(england_icb_criteria_to_reside, overwrite = TRUE)

# - Number discharged
icb_discharged_patients <-
  england_icb_discharge_data |>
  select(
    icb22_code_h = code,
    date,
    discharged_by_1700 = `Discharged by 17:00`,
    discharged_between_1701_2359 = `Discharged between 17:01 and 23:59`
  )

icb_discharged_patients_summed <- icb_discharged_patients |>
  rowwise() |>
  mutate(discharged_total = sum(c_across(starts_with("discharged")))) |>
  ungroup()

england_icb_discharged_patients <- icb_discharged_patients_summed |>
  left_join(lookup_icb_codes) |>
  relocate(icb22_code) |>
  select(-icb22_code_h)

# Save output to data/ folder
usethis::use_data(england_icb_discharged_patients, overwrite = TRUE)
