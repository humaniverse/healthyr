#--- init ----------------------------------------------------------------------

library(tidyverse)
library(statswalesr)


#--- download ------------------------------------------------------------------

raw <- statswales_get_dataset("HLTH0820")


#--- prepare -------------------------------------------------------------------

lhb_lookup <- geographr::boundaries_lhb22 |>
  distinct(lhb22_name, lhb22_code)

wales_delayed_discharge_reasons <- raw |>
  filter(Localauthorityofresidence_Hierarchy_STR == "Total") |>
  filter(Localhealthboardprovider_ItemName_ENG_STR != "Wales") |>
  filter(Localhealthboardprovider_ItemName_ENG_STR != "Velindre") |>
  filter(str_detect(Reasonfordelay_Code_STR, ".*\\..*\\..*")) |> # only select non-aggregated reasons
  select(
    lhb22_name = Localhealthboardprovider_ItemName_ENG_STR,
    date = Date_ItemName_ENG_STR,
    delay_reason = Reasonfordelay_ItemName_ENG_STR,
  ) |>
  mutate(date = my(date)) |>
  summarise(
    delay_count = n(),
    .by = c(lhb22_name, date, delay_reason)
  ) |>
  left_join(lhb_lookup) |>
  relocate(lhb22_code)


#--- save ----------------------------------------------------------------------

usethis::use_data(wales_delayed_discharge_reasons, overwrite = TRUE)
