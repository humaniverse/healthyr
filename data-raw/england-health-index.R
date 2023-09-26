# ---- Load libs ----
library(tidyverse)
library(readxl)
library(sf)
library(geographr)
library(devtools)
library(httr2)
library(lubridate)

# ---- LTLA lookup table ----
lookup_ltla21 <- boundaries_ltla21 |>
  st_drop_geometry()

# ---- Load internal sysdata.rda file with URL's ----
load_all(".")

# ---- Download data ----
query_url <-
  query_urls |>
  filter(id == "england_health_index_2021") |>
  pull(query)

download <- tempfile(fileext = ".xlsx")

request(query_url) |>
  req_perform(download)

# ---- Wrangle overall scores ----
raw <- read_excel(
  download,
  sheet = "Table_2_Index_scores",
  range = "A3:J344"
)

overall_scores <-
  raw |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  select(ltla21_code = `Area Code`, `2015`:`2021`) |>
  pivot_longer(!ltla21_code, names_to = "year", values_to = "overall_score") |>
  mutate(year = as.integer(year))

# ---- Wrangle domains and subdomains for each year ----
## 2021
raw_2021 <- read_excel(
  download,
  sheet = "Table_3_2021_Index",
  skip = 4
)

domains_2021 <-
  raw_2021 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2021) |>
  select(
    ltla21_code = `Area Code`,
    year,
    healthy_people_domain_score = `Healthy People Domain`,
    healthy_lives_domain_score = `Healthy Lives Domain`,
    healthy_places_domain_score = `Healthy Places Domain`
  )

subdomains_2021 <-
  raw_2021 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2021) |>
  select(
    ltla21_code = `Area Code`,
    year,
    matches("\\[Pe\\]$"),
    matches("\\[L\\]$"),
    matches("\\[Pl\\]$")
  )

## 2020
raw_2020 <- read_excel(
  download,
  sheet = "Table_4_2020_Index",
  skip = 4
)

domains_2020 <-
  raw_2020 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2020) |>
  select(
    ltla21_code = `Area Code`,
    year,
    healthy_people_domain_score = `Healthy People Domain`,
    healthy_lives_domain_score = `Healthy Lives Domain`,
    healthy_places_domain_score = `Healthy Places Domain`
  )

subdomains_2020 <-
  raw_2020 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2020) |>
  select(
    ltla21_code = `Area Code`,
    year,
    matches("\\[Pe\\]$"),
    matches("\\[L\\]$"),
    matches("\\[Pl\\]$")
  )

## 2019
raw_2019 <- read_excel(
  download,
  sheet = "Table_5_2019_Index",
  skip = 4
)

domains_2019 <-
  raw_2019 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2019) |>
  select(
    ltla21_code = `Area Code`,
    year,
    healthy_people_domain_score = `Healthy People Domain`,
    healthy_lives_domain_score = `Healthy Lives Domain`,
    healthy_places_domain_score = `Healthy Places Domain`
  )

subdomains_2019 <-
  raw_2019 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2019) |>
  select(
    ltla21_code = `Area Code`,
    year,
    matches("\\[Pe\\]$"),
    matches("\\[L\\]$"),
    matches("\\[Pl\\]$")
  )

## 2018
raw_2018 <- read_excel(
  download,
  sheet = "Table_6_2018_Index",
  skip = 4
)

domains_2018 <-
  raw_2018 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2018) |>
  select(
    ltla21_code = `Area Code`,
    year,
    healthy_people_domain_score = `Healthy People Domain`,
    healthy_lives_domain_score = `Healthy Lives Domain`,
    healthy_places_domain_score = `Healthy Places Domain`
  )

subdomains_2018 <-
  raw_2018 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2018) |>
  select(
    ltla21_code = `Area Code`,
    year,
    matches("\\[Pe\\]$"),
    matches("\\[L\\]$"),
    matches("\\[Pl\\]$")
  )

## 2017
raw_2017 <- read_excel(
  download,
  sheet = "Table_7_2017_Index",
  skip = 4
)

domains_2017 <-
  raw_2017 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2017) |>
  select(
    ltla21_code = `Area Code`,
    year,
    healthy_people_domain_score = `Healthy People Domain`,
    healthy_lives_domain_score = `Healthy Lives Domain`,
    healthy_places_domain_score = `Healthy Places Domain`
  )

subdomains_2017 <-
  raw_2017 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2017) |>
  select(
    ltla21_code = `Area Code`,
    year,
    matches("\\[Pe\\]$"),
    matches("\\[L\\]$"),
    matches("\\[Pl\\]$")
  )

## 2016
raw_2016 <- read_excel(
  download,
  sheet = "Table_8_2016_Index",
  skip = 4
)

domains_2016 <-
  raw_2016 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2016) |>
  select(
    ltla21_code = `Area Code`,
    year,
    healthy_people_domain_score = `Healthy People Domain`,
    healthy_lives_domain_score = `Healthy Lives Domain`,
    healthy_places_domain_score = `Healthy Places Domain`
  )

subdomains_2016 <-
  raw_2016 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2016) |>
  select(
    ltla21_code = `Area Code`,
    year,
    matches("\\[Pe\\]$"),
    matches("\\[L\\]$"),
    matches("\\[Pl\\]$")
  )

## 2015
raw_2015 <- read_excel(
  download,
  sheet = "Table_9_2015_Index",
  skip = 4
)

domains_2015 <-
  raw_2015 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2015) |>
  select(
    ltla21_code = `Area Code`,
    year,
    healthy_people_domain_score = `Healthy People Domain`,
    healthy_lives_domain_score = `Healthy Lives Domain`,
    healthy_places_domain_score = `Healthy Places Domain`
  )

subdomains_2015 <-
  raw_2015 |>
  filter(`Area Type [Note 3]` == "LTLA") |>
  mutate(year = 2015) |>
  select(
    ltla21_code = `Area Code`,
    year,
    matches("\\[Pe\\]$"),
    matches("\\[L\\]$"),
    matches("\\[Pl\\]$")
  )

# Combine domains and subdomains
domains <- bind_rows(
  domains_2021,
  domains_2020,
  domains_2019,
  domains_2018,
  domains_2017,
  domains_2016,
  domains_2015
)

subdomains <- bind_rows(
  subdomains_2021,
  subdomains_2020,
  subdomains_2019,
  subdomains_2018,
  subdomains_2017,
  subdomains_2016,
  subdomains_2015
)

# ---- Finalise data ----
england_health_index <-
  overall_scores |>
  left_join(domains)

england_health_index_subdomains <- subdomains

# ---- Save output to data/ folder ----
usethis::use_data(england_health_index, overwrite = TRUE)
usethis::use_data(england_health_index_subdomains, overwrite = TRUE)
