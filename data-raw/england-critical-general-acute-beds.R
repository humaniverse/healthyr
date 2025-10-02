# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Function to download and clean ----
scrape_data <- function(id, sheet, header1, header2, range, date) {
  # Download
  query_url <-
    query_urls |>
    filter(id == {{ id }}) |>
    pull(query)

  download <- tempfile(fileext = ".xlsx")

  request(query_url) |>
    req_perform(download)

  # Read
  colnames1 <- as.character(read_excel(download, sheet = sheet, range = header1, col_names = FALSE))
  colnames2 <- as.character(read_excel(download, sheet = sheet, range = header2, col_names = FALSE))
  colnames  <- if_else(colnames2 == "NA", colnames1, colnames2)
  colnames[colnames == "Org Code"] <- "Code"
  raw_trusts <-
    read_excel(
      download,
      sheet = sheet,
      range = range,
      col_names = colnames
    )
  cat("reading", query_url, "\n")

  data <-
    raw_trusts |>
    select(
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
      neonatal_intensive_care_bed_available = "Neonatal intensive care beds available",
      neonatal_intensive_care_bed_occupied = "Neonatal intensive care beds occupied",
      neonatal_intensive_care_occupancy_rate = "Neonatal intensive care occupancy rate"
    ) |>
    mutate(date = date) |>
    relocate(date, .after = nhs_trust22_code) |>
    mutate_at(c(3:20), as.numeric)
  return(data)
}

# ---- Iterate over all data sets and return as a dataframe ----
# Generate a dataframe with function arguments
# April 2023 does not have the "Code" column name
# Format of data changes from August '23
df <-
  tibble(
    id = query_urls |>
      slice(which(query_urls$id == "nhs_critical_general_acute_beds_april_22"):
            which(query_urls$id == "nhs_critical_general_acute_beds_august_25")) |>
      filter(!(date %in% c("April 2023"))) |>
      pull(id),
    sheet = if_else(1:40 == 21, 3, 2),  # NOTE: January 2023 had 3 sheets
    header1 = c(rep("B15:V15", 7), rep("B15:AB15", 8), rep("B15:AI15", 25)),
    header2 = c(rep("B26:V26", 7), rep("B26:AB26", 8), rep("B69:AI69", 25)),
    range = c(rep("B27:V163", 7), rep("B27:AB163", 8), rep("B70:AI205", 25)),
    date = c(
      "April 2022",
      "May 2022",
      "June 2022",
      "July 2022",
      "August 2022",
      "September 2022",
      "October 2022",
      "November 2022",
      "December 2022",
      "January 2023",
      "February 2023",
      "March 2023",
      "May 2023",
      "June 2023",
      "July 2023",
      "August 2023",
      "September 2023",
      "October 2023",
      "November 2023",
      "December 2023",
      "January 2024",
      "February 2024",
      "March 2024",
      "April 2024",
      "May 2024",
      "June 2024",
      "July 2024",
      "August 2024",
      "September 2024",
      "October 2024",
      "November 2024",
      "December 2024",
      "January 2025",
      "February 2025",
      "March 2025",
      "April 2025",
      "May 2025",
      "June 2025",
      "July 2025",
      "August 2025"
    )
  )

# Build dataframe with all months except April 2023
england_critical_general_acute_beds_incomplete <- pmap_dfr(df, scrape_data)

# ---- Handle the April 2023 exception ----
query_url_april23 <-
  query_urls |>
  filter(id == "nhs_critical_general_acute_beds_april_23") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url_april23) |>
  req_perform(download)

raw_april23 <-
  read_excel(
    download,
    sheet = 2,
    range = "D26:AB163"
  )

data_april23 <-
  raw_april23 |>
  select(
    nhs_trust22_code = "...1",
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
    neonatal_intensive_care_bed_available = "Neonatal intensive care beds available",
    neonatal_intensive_care_bed_occupied = "Neonatal intensive care beds occupied",
    neonatal_intensive_care_occupancy_rate = "Neonatal intensive care occupancy rate"
  ) |>
  mutate(date = "April 2023") |>
  relocate(date, .after = nhs_trust22_code)

england_critical_general_acute_beds <-
  bind_rows(
    england_critical_general_acute_beds_incomplete,
    data_april23
  ) |>
  drop_na(nhs_trust22_code) |>
  arrange(my(date), nhs_trust22_code)


# Save output to data/ folder
usethis::use_data(england_critical_general_acute_beds, overwrite = TRUE)
