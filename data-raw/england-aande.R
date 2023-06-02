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
    select(all_of(col_index))  |> # select relevant columns
    rename(code = 1, total_attendances = 2, attendances_over_4hours = 3, total_emergency_admissions = 4, emergency_admissions_over_4hours = 5) |> # rename columns
    slice(-1) |> # remove first row
    filter(!is.na(code)) |> # remove NAs
    mutate_at(2:5, as.numeric) |> # change cols datatype to numeric
    mutate(pct_attendance_over_4hours = round(attendances_over_4hours / total_attendances, 2),
           pct_emergency_admissions_over_4hours = round(emergency_admissions_over_4hours/ total_emergency_admissions, 2),
           date = date
           ) # add percentage and date columns

  return(data)
}

# ---- ICB level data ----
# - Iterate over all data sets and return as a dataframe

# Generate a dataframe with function arguments
icb_df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_accident_emergency")) |> pull(id),
    sheet = rep("System Level Data", 12),
    range = rep("B16:AA61", 12),
    date = c("April 2022", "May 2022", "June 2022", "July 2022", "August 2022", "September 2022", "October 2022", "November 2022", "December 2022", "January 2023", "February 2023", "March 2023"),
    col_index = rep(list(c(1,6,14,24,25)), 12)
  )

# Build dataframe with all months
england_icb_accidents_emergency <- pmap_dfr(icb_df, scrape_data)

# Save output to data/ folder
usethis::use_data(england_icb_accidents_emergency, overwrite = TRUE)

# ---- Provider level data ----
# - Iterate over all data sets and return as a dataframe

# Generate a dataframe with function arguments
trust_df <-
  tibble(
    id = query_urls |> filter(str_detect(id, "^nhs_accident_emergency")) |> pull(id),
    sheet = rep("Provider Level Data", 12),
    range = rep("B16:AB223", 12),
    date = c("April 2022", "May 2022", "June 2022", "July 2022", "August 2022", "September 2022", "October 2022", "November 2022", "December 2022", "January 2023", "February 2023", "March 2023"),
    col_index = rep(list(c(1,7,15,25,26)), 12)
  )

# Build dataframe with all months
england_trust_accidents_emergency <- pmap_dfr(trust_df, scrape_data) 

# Save output to data/ folder
usethis::use_data(england_trust_accidents_emergency, overwrite = TRUE)

