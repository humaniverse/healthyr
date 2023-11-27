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
# For data until May '23 only
trust_df <-
  tibble(
    id = query_urls |>
      filter(str_detect(id, "^nhs_hospital_discharge")) |>
      slice(1:14) |> # filter for up to May '23 only - format of file changes after
      pull(id),
    sheet = rep("Table 2", 14),
    number_of_areas = c(rep(121, 13), 120),
    range = c("C61:DT182", "C60:DX181", "C60:DT181", "C60:DX181", "C60:DX181", "C59:DT180", "C60:DX181", "C59:DT180", "C59:DX180", "C59:DX180", "C59:DL180", "C59:DX180", "C59:DT180", "C59:DX179"),
    date_start = c("2022-04-01", "2022-05-01", "2022-06-01", "2022-07-01", "2022-08-01", "2022-09-01", "2022-10-01", "2022-11-01", "2022-12-01", "2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01", "2023-05-01"),
    date_end = c("2022-04-30", "2022-05-31", "2022-06-30", "2022-07-31", "2022-08-31", "2022-09-30", "2022-10-31", "2022-11-30", "2022-12-31", "2023-01-31", "2023-02-28", "2023-03-31", "2023-04-30", "2023-05-31"),
    days = c(30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31)
  )

# Build dataframe with all months
england_trust_discharge_data_before_may23 <- pmap_dfr(trust_df, scrape_data)

# - Criteria to reside
trust_criteria_to_reside_before_may23 <-
  england_trust_discharge_data_before_may23 |>
  select(
    nhs_trust22_code = code,
    date,
    do_not_meet_criteria_to_reside = `Do not meet criteria to reside`
  )

# Two clear outliers exist in the data, presumably from data entry errors
trust_criteria_to_reside_before_may23 |>
  arrange(desc(do_not_meet_criteria_to_reside))

# Replace outliers with previous value in series
england_trust_criteria_to_reside_before_may23 <-
  trust_criteria_to_reside_before_may23 |>
  mutate(
    do_not_meet_criteria_to_reside = case_when(
      nhs_trust22_code == "RXQ" & date == "2022-06-15" ~ NA_real_,
      nhs_trust22_code == "RH8" & date == "2022-05-22" ~ NA_real_,
      TRUE ~ do_not_meet_criteria_to_reside
    )
  ) |>
  fill(do_not_meet_criteria_to_reside)

# Save output to data/ folder
#usethis::use_data(england_trust_criteria_to_reside, overwrite = TRUE)

# - Number discharged
trust_discharged_patients_before_may23 <-
  england_trust_discharge_data_before_may23 |>
  select(
    nhs_trust22_code = code,
    date,
    discharged_by_1700 = `Discharged by 17:00`,
    discharged_between_1701_2359 = `Discharged between 17:01 and 23:59`
  )

england_trust_discharged_patients_before_may23 <-
  trust_discharged_patients_before_may23 |>
  rowwise() |>
  mutate(discharged_total = sum(c_across(starts_with("discharged")))) |>
  ungroup()

# Save output to data/ folder
#usethis::use_data(england_trust_discharged_patients, overwrite = TRUE)

# ---- ICB level data ----
# Older 'h' codes are provided in the data that need replacing with newer ICB
# codes.
# Source: https://geoportal.statistics.gov.uk/datasets/ons::lsoa-2011-to-sub-icb-locations-to-integrated-care-boards-july-2022-lookup-in-england/explore
lookup_icb_codes <- geographr::lookup_lsoa11_sicbl22_icb22_ltla22 |>
  distinct(icb22_code, icb22_code_h)

# - Iterate over all data sets and return as a dataframe
# Generate a dataframe with function arguments
# For data until May '23 only
icb_df <-
  tibble(
    id = query_urls |>
      filter(str_detect(id, "^nhs_hospital_discharge")) |>
      slice(1:14) |> # filter for up to May '23 only - format of file changes after
      pull(id),
    sheet = rep("Table 2", 14),
    number_of_areas = rep(42, 14),
    range = c("C17:DT59", "C16:DX58", "C16:DT58", "C16:DX58", "C16:DX58", "C15:DT57", "C16:DX58", "C15:DT57", "C15:DX57", "C15:DX57", "C15:DL57", "C15:DX57", "C15:DT57", "C15:DX57"),
    date_start = c("2022-04-01", "2022-05-01", "2022-06-01", "2022-07-01", "2022-08-01", "2022-09-01", "2022-10-01", "2022-11-01", "2022-12-01", "2023-01-01", "2023-02-01", "2023-03-01", "2023-04-01", "2023-05-01"),
    date_end = c("2022-04-30", "2022-05-31", "2022-06-30", "2022-07-31", "2022-08-31", "2022-09-30", "2022-10-31", "2022-11-30", "2022-12-31", "2023-01-31", "2023-02-28", "2023-03-31", "2023-04-30", "2023-05-31"),
    days = c(30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31)
  )

# Build dataframe with all months
england_icb_discharge_data_before_may23 <- pmap_dfr(icb_df, scrape_data)

# - Criteria to reside
icb_criteria_to_reside_before_may23 <-
  england_icb_discharge_data_before_may23 |>
  select(
    icb22_code_h = code,
    date,
    do_not_meet_criteria_to_reside = `Do not meet criteria to reside`
  )

# Replace old 'h' codes with new icb codes
england_icb_criteria_to_reside_before_may23 <- icb_criteria_to_reside_before_may23 |>
  left_join(lookup_icb_codes) |>
  relocate(icb22_code) |>
  select(-icb22_code_h)

# Save output to data/ folder
#usethis::use_data(england_icb_criteria_to_reside, overwrite = TRUE)

# - Number discharged
icb_discharged_patients_before_may23 <-
  england_icb_discharge_data_before_may23 |>
  select(
    icb22_code_h = code,
    date,
    discharged_by_1700 = `Discharged by 17:00`,
    discharged_between_1701_2359 = `Discharged between 17:01 and 23:59`
  )

icb_discharged_patients_summed_before_may23 <- icb_discharged_patients_before_may23 |>
  rowwise() |>
  mutate(discharged_total = sum(c_across(starts_with("discharged")))) |>
  ungroup()

england_icb_discharged_patients_before_may23 <- icb_discharged_patients_summed_before_may23 |>
  left_join(lookup_icb_codes) |>
  relocate(icb22_code) |>
  select(-icb22_code_h)

#---- Data after May 2023 ----
# Format of data changes in June 2023 - columns discharged by 17:00 and after
# 17:01 merged to single column "Number of patients discharged"

# ---- Updated function to download and clean ----
# Update function
scrape_data_after_may23 <- function(id, sheet, number_of_areas, range, date_start, date_end, days) {
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
  # Note: - 121 Trusts across 3 variables
  #       - 42 ICBs across 3 variables
  dates <-
    seq(from = ymd(date_start), to = ymd(date_end), by = "days") |>
    rep(times = number_of_areas, each = 3)

  # Note: 30 days (of April) across 121 Trusts
  variables <-
    c(
      "Do not meet criteria to reside",
      "Number of patients discharged",
      "Number of patients remaining in hospital that do not meet criteria to reside"
    ) |>
    rep(times = days * number_of_areas)

  # Add dates and variable names and filter to variable of interest
  data <-
    long |>
    mutate(date = dates, name = variables) |>
    pivot_wider(names_from = "name", values_from = "value")

  print(query_url)

  return(data)
}

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
    id = query_urls |>
      filter(str_detect(id, "^nhs_hospital_discharge")) |>
      slice(15:n()) |> # Filter for after May'23
      pull(id),
    sheet = rep("Table 2", 5),
    number_of_areas = c(42, 42, 42, 41, 41),
    range = c("C15:CP57", "C15:CS57", "C15:CS57", "C15:CP56", "C15:CS56"),
    date_start = c( "2023-06-01", "2023-07-01", "2023-08-01", "2023-09-01", "2023-10-01"),
    date_end = c("2023-06-30", "2023-07-31", "2023-08-31", "2023-09-30", "2023-10-31"),
    days = c( 30, 31, 31, 30, 31)
  )

# Build dataframe with all months
england_icb_discharge_data_after_may23 <- pmap_dfr(icb_df, scrape_data_after_may23)

# - Criteria to reside
icb_criteria_to_reside_after_may23 <-
  england_icb_discharge_data_after_may23 |>
  select(
    icb22_code_h = code,
    date,
    do_not_meet_criteria_to_reside = `Do not meet criteria to reside`
  )

# Replace old 'h' codes with new icb codes
england_icb_criteria_to_reside_after_may23 <- icb_criteria_to_reside_after_may23 |>
  left_join(lookup_icb_codes) |>
  relocate(icb22_code) |>
  select(-icb22_code_h)

# Join the data before may'23 with after may'23
england_icb_criteria_to_reside  <-
  bind_rows(
    england_icb_criteria_to_reside_before_may23,
    england_icb_criteria_to_reside_after_may23
  )

# Save output to data/ folder
usethis::use_data(england_icb_criteria_to_reside, overwrite = TRUE)

# - Number discharged
icb_discharged_patients_after_may23 <-
  england_icb_discharge_data_after_may23 |>
  select(
    icb22_code_h = code,
    date,
    discharged_total = `Number of patients discharged`,
  ) |>
  left_join(lookup_icb_codes) |>
  relocate(icb22_code) |>
  select(-icb22_code_h)

# Join the data before may'23 with after may'23
england_icb_discharged_patients  <-
  bind_rows(
    england_icb_discharged_patients_before_may23,
    icb_discharged_patients_after_may23
  )

# Save output to data/ folder
usethis::use_data(england_icb_discharged_patients, overwrite = TRUE)
