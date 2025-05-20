library(tidyverse)
library(lubridate)
library(devtools)
library(readxl)

# ---- Load internal sysdata.rda file with URLs ----
load_all(".")

# ---- Inpatient and Day Case waiting times ----
query_url_inpatient <-
  query_urls |>
  filter(id == "ni_inpatient") |> # Each data release is cumulative
  pull(query)

tf <- tempfile()
download.file(query_url_inpatient, tf)
ni_inpatient <- read_excel(tf, sheet = "pre-encompass", guess_max = 10000)

# ---- Outpatient waiting times ----
query_url_outpatient <-
  query_urls |>
  filter(id == "ni_outpatient") |> # Each data release is cumulative
  pull(query)

tf <- tempfile()
download.file(query_url_outpatient, tf)
ni_outpatient <- read_excel(tf, sheet = "pre-encompass", guess_max = 10000)

# ---- Wrangle data since 2019 ----
# Patients waiting for admission to a Day Case Procedure Centre (DPC) are
# included in these statistics.As these services are managed on a regional
# basis, patients are not allocated as waiting at a particular HSC Trust, but
# instead reported separately against DPC's
ni_inpatient_sum <-
  ni_inpatient |>
  mutate(
    Date = ymd(`Quarter Ending`),
    Month = month.abb[month(Date)],
    Year = year(Date)
  ) |>
  mutate(`HSC Trust` = case_when(
    `HSC Trust` == "DPC" ~ "Day Case Procedure Centre",
    TRUE ~ `HSC Trust`
  )) |>
  filter(Year >= 2019) |>
  select_if(~ !all(is.na(.))) |>
  group_by(`HSC Trust`, Year, Month, Specialty) |>
  summarise(
    `Total waiting > 52 weeks` =
      sum(`> 52 - 65 weeks`, na.rm = TRUE) +
        sum(`> 65 - 78 weeks`, na.rm = TRUE) +
        sum(`> 78 - 91 weeks`, na.rm = TRUE) +
        sum(`> 91 - 104 weeks`, na.rm = TRUE) +
        sum(`> 104 weeks`, na.rm = TRUE),
    `Total waiting > 21 weeks` =
      sum(`> 21 - 26 weeks`, na.rm = TRUE) +
        sum(`> 26-52 weeks`, na.rm = TRUE) +
        sum(`> 52 - 65 weeks`, na.rm = TRUE) +
        sum(`> 65 - 78 weeks`, na.rm = TRUE) +
        sum(`> 78 - 91 weeks`, na.rm = TRUE) +
        sum(`> 91 - 104 weeks`, na.rm = TRUE) +
        sum(`> 104 weeks`, na.rm = TRUE),
    `Total waiting > 13 weeks` =
      sum(`> 13 - 21 weeks`, na.rm = TRUE) +
        sum(`> 21 - 26 weeks`, na.rm = TRUE) +
        sum(`> 26-52 weeks`, na.rm = TRUE) +
        sum(`> 52 - 65 weeks`, na.rm = TRUE) +
        sum(`> 65 - 78 weeks`, na.rm = TRUE) +
        sum(`> 78 - 91 weeks`, na.rm = TRUE) +
        sum(`> 91 - 104 weeks`, na.rm = TRUE) +
        sum(`> 104 weeks`, na.rm = TRUE),
    `Total waiting < 13 weeks` =
      sum(`0 - 6 weeks`, na.rm = TRUE) +
        sum(`> 6 - 13 weeks`, na.rm = TRUE),
    Total =
      sum(Total, na.rm = TRUE)
  )

ni_outpatient_sum <-
  ni_outpatient |>
  # Remove commas from the data columns
  mutate(across(`0 - 6 weeks`:`Total Waiting`, ~ as.numeric(str_remove(.x, ",")))) %>%
  mutate(
    Date = ymd(`Quarter Ending`),
    Month = month.abb[month(Date)],
    Year = year(Date)
  ) |>
  filter(Year >= 2019) |>
  select_if(~ !all(is.na(.))) |>
  group_by(`HSC Trust`, Year, Month, Specialty) |>
  summarise(
    `Total waiting > 52 weeks` =
      sum(`>52 - 65 weeks`, na.rm = TRUE) +
        sum(`>65 - 78 weeks`, na.rm = TRUE) +
        sum(`>78 - 91 weeks`, na.rm = TRUE) +
        sum(`>91 - 104 weeks`, na.rm = TRUE) +
        sum(`>104 weeks`, na.rm = TRUE),
    `Total waiting > 18 weeks` =
      sum(`>18 - 26 weeks`, na.rm = TRUE) +
        sum(`>26 - 39 weeks`, na.rm = TRUE) +
        sum(`>39 - 52 weeks`, na.rm = TRUE) +
        sum(`>52 - 65 weeks`, na.rm = TRUE) +
        sum(`>65 - 78 weeks`, na.rm = TRUE) +
        sum(`>78 - 91 weeks`, na.rm = TRUE) +
        sum(`>91 - 104 weeks`, na.rm = TRUE) +
        sum(`>104 weeks`, na.rm = TRUE),
    `Total waiting < 18 weeks` =
      sum(`0 - 6 weeks`, na.rm = TRUE) +
        sum(`>6 - 9 weeks`, na.rm = TRUE) +
        sum(`>9 - 12 weeks`, na.rm = TRUE) +
        sum(`>12 - 15 weeks`, na.rm = TRUE) +
        sum(`>15 - 18 weeks`, na.rm = TRUE),
    Total =
      sum(`Total Waiting`, na.rm = TRUE)
  )

ni_waits <-
  bind_rows(
    ni_outpatient_sum,
    ni_inpatient_sum %>% rename(`Total waiting > 18 weeks` = `Total waiting > 21 weeks`)
  ) %>%
  group_by(`HSC Trust`, Year, Month, Specialty) %>%
  summarise(
    `Total waiting > 52 weeks` = sum(`Total waiting > 52 weeks`, na.rm = TRUE),
    `Total waiting > 18 weeks` = sum(`Total waiting > 18 weeks`, na.rm = TRUE),
    `Total waiting` = sum(Total, na.rm = TRUE)
  )

ni_rtt_hsct <-
  ni_waits |>
  mutate(date = ym(paste0(Year, Month))) |>
  select(
    hsct22_name = `HSC Trust`,
    date,
    year = Year,
    month = Month,
    specialty = Specialty,
    waits_over_18_weeks = `Total waiting > 18 weeks`,
    waits_over_52_weeks = `Total waiting > 52 weeks`,
    total_waits = `Total waiting`
  ) |>
  ungroup()

# Save output to data/ folder
usethis::use_data(ni_rtt_hsct, overwrite = TRUE)
