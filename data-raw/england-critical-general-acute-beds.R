# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Function to download and clean ----
scrape_data <- function(id, sheet, range, date) {
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

  data <-
    raw_trusts |>
    rename(
      nhs_trust22_code = "Code",
      general_acute_beds_available = "G&A beds available",
      general_acute_beds_occupied = "G&A beds occupied",
      general_acute_beds_occupancy_rate = "G&A occupancy rate",
      adult_general_acute_beds_available = "Adult G&A beds available",
      adult_general_acute_beds_occupied = "Adult G&A beds occupied",
      adult_general_acute_beds_occupancy_rate = "Adult G&A occupancy rate",
      paediatric_general_acute_beds_available = "Paediatric G&A beds available",
      paediatric_general_acute_beds_occupied = "Paediatric G&A beds occupied",
      paediatric_general_acute_beds_occupancy_rate = "Paediatric G&A occupancy rate",
      adult_critical_care_beds_available = "Adult critical care beds available",
      adult_critical_care_beds_occupied = "Adult critical care beds occupied",
      adult_critical_care_occupancy_rate = "Adult critical care occupancy rate",
      paediatric_intensive_cared_beds_available = "Paediatric intensive care beds available",
      paediatric_intensive_cared_beds_occupied = "Paediatric intensive care beds occupied",
      paediatric_intensive_cared_occupancy_rate = "Paediatric intensive care occupancy rate",
      neonatal_intensive_care_bed_avaialble = "Neonatal intensive care beds available",
      neonatal_intensive_care_bed_occupied = "Neonatal intensive care beds occupied",
      neonatal_intensive_care_occupancy_rate = "Neonatal intensive care occupancy rate"
    ) |>
    mutate(date = date) |>
    relocate(date, .after = nhs_trust22_code)

  return(data)
}

# ---- Iterate over all data sets and return as a dataframe ----
# Generate a dataframe with function arguments
df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_critical_general_acute_beds")) |> pull(id),
    sheet = rep(2, 7),
    range = rep("D26:V163", 7),
    date = c("April 2022", "May 2022", "June 2022", "July 2022", "August 2022", "September 2022", "October 2022")
  )

# Build dataframe with all months
england_critical_general_acute_beds <- pmap_dfr(df, scrape_data)

# Save output to data/ folder
usethis::use_data(england_critical_general_acute_beds, overwrite = TRUE)
