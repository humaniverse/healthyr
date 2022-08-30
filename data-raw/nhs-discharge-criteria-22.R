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
    filter(name == "Do not meet criteria to reside") |>
    pivot_wider(names_from = "name", values_from = "value") |>
    rename(do_not_meet_criteria_to_reside = `Do not meet criteria to reside`)

  return(data)
}

# ---- Iterate over all data sets and return as a dataframe ----
# Generate a dataframe with function arguments
df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_discharge")) |> pull(id),
    sheet = rep("Table 2", 4),
    range = c("C61:DT182", "C60:DX181", "C60:DT181", "C60:DX181"),
    date_start = c("2022-04-01", "2022-05-01", "2022-06-01", "2022-07-01"),
    date_end = c("2022-04-30", "2022-05-31", "2022-06-30", "2022-07-31"),
    days = c(30, 31, 30, 31)
  )

# Build dataframe with all months
nhs_discharge_criteria_22 <- pmap_dfr(df, scrape_data)

# Save output to data/ folder
usethis::use_data(nhs_discharge_criteria_22, overwrite = TRUE)