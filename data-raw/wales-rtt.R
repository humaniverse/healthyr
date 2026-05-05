library(tidyverse)
library(lubridate)
library(httr2)

# ---- Load internal sysdata.rda file with URL's ----
devtools::load_all()

# ---- Download and read ----
id <- "6bd7d5c9-844e-4e7c-85ba-7256e39f7214"

tf <- tempfile(fileext = ".csv")

request(paste0(
  "https://api.stats.gov.wales/v1/",
  id,
  "/download/csv"
)) |>
  req_perform(path = tf)

wales_raw <- readr::read_csv(tf)

# query_url <-
#   query_urls |>
#   filter(id == "wales_rtt") |>
#   pull(query)
#
# download <- tempfile(fileext = ".zip")
# request(query_url) |> req_perform(download)
# unzip(download, exdir = tempdir())
#
# wales_raw <- read_csv(file.path(tempdir(), "HLTH0079.csv"))

# ---- Clean ----
wales_waits <-
  wales_raw |>
  as_tibble() |>
  janitor::clean_names() |>
  mutate(
    date = lubridate::my(date),
    weeks_waiting_num = stringr::str_extract(weeks_waiting, "\\d+") |> as.integer(),
    data_values = as.integer(data_values)
  ) |>
  filter(
    lubridate::year(date) >= 2019,
    age_group == "Total"
  ) |>
  select(
    lhb22_name = local_health_board_provider,
    date,
    pathway_stage = stage_of_pathway,
    weeks_waiting,
    weeks_waiting_num,
    data_values
  )

wales_waits_18 <-
  wales_waits |>
  filter(weeks_waiting_num >= 18) |>
  group_by(lhb22_name, date, pathway_stage) |>
  summarise(waits_over_18_weeks = sum(data_values, na.rm = TRUE), .groups = "drop")

wales_waits_53 <-
  wales_waits |>
  filter(weeks_waiting_num >= 53) |>
  group_by(lhb22_name, date, pathway_stage) |>
  summarise(waits_over_53_weeks = sum(data_values, na.rm = TRUE), .groups = "drop")

wales_waits_total <-
  wales_waits |>
  filter(weeks_waiting == "Total") |>
  group_by(lhb22_name, date, pathway_stage) |>
  summarise(total_waits = sum(data_values, na.rm = TRUE), .groups = "drop")

wales_rtt_lhb <-
  wales_waits |>
  distinct(lhb22_name, date, pathway_stage) |>
  left_join(wales_waits_18, by = c("lhb22_name", "date", "pathway_stage")) |>
  left_join(wales_waits_53, by = c("lhb22_name", "date", "pathway_stage")) |>
  left_join(wales_waits_total, by = c("lhb22_name", "date", "pathway_stage")) |>
  mutate(
    waits_over_18_weeks = tidyr::replace_na(waits_over_18_weeks, 0L),
    waits_over_53_weeks = tidyr::replace_na(waits_over_53_weeks, 0L),
    total_waits = tidyr::replace_na(total_waits, 0L)
  )

# colnames(wales_raw) <- sub("_STR$|_INT$", "", colnames(wales_raw))
#
# wales_waits <-
#   wales_raw |>
#   as_tibble() |>
#   mutate(date = my(paste0(Date_ItemName_ENG))) |>
#   filter(year(date) >= 2019) |>
#   select(
#     lhb22_code = LHBProvider_Code,
#     lhb22_name = LHBProvider_ItemName_ENG,
#     date,
#     pathway_stage = Stageofpathway_ItemName_ENG,
#     Weekswaiting_Code,
#     Weekswaiting_ItemName_ENG,
#     Data
#   ) |>
#   # Extract number from the waiting code
#   mutate(Weekswaiting_Code = str_extract(Weekswaiting_Code, "^[0-9]+") |> as.integer()) |>
#   # Keep only waits >= 18 weeks
#   # filter(Weekswaiting_Code >= 18) |>
#   mutate(Data = as.integer(Data))
#
# wales_waits_18 <-
#   wales_waits |>
#   filter(Weekswaiting_Code >= 18) |>
#   group_by(lhb22_code, lhb22_name, date, pathway_stage) |>
#   summarise(waits_over_18_weeks = sum(Data, na.rm = TRUE)) |>
#   ungroup()
#
# wales_waits_53 <-
#   wales_waits |>
#   filter(Weekswaiting_Code >= 53) |>
#   group_by(lhb22_code, lhb22_name, date, pathway_stage) |>
#   summarise(waits_over_53_weeks = sum(Data, na.rm = TRUE)) |>
#   ungroup()
#
# wales_waits_total <- # All waits
#   wales_waits |>
#   group_by(lhb22_code, lhb22_name, date, pathway_stage) |>
#   summarise(total_waits = sum(Data, na.rm = TRUE)) |>
#   ungroup()
#
# # Make dataframe for joining
# wales_rtt_lhb <-
#   wales_waits |>
#   distinct(lhb22_code, lhb22_name, date, pathway_stage)
#
# wales_rtt_lhb <-
#   wales_rtt_lhb |>
#   left_join(wales_waits_18) |>
#   left_join(wales_waits_53) |>
#   left_join(wales_waits_total)

# ---- Save output to data/ folder ----
usethis::use_data(wales_rtt_lhb, overwrite = TRUE)
