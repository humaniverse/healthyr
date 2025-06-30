library(tidyverse)
library(geographr)

urls <- c(
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/10/Daily-discharge-sitrep-monthly-data-webfile-June2024-revised.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/10/Daily-discharge-sitrep-monthly-data-webfile-July2024.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/10/Daily-discharge-sitrep-monthly-data-webfile-August2024-revised.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/11/Daily-discharge-sitrep-monthly-data-webfile-September-2024.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/11/Daily-discharge-sitrep-monthly-data-webfile-October2024-csv-1.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/12/Daily-discharge-sitrep-monthly-data-CSV-webfile-November2024.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Daily-discharge-sitrep-monthly-data-CSV-webfile-December2024.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Daily-discharge-sitrep-monthly-data-CSV-webfile-January2025-1.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/04/Daily-discharge-sitrep-monthly-data-CSV-webfile-February2025-revised.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/04/Daily-discharge-sitrep-monthly-data-CSV-webfile-March2025-1.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/05/Daily-discharge-sitrep-monthly-data-CSV-webfile-April2025-1.csv",
  "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/06/Daily-discharge-sitrep-monthly-data-CSV-webfile-May2025.csv"
)

raw <- urls |>
  map(
    \(x)
      read_csv(
        x,
        col_types = "cccccccccd",
        locale = locale(encoding = "windows-1252")
      )
  ) |>
  list_rbind()

england_delayed_discharge_reasons <- raw |>
  filter(`Metric Group` == "Delay reason") |>
  filter(`Org Code` %in% points_nhs_trusts22$nhs_trust22_code) |>
  mutate(Period = dmy(Period)) |>
  mutate(`Org Name` = str_to_title(`Org Name`)) |>
  mutate(`Org Name` = str_replace(`Org Name`, "Nhs", "NHS")) |>
  select(
    nhs_trust22_name = `Org Name`,
    nhs_trust22_code = `Org Code`,
    date = Period,
    delay_reason = Metric,
    delay_count = Value
  ) |>
  unique()

usethis::use_data(england_delayed_discharge_reasons, overwrite = TRUE)
