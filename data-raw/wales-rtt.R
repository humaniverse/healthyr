library(tidyverse)
library(lubridate)
library(httr2)

# ---- Load internal sysdata.rda file with URL's ----
devtools::load_all()

# ---- Download and read ----
query_url <-
  query_urls |>
  filter(id == "wales_rtt") |>
  pull(query)

download <- tempfile(fileext = ".zip")
request(query_url) |> req_perform(download)
unzip(download, exdir = tempdir())

wales_raw <- read_csv(file.path(tempdir(), "HLTH0079.csv"))

# ---- Clean ----
colnames(wales_raw) <- sub("_STR$|_INT$", "", colnames(wales_raw))

wales_waits <-
  wales_raw |>
  as_tibble() |>
  mutate(date = my(paste0(Date_ItemName_ENG))) |>
  filter(year(date) >= 2019) |>
  select(
    lhb22_code = LHBProvider_Code,
    lhb22_name = LHBProvider_ItemName_ENG,
    date,
    pathway_stage = Stageofpathway_ItemName_ENG,
    Weekswaiting_Code,
    Weekswaiting_ItemName_ENG,
    Data
  ) |>
  # Extract number from the waiting code
  mutate(Weekswaiting_Code = str_extract(Weekswaiting_Code, "^[0-9]+") |> as.integer()) |>
  # Keep only waits >= 18 weeks
  # filter(Weekswaiting_Code >= 18) |>
  mutate(Data = as.integer(Data))

wales_waits_18 <-
  wales_waits |>
  filter(Weekswaiting_Code >= 18) |>
  group_by(lhb22_code, lhb22_name, date, pathway_stage) |>
  summarise(waits_over_18_weeks = sum(Data, na.rm = TRUE)) |>
  ungroup()

wales_waits_53 <-
  wales_waits |>
  filter(Weekswaiting_Code >= 53) |>
  group_by(lhb22_code, lhb22_name, date, pathway_stage) |>
  summarise(waits_over_53_weeks = sum(Data, na.rm = TRUE)) |>
  ungroup()

wales_waits_total <- # All waits
  wales_waits |>
  group_by(lhb22_code, lhb22_name, date, pathway_stage) |>
  summarise(total_waits = sum(Data, na.rm = TRUE)) |>
  ungroup()

# Make dataframe for joining
wales_rtt_lhb <-
  wales_waits |>
  distinct(lhb22_code, lhb22_name, date, pathway_stage)

wales_rtt_lhb <-
  wales_rtt_lhb |>
  left_join(wales_waits_18) |>
  left_join(wales_waits_53) |>
  left_join(wales_waits_total)

# ---- Save output to data/ folder ----
usethis::use_data(wales_rtt_lhb, overwrite = TRUE)
