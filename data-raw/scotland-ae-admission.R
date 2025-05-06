#--- init ----------------------------------------------------------------------

library(httr2)
library(readxl)
library(tidyverse)


#--- download ------------------------------------------------------------------

# NOTE: this sheet is used only for obtaining hospital codes
url <- "https://publichealthscotland.scot/media/32304/2025-04-01-ae-monthly-attendance-and-waiting-times.xlsx"
tf  <- tempfile()

req_perform(request(url), tf)

hcs <- read_excel(tf, sheet = "Hospitals")


# Now download the data for admissions
url <- "https://publichealthscotland.scot/media/32308/2025-04-01-dischargedestination.xlsx"
tf  <- tempfile()

req_perform(request(url), tf)

raw <- read_excel(tf, sheet = "Hospital")


#--- prepare -------------------------------------------------------------------

hcs <- hcs |>
  filter(year(MonthEndingDate) > 2018) |>
  select(LocationCode, LocationName) |>
  mutate(LocationName = str_remove(LocationName, " \\-.*")) |>
  mutate(LocationName = str_replace(LocationName, "Links Health Centre", "Links Health Centre - Montrose")) |>
  mutate(LocationName = str_replace(LocationName, "Royal Hospital for Children and Young People Edinburgh", "Royal Hospital for Children and Young People (Edinburgh)")) |>
  mutate(LocationName = str_replace(LocationName, "West Glasgow MIU", "West Glasgow Ambulatory Care Hospital")) |>
  unique() |>
  mutate(id = tolower(LocationName))  # create an id to join by

scotland_ae_admission <- raw |>
  mutate(id = tolower(Hospital)) |>
  left_join(hcs, by = "id") |> 
  select(hospital_code = "LocationCode",
         hospital_name = "Hospital",
         date          = "Month",
         admission     = "Discharge",
         age           = "Age",
         attendances   = "Attendances"
         )


#--- save ----------------------------------------------------------------------

usethis::use_data(scotland_ae_admission, overwrite = TRUE)
