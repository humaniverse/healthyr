#--- init ----------------------------------------------------------------------

library(tidyverse)
library(statswalesr)


#--- download ------------------------------------------------------------------

raw <- statswales_get_dataset("HLTH0820")


#--- prepare -------------------------------------------------------------------

wales_delayed_discharge_reasons <- raw |>
  filter(Localauthorityofresidence_Hierarchy_STR == "Total") |>
  filter(Localhealthboardprovider_ItemName_ENG_STR != "Wales") |>
  filter(str_detect(Reasonfordelay_Code_STR, ".*\\..*\\..*")) |>  # only select non-aggregated reasons
  select(healthboard_code = Localhealthboardprovider_Code_STR,
         healthboard_name = Localhealthboardprovider_ItemName_ENG_STR,
         date = Date_ItemName_ENG_STR,
         delay_reason = Reasonfordelay_ItemName_ENG_STR,
         ) |>
  mutate(date = my(date)) |> 
  group_by(healthboard_code, healthboard_name, date, delay_reason) |>
  summarise(delay_count = n())


#--- save ----------------------------------------------------------------------

usethis::use_data(wales_delayed_discharge_reasons, overwrite = TRUE)
