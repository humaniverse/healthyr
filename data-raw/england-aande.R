# ---- Load libs ----
library(tidyverse)
library(devtools)
library(lubridate)
library(rvest)
library(stringr) 

# # Read html
# url <- "https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/ae-attendances-and-emergency-admissions-2022-23/"
# html <- read_html(url)
# 
# # Get urls of xls files
# links <- html |>
#   html_elements("a") |>
#     html_attr("href") |>
#       str_subset("\\.xls") |> 
#         str_subset("AE")
# 
# destinations <- c("/Users/jennatan/code/jennajt/brc/scraping/example.csv")
# # download and save file
# destfile <- "/Users/jennatan/code/jennajt/brc/scraping/example.csv"
# download.file("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/05/March-2023-AE-by-provider-D6Ni9-revised-110523.xls", destfile)
# df <- read_excel('example.csv')

# read
query_url <-
  query_urls |>
  filter(id == "nhs_accident_emergency_march_23") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

# Read
raw <-
  read_excel(
    #path = "/Users/jennatan/Downloads/March.xls",
    download,
    sheet = "System Level Data",
    range = "B16:AA222"
  )

preproc <- raw |>
  select(1,6,14,24,25)  |> 
  rename(code = 1, total_attendances = 2, attendances_over_4hours = 3, total_emergency_admissions = 4, emergency_admissions_over4hours = 5) |>
  slice(-1) |>
  filter(!is.na(code)) |>
  mutate(pct_attendance_over_4hours = round(attendances_over_4hours / total_attendances, 2),
         pct_emergency_admissions_over4hours = round(emergency_admissions_over4hours/ total_emergency_admissions, 2),
         date = "March 2023"
         )

    
    