#--- init ----------------------------------------------------------------------

library(tidyverse)
library(httr2)


#--- download ------------------------------------------------------------------

url <- "https://statswales.gov.wales/Download/File?fileName=HLTH0820.zip"
tf  <- tempfile(fileext = ".zip")

req_perform(request(url), tf)
unzip(tf, exdir = tempdir())

raw <- read_csv(file.path(tempdir(), "HLTH0820.csv"))


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
