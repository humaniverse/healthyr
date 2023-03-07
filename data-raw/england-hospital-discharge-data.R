# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Function to download and clean ----
scrape_data <- function(id, sheet, range, date_start, date_end, days) {
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
    rename(nhs_trust22_code = `Org Code`) |>
    select(-`Org Name`) |>
    pivot_longer(cols = !nhs_trust22_code)

  # Create a vector of dates and variable names to assign to raw data
  # Note: 121 Trusts across 4 variables
  dates <-
    seq(from = ymd(date_start), to = ymd(date_end), by = "days") |>
    rep(times = 121, each = 4)

  # Note: 30 days (of April) across 121 Trusts
  variables <-
    c(
      "Do not meet criteria to reside",
      "Discharged by 17:00",
      "Discharged between 17:01 and 23:59",
      "Number of patients remaining in hospital that do not meet criteria to reside"
    ) |>
    rep(times = days * 121)

  # Add dates and variable names and filter to variable of interest
  data <-
    long |>
    mutate(date = dates, name = variables) |>
    pivot_wider(names_from = "name", values_from = "value")

  return(data)
}

# ---- Iterate over all data sets and return as a dataframe ----
# Generate a dataframe with function arguments
df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_hospital_discharge")) |> pull(id),
    sheet = rep("Table 2", 10),
    range = c("C61:DT182", "C60:DX181", "C60:DT181", "C60:DX181", "C60:DX181", "C59:DT180", "C60:DX181", "C59:DT180", "C59:DX180", "C59:DX180"),
    date_start = c("2022-04-01", "2022-05-01", "2022-06-01", "2022-07-01", "2022-08-01", "2022-09-01", "2022-10-01", "2022-11-01", "2022-12-01", "2023-01-01"),
    date_end = c("2022-04-30", "2022-05-31", "2022-06-30", "2022-07-31", "2022-08-31", "2022-09-30", "2022-10-31", "2022-11-30", "2022-12-31", "2023-01-31"),
    days = c(30, 31, 30, 31, 31, 30, 31, 30, 31, 31)
  )

# Build dataframe with all months
england_discharge_data <- pmap_dfr(df, scrape_data)

# ---- Criteria to reside ----
criteria_to_reside <-
  england_discharge_data |>
  select(
    nhs_trust22_code,
    date,
    do_not_meet_criteria_to_reside = `Do not meet criteria to reside`
  )

# Two clear outliers exist in the data, presumably from data entry errors
criteria_to_reside |>
  arrange(desc(do_not_meet_criteria_to_reside))

# Replace outliers with previous value in series
england_criteria_to_reside <-
  criteria_to_reside |>
  mutate(
    do_not_meet_criteria_to_reside = case_when(
      nhs_trust22_code == "RXQ" & date == "2022-06-15" ~ NA_real_,
      nhs_trust22_code == "RH8" & date == "2022-05-22" ~ NA_real_,
      TRUE ~ do_not_meet_criteria_to_reside
    )
  ) |>
  fill(do_not_meet_criteria_to_reside)

# Save output to data/ folder
usethis::use_data(england_criteria_to_reside, overwrite = TRUE)

# ---- Number discharged ----
discharged_patients <-
  england_discharge_data |>
  select(
    nhs_trust22_code,
    date,
    discharged_by_1700 = `Discharged by 17:00`,
    discharged_between_1701_2359 = `Discharged between 17:01 and 23:59`
  )

england_discharged_patients <-
  discharged_patients |>
  rowwise() |>
  mutate(discharged_total = sum(c_across(starts_with("discharged")))) |>
  ungroup()

# Save output to data/ folder
usethis::use_data(england_discharged_patients, overwrite = TRUE)
