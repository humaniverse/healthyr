# ---- Load libs ----
library(tidyverse)
library(devtools)
library(geographr)
library(sf)
library(httr2)
library(readxl)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Function to scrape and clean data ----
scrape_data <- function(id, sheet, skip_rows) {
  # Download
  query_url <-
    query_urls |>
    filter(id == {{ id }}) |>
    pull(query)

  download <- tempfile()

  request(query_url) |>
    req_perform(download)

  # Read
  if (endsWith(query_url, ".csv")) {
    raw <- read_csv(download, skip = skip_rows)
  } else {
    raw <- read_excel(download, sheet = sheet, skip = skip_rows)
  }

  lookup_trusts <- geographr::boundaries_trusts_ni18 |>
    st_drop_geometry()

  # "Day Case" column removed due to missing values and duplicate values with "Total Day Cases".
  data <- raw |>
    rename(trust18_name = "HSC Trust") |>
    left_join(lookup_trusts, by = "trust18_name") |>
    select(
      trust18_code,
      date = "Quarter Ending",
      hospital = "Hospital",
      programme_of_care = "Programme of Care",
      specialty = "Specialty",
      total_available_beds = "Total Available Beds",
      average_available_beds = "Average Available Beds",
      total_occupied_beds = "Total Occupied Beds",
      average_occupied_beds = "Average Occupied Beds",
      total_inpatients = "Total Inpatients",
      total_day_case = "Total Day Case",
      elective_inpatient = "Elective Inpatient",
      non_elective_inpatient = "Non Elective Inpatient",
      regular_attenders = "Regular Attenders"
    ) |>
    mutate(date = as_date(as.character(date), format = c("%d/%m/%Y", "%Y-%m-%d")))

  return(data)
}

# Generate df with function arguments
df <-
  tibble(
    id = query_urls |>
      filter(str_detect(id, "^ni_beds")) |> pull(id),
    sheet = c(1, 1, 2),
    skip_rows = c(2, 0, 0)
  )

#---- Build data table ----
ni_beds <- pmap_dfr(df, scrape_data) |>
  unique()  # NOTE: data tables overlap, so removing duplicated rows

# Save output to data/ folder
usethis::use_data(ni_beds, overwrite = TRUE)
