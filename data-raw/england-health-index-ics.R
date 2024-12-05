# ---- Load libs ----
library(tidyverse)
library(readxl)
library(httr2)

# ---- Load internal sysdata.rda file with URL's ----
pkgload::load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "england_health_index_ics") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

# ---- Read sheets ----
overall_scores_raw <- read_excel(
  download,
  sheet = "Table_2_Index_scores",
  range = "A3:I45"
)

sheet_names <- paste0("Table_", seq(3, 9), "_", seq(2021, 2015), "_Index")
index_names <- paste0("index_", seq(2021, 2015))

indices <- map(
  .x = set_names(sheet_names, index_names),
  .f = \(x) read_excel(download, sheet = x, range = "A5:BW47")
)

# ---- Clean data ----
overall_scores <- overall_scores_raw |>
  rename(icb22_code = `Area Code`, icb22_name = `Area Name`) |>
  pivot_longer(
    cols = `2015`:`2021`, names_to = "year", values_to = "overall_score"
  ) |>
  mutate(year = as.integer(year))

domain_scores <- map2(
  .x = indices,
  .y = seq(2021, 2015),
  .f = \(x, y) {
    x |>
      rename(icb22_code = `Area Code`, icb22_name = `Area Name`) |>
      select(starts_with("icb22_"), ends_with("Domain")) |>
      janitor::clean_names() |>
      mutate(year = y)
  }
) |>
  list_rbind()

england_health_index_ics <- left_join(overall_scores, domain_scores)

england_health_index_ics_subdomains <- map2(
  .x = indices,
  .y = seq(2021, 2015),
  .f = \(x, y) {
    x |>
      rename(icb22_code = `Area Code`, icb22_name = `Area Name`) |>
      select(starts_with("icb22_"), matches("\\[(Pe|Pl|L)\\]$")) |>
      rename_with(~ str_remove(., " \\[.*\\]$")) |>
      janitor::clean_names() |>
      pivot_longer(cols = !starts_with("icb22_"), names_to = "sub_domain") |>
      mutate(year = y) |>
      relocate(year, .after = "icb22_name")
  }
) |>
  list_rbind()

england_health_index_ics_indicators <- map2(
  .x = indices,
  .y = seq(2021, 2015),
  .f = \(x, y) {
    x |>
      rename(icb22_code = `Area Code`, icb22_name = `Area Name`) |>
      select(!c(matches("\\[(Pe|Pl|L)\\]$"), matches("Domain$"))) |>
      rename_with(~ str_remove(., " \\[.*\\]$")) |>
      janitor::clean_names() |>
      pivot_longer(cols = !starts_with("icb22_"), names_to = "indicator") |>
      mutate(year = y) |>
      relocate(year, .after = "icb22_name")
  }
) |>
  list_rbind()

usethis::use_data(england_health_index_ics, overwrite = TRUE)
usethis::use_data(england_health_index_ics_subdomains, overwrite = TRUE)
usethis::use_data(england_health_index_ics_indicators, overwrite = TRUE)
