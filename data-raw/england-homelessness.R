library(tidyverse)
library(compositr)
library(readODS)
library(devtools)

# ---- Load internal sysdata.rda file with URLs ----
load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "england_homelessness") |>
  pull(query)

tf <- download_file(query_url, ".ods")

# ---- Households assessed as homeless ----
england_homeless_raw <- read_ods(tf, sheet = "A1", skip = 5)

england_homeless <- england_homeless_raw[, c(1, 18)]
names(england_homeless) <- c("ltla23_code", "Households assessed as homeless per (000s)")

# Keep only Local Authority Districts
england_homeless <-
  england_homeless |>
  as_tibble() |>
  filter(str_detect(ltla23_code, "^E0[6-9]")) |>
  mutate(
    `Households assessed as homeless per (000s)` = as.numeric(`Households assessed as homeless per (000s)`)
  )

# ---- Temporary accommodation ----
england_temp_accomm_raw <- read_ods(tf, sheet = "TA1", skip = 6)

england_temp_accomm <- england_temp_accomm_raw[, c(1, 2, 7)]
names(england_temp_accomm) <- c("ltla23_code", "ltla21_name", "Total number of households in TA per (000s)")

# Keep only Local Authority Districts
england_temp_accomm <-
  england_temp_accomm |>
  as_tibble() |>
  filter(str_detect(ltla23_code, "^E0[6-9]")) |>
  mutate(`Households in temporary accommodation per 1,000` = as.numeric(`Total number of households in TA per (000s)`)) |>
  select(ltla23_code, `Households in temporary accommodation per 1,000`)

# ---- Combine and save data ----
england_homelessness <-
  england_homeless |>
  left_join(england_temp_accomm)

usethis::use_data(england_homelessness, overwrite = TRUE)
