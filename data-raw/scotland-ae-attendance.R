#--- init ----------------------------------------------------------------------

library(httr2)
library(readxl)
library(tidyverse)


#--- download ------------------------------------------------------------------

url <- "https://publichealthscotland.scot/media/32304/2025-04-01-ae-monthly-attendance-and-waiting-times.xlsx"
tf  <- tempfile()

req_perform(request(url), tf)

raw <- read_excel(tf, sheet = "Hospitals")


#--- prepare -------------------------------------------------------------------

scotland_ae_attendance <- raw |>
  filter(AttendanceCategory == "All") |>
  select(hospital_code  = "LocationCode",
         hospital_name  = "LocationName",
         date           = "MonthEndingDate",
         attendances    = "NumberOfAttendancesAll",
         within_4_hours = "NumberWithin4HoursAll",
         over_4_hours   = "NumberOver4HoursAll"
         ) |>
  mutate(date = ymd(date)) |>
  arrange(date, hospital_code)


#--- save ----------------------------------------------------------------------

usethis::use_data(scotland_ae_attendance, overwrite = TRUE)
