library(tidyverse)
library(statswalesr)

raw <- statswales_get_dataset("HLTH0034")

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
