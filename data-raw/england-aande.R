# ---- Load libs ----
library(tidyverse)
library(readxl)
library(devtools)
library(httr2)
library(lubridate)

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Function to download and clean ----
scrape_data <- function(id, sheet, range, date, col_index) {
  # get url from query_urls table
  query_url <-
    query_urls |>
    filter(id == {{ id }}) |>
    pull(query)

  # download xls to as a temp file
  download <- tempfile(fileext = ".xls")

  request(query_url) |>
    req_perform(download)

  # read the xls file
  raw <-
    read_excel(
      download,
      sheet = sheet,
      range = range
    )

  # clean the df
  data <- raw |>
    select(all_of(col_index)) |>
    rename(
      code = 1,
      total_attendances = 2,
      attendances_over_4hours = 3,
      total_emergency_admissions = 4,
      emergency_admissions_over_4hours = 5
    ) |>
    slice(-1) |>
    filter(!is.na(code)) |>
    mutate_at(2:5, as.numeric) |>
    mutate(
      pct_attendance_over_4hours = round(attendances_over_4hours / total_attendances, 2),
      pct_emergency_admissions_over_4hours = round(emergency_admissions_over_4hours / total_emergency_admissions, 2),
      date = date
    )

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
    id = query_urls |> slice(which(query_urls$id == "nhs_accident_emergency_april_22"):which(query_urls$id == "nhs_accident_emergency_march_24")) |>
      pull(id),
    sheet = rep("System Level Data", 24),
    range = rep("B16:AB63", 24),
    date = c(
      "April 2022", "May 2022", "June 2022", "July 2022", "August 2022", "September 2022", "October 2022", "November 2022", "December 2022",
      "January 2023", "February 2023", "March 2023", "April 2023", "May 2023", "June 2023", "July 2023", "August 2023", "September 2023", "October 2023",
      "November 2023", "December 2023", "January 2024", "February 2024", "March 2024"
    ),
    col_index = c(
      rep(list(c(1, 6, 14, 24, 25)), 4),
      list(c(1, 7, 15, 25, 26)),
      rep(list(c(1, 6, 14, 24, 25)), 19)
    )
  )

# Build dataframe with all months
england_icb_accidents_emergency <- pmap_dfr(icb_df, scrape_data)

# Replace old 'h' codes with new icb codes
england_icb_accidents_emergency <- england_icb_accidents_emergency |>
  rename(icb22_code_h = code) |>
  left_join(lookup_icb_codes) |>
  relocate(icb22_code) |>
  select(-icb22_code_h)

# Save output to data/ folder
usethis::use_data(england_icb_accidents_emergency, overwrite = TRUE)

# ---- Provider level data ----
# - Iterate over all data sets and return as a dataframe

# Generate a dataframe with function arguments
trust_df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_accident_emergency")) |> pull(id),
    sheet = rep("Provider Level Data", 36),
    range = rep("B16:AB223", 36),
    date = c(
      "April 2021", "May 2021", "June 2021", "July 2021", "August 2021",
      "September 2021", "October 2021", "November 2021", "December 2021",
      "January 2022", "February 2022", "March 2022", "April 2022", "May 2022",
      "June 2022", "July 2022", "August 2022", "September 2022", "October 2022",
      "November 2022", "December 2022", "January 2023", "February 2023", "March 2023",
      "April 2023", "May 2023", "June 2023", "July 2023", "August 2023",
      "September 2023", "October 2023", "November 2023", "December 2023",
      "January 2024", "February 2024", "March 2024"
    ),
    col_index = rep(list(c(1, 7, 15, 25, 26)), 36)
  )

# Build dataframe with all months
england_trust_accidents_emergency <- pmap_dfr(trust_df, scrape_data)

# Include only NHS Trusts
england_trust_accidents_emergency <- england_trust_accidents_emergency |>
  filter(code %in% geographr::points_nhs_trusts22$nhs_trust22_code) |>
  rename(nhs_trust22_code = code)

# Replace data entry error with 0
england_trust_accidents_emergency <- england_trust_accidents_emergency |>
  mutate(pct_emergency_admissions_over_4hours = case_when(
    emergency_admissions_over_4hours == 29 & nhs_trust22_code == "RTQ" & date == "July 2021" ~ NA_integer_, TRUE ~ pct_emergency_admissions_over_4hours
  )) |>
  mutate(emergency_admissions_over_4hours = case_when(
    emergency_admissions_over_4hours == 29 & nhs_trust22_code == "RTQ" & date == "July 2021" ~ NA_integer_, TRUE ~ emergency_admissions_over_4hours
  ))

# Save output to data/ folder
usethis::use_data(england_trust_accidents_emergency, overwrite = TRUE)
