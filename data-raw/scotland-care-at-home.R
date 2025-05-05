#--- init ----------------------------------------------------------------------

library(tidyverse)


#--- download ------------------------------------------------------------------

# NOTE: data downloaded manually and saved to scotland-care-at-home.csv
# https://publichealthscotland.scot/publications/care-at-home-statistics-for-scotland/care-at-home-statistics-for-scotland-support-and-services-funded-by-health-and-social-care-partnerships-in-scotland-20232024/dashboard/
# go to "Care at Home" (in the purple nav bar) -> "Trend" (in the side bar) -> Download Data button.

raw <- read_csv("scotland-care-at-home.csv")


#--- prepare -------------------------------------------------------------------

# NOTE: not sure where to get locations codes
scotland_care_at_home <- raw |>
  filter(`Time Period` == "Financial Quarter",
         Location      != "Scotland (Estimated)",
        `Age Group`    == "All Ages",
         Measure       == "Rate per 1,000 People") |>
  select(healthboard_name      = Location,
         date                  = `Financial Quarter`,
         care_at_home_per_1000 = Value
         ) |>
  mutate(date = str_replace(date, "Jan-Mar", "Q1"),
         date = str_replace(date, "Apr-Jun", "Q2"),
         date = str_replace(date, "Jul-Sep", "Q3"),
         date = str_replace(date, "Oct-Dec", "Q4"),
         )


#--- save ----------------------------------------------------------------------

usethis::use_data(scotland_care_at_home, overwrite = TRUE)
