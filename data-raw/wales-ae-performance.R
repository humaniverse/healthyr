library(tidyverse)
library(readxl)
library(httr2)
# library(statswalesr)

# ---- Load internal sysdata.rda file with URL's ----
devtools::load_all()

# ---- Download and read ----
query_url <-
  query_urls |>
  filter(id == "wales_ae_waiting_times") |>
  pull(query)

download <- tempfile(fileext = ".zip")
request(query_url) |> req_perform(download)
unzip(download, exdir = tempdir())

raw <- read_csv(file.path(tempdir(), "HLTH0034.csv"))

wales_ae_performance <- raw |>
  select(
    hospital_code = Hospital_Code_STR,
    hospital_department = Hospital_ItemName_ENG_STR,
    date = Date_Code_STR,
    performance_measure = Measure_ItemName_ENG_STR,
    performance_target = Target_Code_STR
  ) |>
  mutate(date = ym(str_remove_all(date, "m")))

usethis::use_data(wales_ae_performance, overwrite = TRUE)

# ---- Pre StatsWales website update ----
# raw <- statswales_get_dataset("HLTH0034")
#
# wales_ae_performance <- raw |>
#   select(
#     hospital_code = Hospital_Code_STR,
#     hospital_department = Hospital_ItemName_ENG_STR,
#     date = Date_Code_STR,
#     performance_measure = Measure_ItemName_ENG_STR,
#     performance_target = Target_Code_STR
#   ) |>
#   mutate(date = ym(str_remove_all(date, "m")))
#
# usethis::use_data(wales_ae_performance, overwrite = TRUE)
