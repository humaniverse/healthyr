query_urls <-
  tibble::tribble(
    # Column Names
    ~data_type, ~id, ~date, ~license, ~query, ~source,

    # NHSE
    "Hospital discharge (criteria to reside)", "nhs_discharge_criteria_april_22", "April 2022", "OGLv3", "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/08/Daily-discharge-sitrep-monthly-data-webfile-April2022-v2.xlsx", "https://www.england.nhs.uk/statistics/statistical-work-areas/hospital-discharge-data/",
    "Hospital discharge (criteria to reside)", "nhs_discharge_criteria_may_22", "May 2022", "OGLv3", "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/08/Daily-discharge-sitrep-monthly-data-webfile-May2022-v2.xlsx", "https://www.england.nhs.uk/statistics/statistical-work-areas/hospital-discharge-data/",
    "Hospital discharge (criteria to reside)", "nhs_discharge_criteria_june_22", "June 2022", "OGLv3", "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/08/Daily-discharge-sitrep-monthly-data-webfile-June2022-v2.xlsx", "https://www.england.nhs.uk/statistics/statistical-work-areas/hospital-discharge-data/",
    "Hospital discharge (criteria to reside)", "nhs_discharge_criteria_july_22", "July 2022", "OGLv3", "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/08/Daily-discharge-sitrep-monthly-data-webfile-July2022.xlsx", "https://www.england.nhs.uk/statistics/statistical-work-areas/hospital-discharge-data/",
  )

usethis::use_data(query_urls, internal = TRUE, overwrite = TRUE)