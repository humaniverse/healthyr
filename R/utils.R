# Health Index utilities

library(tidyverse)
library(healthyr)
library(healthindexwales)
library(healthindexscotland)
library(healthindexni)

# Returns a tibble of LTLA code with selected domain score, rank, and decile.
# nation: england/wales/scotland/ni
# domain: "overall", "people", "lives", "places"
load_health_index_deciles <- function(nation = c("england", "wales", "scotland", "ni"),
                                      domain = c("overall", "people", "lives", "places")) {
  nation <- match.arg(nation)
  domain <- match.arg(domain)

  df <- switch(nation,
               england = healthyr::england_health_index |> filter(year == max(year)) |>
                 select(ltla_code = ltla21_code,
                        overall = overall_score,
                        people = healthy_people_domain_score,
                        lives = healthy_lives_domain_score,
                        places = healthy_places_domain_score),
               wales = healthindexwales::wales_health_index |>
                 select(ltla_code = ltla24_code,
                        overall = overall_quantile,
                        people = healthy_people_quantile,
                        lives = healthy_lives_quantile,
                        places = healthy_places_quantile),
               scotland = healthindexscotland::scotland_health_index |>
                 select(ltla_code = ltla24_code,
                        overall = health_inequalities_quantile,
                        people = healthy_people_quantile,
                        lives = healthy_lives_quantile,
                        places = healthy_places_quantile),
               ni = healthindexni::ni_health_index |>
                 select(ltla_code = ltla24_code,
                        overall = health_inequalities_quantile,
                        people = healthy_people_quantile,
                        lives = healthy_lives_quantile,
                        places = healthy_places_quantile)
  )

  out <- df |>
    rename(value = {{ domain }}) |>
    mutate(
      rank = rank(value, ties.method = "first"),
      decile = ntile(value, 10)
    )

  out
}
