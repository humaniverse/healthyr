library(tidyverse)
library(lubridate)

# ---- Load internal sysdata.rda file with URLs ----
pkgload::load_all(".")

# ---- RTT ----
query_url <-
  query_urls |>
  filter(id == "scotland_rtt") |> # Each data release is cumulative
  pull(query)

raw <- read_csv(query_url)

## NOTE: Dataset no longer includes Scotland-figures

# scotland_rtt <- raw |>
#   filter(HBT == "S92000003") |> # national waiting lists
#   mutate(
#     Year = str_sub(Month, 1, 4) |> as.integer(),
#     Month = month.abb[as.integer(str_sub(Month, 5, 6))],
#     Date = my(paste0(Month, Year)),
#     performance_over = 1 - (Performance / 100)
#   ) |>
#   select(
#     date = Date,
#     year = Year,
#     month = Month,
#     waits_over_18_weeks_count = Over18Weeks,
#     waits_over_18_weeks_percent = performance_over
#   )

# Waiting lists by Health Board
scotland_rtt_hb <- raw |>
  filter(HBT != "S92000003") |> # Don't include national waiting lists
  mutate(
    Year = str_sub(Month, 1, 4) |> as.integer(),
    Month = month.abb[as.integer(str_sub(Month, 5, 6))],
    Date = my(paste0(Month, Year)),
    performance_over = 1 - (Performance / 100)
  ) |>
  select(
    hb19_code = HBT,
    date = Date,
    year = Year,
    month = Month,
    specialty = Specialty,
    waits_over_18_weeks_count = Over18Weeks,
    waits_over_18_weeks_percent = performance_over
  )

# Save output to data/ folder
# usethis::use_data(scotland_rtt, overwrite = TRUE)
usethis::use_data(scotland_rtt_hb, overwrite = TRUE)
