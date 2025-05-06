library(tidyverse)
library(statswalesr)

lhb_lookup <- geographr::boundaries_lhb22 |>
  distinct(lhb22_name, lhb22_code)

raw <- statswales_get_dataset("HLTH0820")

wales_delayed_discharges <- raw |>
  mutate(date = ym(Date_Code_INT)) |>
  select(
    lhb22_name = Localhealthboardprovider_ItemName_ENG_STR,
    date,
    delay_reason = Reasonfordelay_ItemName_ENG_STR,
    delay_count = Data_INT
  ) |>
  filter(lhb22_name != "Wales") |>
  filter(lhb22_name != "Velindre") |>
  left_join(lhb_lookup) |>
  relocate(lhb22_code, .after = lhb22_name)

usethis::use_data(wales_delayed_discharges, overwrite = TRUE)
