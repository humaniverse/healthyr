# ---- Load ----
library(statswalesr)
library(jsonlite)
library(httr)
library(dplyr)
library(readr)
library(tidyr)
library(lubridate)
library(janitor)

# ---- Function to download data from Stats Wales website ----
raw <- statswales_get_dataset("hlth0310")
colnames(raw) <- sub("_STR$|_DEC$", "", colnames(raw))

# Clean the data
wales_beds <- raw |>
  # Filter to only include data from Jan 2021 and only include high level specialty categories
  filter(Month_Code >= "202101" & (Specialty_Hierarchy == "0" | is.na(Specialty_Hierarchy))) |>
  # Renaming measure variable names
  mutate(
    measure = case_when(
      Measure_ItemName_ENG == "Average daily occupied beds" ~ "average_daily_beds_occupied",
      Measure_ItemName_ENG == "Average daily available beds" ~ "average_daily_beds_available",
      Measure_ItemName_ENG == "Percentage occupancy" ~ "average_beds_occupancy_rate"
    )
  ) |>
  select(
    date = Month_ItemName_ENG,
    hospital_code = Organisation_Code,
    hospital_name = Organisation_ItemName_ENG,
    hospital_sortcode = Organisation_SortOrder,
    specialty_name = Specialty_ItemName_ENG,
    measure, Data
  ) |>
  pivot_wider(names_from = c(specialty_name, measure), values_from = Data, values_fn = mean) |> # handle duplication using mean
  clean_names()

# Select certain specialisms only
wales_critical_general_acute_beds <- wales_beds |>
  select(starts_with(c("date", "hosp", "all_sp", "surgical_acute", "medical_acute", "mental", "geriatric", "maternity")))

# Select hospitals and wales only
wales_hospitals_critical_general_acute_beds <- wales_critical_general_acute_beds |>
  filter(is.na(hospital_sortcode) | hospital_sortcode == "0") |>
  select(-hospital_sortcode) |>
  pivot_longer(
    cols = c(ends_with("average_daily_beds_available"), ends_with("average_daily_beds_occupied"), ends_with("average_beds_occupancy_rate")),
    names_to = c("specialism", "measure"),
    names_sep = "_average_",
    values_to = c("value"),
    values_drop_na = TRUE
  ) |>
  pivot_wider(names_from = "measure")  |>
  arrange(hospital_name, specialism)

# Save output to data/ folder
usethis::use_data(wales_hospitals_critical_general_acute_beds, overwrite = TRUE)

# Select health boards only
wales_health_board_critical_general_acute_beds <- wales_critical_general_acute_beds |>
  filter(hospital_sortcode %in% 1:9) |>
  select(-hospital_sortcode) |>
  rename(health_board_code = hospital_code, health_board_name = hospital_name) |>
  pivot_longer(
    cols = c(ends_with("average_daily_beds_available"), ends_with("average_daily_beds_occupied"), ends_with("average_beds_occupancy_rate")),
    names_to = c("specialism", "measure"),
    names_sep = "_average_",
    values_to = c("value"),
    values_drop_na = TRUE
  ) |>
  pivot_wider(names_from = "measure", values_from = "value") |>
  arrange(health_board_name, specialism)

# Save output to data/ folder
usethis::use_data(wales_health_board_critical_general_acute_beds, overwrite = TRUE)
