library(tidyverse)
library(lubridate)
library(sf)
# library(httr)

# ---- Lookup table for matching old/new NHS Regions ----
nhs_region_lookup <- tribble(
  ~`Provider Parent Name`,
  ~NHSER20NM,
  "NHS ENGLAND LONDON",
  "London",
  "NHS ENGLAND NORTH EAST AND YORKSHIRE (YORKSHIRE AND HUMBER)",
  "North East and Yorkshire",
  "NHS ENGLAND NORTH EAST AND YORKSHIRE (CUMBRIA AND NORTH EAST)",
  "North East and Yorkshire",
  "NHS ENGLAND NORTH WEST (CHESHIRE AND MERSEYSIDE)",
  "North West",
  "NHS ENGLAND MIDLANDS (NORTH MIDLANDS)",
  "Midlands",
  "NHS ENGLAND MIDLANDS (WEST MIDLANDS)",
  "Midlands",
  "NHS ENGLAND MIDLANDS (CENTRAL MIDLANDS)",
  "Midlands",
  "NHS ENGLAND EAST OF ENGLAND (EAST)",
  "East of England",
  "NHS ENGLAND NORTH WEST (GREATER MANCHESTER)",
  "North West",
  "NHS ENGLAND NORTH WEST (LANCASHIRE AND SOUTH CUMBRIA)",
  "North West",
  "NHS ENGLAND SOUTH WEST (SOUTH WEST SOUTH)",
  "South West",
  "NHS ENGLAND SOUTH WEST (SOUTH WEST NORTH)",
  "South West",
  "NHS ENGLAND SOUTH EAST (HAMPSHIRE, ISLE OF WIGHT AND THAMES VALLEY)",
  "South East",
  "NHS ENGLAND SOUTH EAST (KENT, SURREY AND SUSSEX)",
  "South East",
  "NHS ENGLAND NORTH (YORKSHIRE AND HUMBER)",
  "North East and Yorkshire",
  "NHS ENGLAND NORTH (CUMBRIA AND NORTH EAST)",
  "North East and Yorkshire",
  "NHS ENGLAND NORTH (CHESHIRE AND MERSEYSIDE)",
  "North West",
  "NHS ENGLAND MIDLANDS AND EAST (NORTH MIDLANDS)",
  "Midlands",
  "NHS ENGLAND MIDLANDS AND EAST (WEST MIDLANDS)",
  "Midlands",
  "NHS ENGLAND MIDLANDS AND EAST (CENTRAL MIDLANDS)",
  "Midlands",
  "NHS ENGLAND MIDLANDS AND EAST (EAST)",
  "East of England",
  "NHS ENGLAND NORTH (GREATER MANCHESTER)",
  "North West",
  "NHS ENGLAND NORTH (LANCASHIRE AND SOUTH CUMBRIA)",
  "North West",
  "NHS ENGLAND SOUTH WEST (SOUTH WEST SOUTH)",
  "South West",
  "NHS ENGLAND SOUTH WEST (SOUTH WEST NORTH)",
  "South West",
  "NHS ENGLAND SOUTH EAST (HAMPSHIRE, ISLE OF WIGHT AND THAMES VALLEY)",
  "South East",
  "NHS ENGLAND SOUTH EAST (KENT, SURREY AND SUSSEX)",
  "South East"
)


# ---- Download waiting list data ----
# URLs for full waiting list data by month from https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times
urls <- c(
  feb_25 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/04/Full-CSV-data-file-Feb25-ZIP-4M-76538.zip",
  jan_25 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/03/Full-CSV-data-file-Jan25-ZIP-4M-53275.zip",
  dec_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Full-CSV-data-file-Dec24-ZIP-3M-69130.zip",
  nov_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/01/Full-CSV-data-file-Nov24-ZIP-4M-37212.zip",
  oct_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/12/Full-CSV-data-file-Oct24-ZIP-4M-60893.zip",
  sep_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Full-CSV-data-file-Sep24-ZIP-4M-revised.zip",
  aug_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Full-CSV-data-file-Aug24-ZIP-4M-revised.zip",
  jul_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Full-CSV-data-file-Jul24-ZIP-4M-revised.zip",
  jun_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Full-CSV-data-file-Jun24-ZIP-4M-revised.zip",
  may_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Full-CSV-data-file-May24-ZIP-4M-revised.zip",
  apr_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2025/02/Full-CSV-data-file-Apr24-ZIP-4M-revised.zip",
  mar_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/07/Full-CSV-data-file-Mar24-ZIP-3832K-revised.zip",
  feb_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/07/Full-CSV-data-file-Feb24-ZIP-3881K-revised.zip",
  jan_24 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/07/Full-CSV-data-file-Jan24-ZIP-3943K-revised.zip",
  dec_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/07/Full-CSV-data-file-Dec23-ZIP-3800K-revised.zip",
  nov_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/07/Full-CSV-data-file-Nov23-ZIP-3952K-revised.zip",
  oct_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/07/Full-CSV-data-file-Oct23-ZIP-3928K-revised.zip",
  sep_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/01/Full-CSV-data-file-Sep23-ZIP-3654K-revised.zip",
  aug_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/01/Full-CSV-data-file-Aug23-ZIP-3646K-revised.zip",
  jul_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/01/Full-CSV-data-file-Jul23-ZIP-3623K-revised.zip",
  jun_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/08/Full-CSV-data-file-Jun23-ZIP-3659K-64970.zip",
  may_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/01/Full-CSV-data-file-May23-ZIP-3627K-revised.zip",
  apr_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/06/Full-CSV-data-file-Apr23-ZIP-3528K-36960.zip",
  mar_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/05/Full-CSV-data-file-Mar23-ZIP-3823K-53773.zip",
  feb_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/04/Full-CSV-data-file-Feb23-ZIP-3552K-55444.zip",
  jan_23 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Jan23-ZIP-3608K-03732.zip",
  dec_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/02/Full-CSV-data-file-Dec22-ZIP-3407K-58481.zip",
  nov_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/01/Full-CSV-data-file-Nov22-ZIP-3510K-63230.zip",
  oct_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/12/Full-CSV-data-file-Oct22-ZIP-3701K-v2.zip",
  sep_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Sep22-revised-ZIP-3542K.zip",
  aug_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Aug22-revised-ZIP-3488K.zip",
  jul_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Jul22-revised-ZIP-3642K.zip",
  jun_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Jun22-revised-ZIP-4253.zip",
  may_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-May22-revised-ZIP-4392K.zip",
  apr_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Apr22-revised-ZIP-4253.zip",
  mar_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Mar22-revised-ZIP-111805K.zip",
  feb_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Feb22-revised-ZIP-109268K.zip",
  jan_22 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Jan22-revised-ZIP-4266K.zip",
  dec_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Dec21-revised-ZIP-3744K.zip",
  nov_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Nov21-revised-ZIP-3826K.zip",
  oct_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2023/03/Full-CSV-data-file-Oct21-revised-ZIP-3787K.zip",
  sep_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Sep21-revised-ZIP-3768K.zip",
  aug_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Aug21-revised-ZIP-3682K.zip",
  jul_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Jul21-revised-ZIP-3710K.zip",
  jun_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Jun21-revised-ZIP-3739K.zip",
  may_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-May21-revised-ZIP-3656K.zip",
  apr_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Apr21-revised-ZIP-3587K.zip",
  mar_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/05/Full-CSV-data-file-Mar21-ZIP-2888K-76325.zip",
  feb_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/04/Full-CSV-data-file-Feb21-ZIP-2739K-25692.zip",
  jan_21 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/03/Full-CSV-data-file-Jan21-ZIP-2714K-24158.zip",
  dec_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/10/Full-CSV-data-file-Dec20-revised-ZIP-2860K.zip",
  nov_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/01/Full-CSV-data-file-Nov20-ZIP-2758K-26885.zip",
  oct_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/10/Full-CSV-data-file-Oct20-revised-ZIP-2772K.zip",
  sep_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/11/Full-CSV-data-file-Sep20-ZIP-2738K-20720.zip",
  aug_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/10/Full-CSV-data-file-Aug20-ZIP-2594K-09869.zip",
  jul_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/09/Full-CSV-data-file-Jul20-ZIP-2546K.zip",
  jun_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/10/Full-CSV-data-file-Jun20-revised-ZIP-2649K.zip",
  may_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/10/Full-CSV-data-file-May20-revised-ZIP-2216K.zip",
  apr_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/10/Full-CSV-data-file-Apr20-revised-ZIP-2295K.zip",
  mar_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/05/Full-CSV-data-file-Mar20-ZIP-2995K-73640.zip",
  feb_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Feb20-revised-ZIP-3171K.zip",
  jan_20 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Jan20-revised-ZIP-3227K.zip",
  dec_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Dec19-revised-ZIP-3109K.zip",
  nov_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Nov19-revised-ZIP-3528K.zip",
  oct_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2022/01/Full-CSV-data-file-Oct19-revised-ZIP-3580K.zip",
  sep_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2019/11/Full-CSV-data-file-Sep19-ZIP-3532K-62303.zip",
  aug_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/01/Full-CSV-data-file-Aug19-ZIP-3493K-revised.zip",
  jul_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/01/Full-CSV-data-file-Jul19-ZIP-3550K-revised.zip",
  jun_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/01/Full-CSV-data-file-Jun19-ZIP-3502K.zip",
  may_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/01/Full-CSV-data-file-May19-ZIP-3497K-revised.zip",
  apr_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/01/Full-CSV-data-file-Apr19-ZIP-3436K-revised.zip",
  mar_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2019/07/Full-CSV-data-file-Mar19-revised-ZIP-3506K.zip",
  feb_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2019/07/Full-CSV-data-file-Feb19-revised-ZIP-3485K.zip",
  jan_19 = "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2019/07/Full-CSV-data-file-Jan19-revised-ZIP-3634K.zip"
)

process_single_url <- function(url, target_dir) {
  tf <- tempfile(fileext = ".zip")
  tryCatch(
    {
      cat("\nAttempting download:", url, "to", tf, "\n")
      download.file(url, destfile = tf, mode = "wb", quiet = TRUE)
      cat("Download complete:", tf, "\n")
      cat("Unzipping:", tf, "to", target_dir, "\n")
      unzip(tf, exdir = target_dir)
      cat("Unzip complete for file from:", url, "\n")
    },
    error = function(e) {
      warning("Failed to process URL: ", url, "\nError: ", conditionMessage(e))
    },
    finally = {
      if (file.exists(tf)) {
        cat("Cleaning up temporary file:", tf, "\n")
        unlink(tf)
      }
    }
  )
  invisible(NULL)
}

td <- tempdir()

# Called for its side-effect: `list.files(td, pattern = "*.csv", full.names = TRUE)`
results <- purrr::walk(
  .x = urls,
  .f = ~ process_single_url(url = .x, target_dir = td),
  .progress = "Downloading and Unzipping Files" # Custom progress bar message
)

# Sustainability Transformation Partnerships and NHS England (Region) (April 2020) Lookup in England
# Source: https://geoportal.statistics.gov.uk/datasets/ons::sustainability-transformation-partnerships-and-nhs-england-region-april-2020-lookup-in-england-1/about
stp_region <- read_sf(
  "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/STP20_NHSER20_EN_LU_e268d9cb3626464584f6b988a0aa4e61/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"
) |>
  st_drop_geometry()

# ---- Load waiting list data into separate dataframes ----
# Set up empty dataframes
stp_waits <- tibble()
stp_flow <- tibble()
region_waits <- tibble()

# Debugging:
# file <- list.files(td, pattern = "*.csv", full.names = TRUE)[11]

for (file in list.files(td, pattern = "*.csv", full.names = TRUE)) {
  d <- read_csv(file)

  # Add date columns
  d <-
    d %>%
    mutate(
      Date = dmy(str_replace(Period, "RTT", "01")),
      Month = month.abb[month(Date)],
      Year = year(Date)
    )

  # Data from April 2021 onward contains STPs/ICSs
  if (d$Date[1] >= dmy("01-04-2021")) {
    # Calculate STP/ICS totals
    d_stp <-
      d %>%
      mutate(
        `Total waiting > 18 weeks` = rowSums(
          across(`Gt 18 To 19 Weeks SUM 1`:`Gt 104 Weeks SUM 1`),
          na.rm = TRUE
        ),
        `Total waiting > 52 weeks` = rowSums(
          across(`Gt 52 To 53 Weeks SUM 1`:`Gt 104 Weeks SUM 1`),
          na.rm = TRUE
        )
      ) %>%
      group_by(
        Year,
        Month,
        `Provider Parent Org Code`,
        `Provider Parent Name`,
        `Treatment Function Name`
      ) %>%
      summarise(
        `Total waiting > 52 weeks` = sum(
          `Total waiting > 52 weeks`,
          na.rm = TRUE
        ),
        `Total waiting > 18 weeks` = sum(
          `Total waiting > 18 weeks`,
          na.rm = TRUE
        )
      )

    d_flow <-
      d %>%
      filter(`Treatment Function Name` == "Total") %>%
      select(
        Year,
        Month,
        `Provider Parent Org Code`,
        `RTT Part Description`,
        `Total All`
      ) %>%
      mutate(
        Pathway = case_when(
          str_detect(`RTT Part Description`, "^Completed") ~ "Completed",
          str_detect(`RTT Part Description`, "^Incomplete") ~ "Incomplete",
          str_detect(`RTT Part Description`, "^New") ~ "New"
        )
      ) %>%
      group_by(Year, Month, `Provider Parent Org Code`, Pathway) %>%
      summarise(`Total All` = sum(`Total All`, na.rm = TRUE)) %>%
      ungroup() %>%
      pivot_wider(names_from = Pathway, values_from = `Total All`)

    # Bind to main STP dataframe
    stp_waits <- bind_rows(stp_waits, d_stp)
    stp_flow <- bind_rows(stp_flow, d_flow)

    # Current data contains STPs/ICSs, so merge in NHS Regions
    d <-
      d %>%
      left_join(stp_region, by = c("Provider Parent Org Code" = "STP20CDH"))
  } else if (d$Date[1] >= dmy("01-04-2020")) {
    # Calculate STP/ICS totals
    d_stp <-
      d %>%
      mutate(
        `Total waiting > 18 weeks` = rowSums(
          across(`Gt 18 To 19 Weeks SUM 1`:`Gt 52 Weeks SUM 1`),
          na.rm = TRUE
        )
      ) %>%
      group_by(
        Year,
        Month,
        `Provider Parent Org Code`,
        `Provider Parent Name`,
        `Treatment Function Name`
      ) %>%
      summarise(
        `Total waiting > 52 weeks` = sum(`Gt 52 Weeks SUM 1`, na.rm = TRUE),
        `Total waiting > 18 weeks` = sum(
          `Total waiting > 18 weeks`,
          na.rm = TRUE
        )
      )

    d_flow <-
      d %>%
      filter(`Treatment Function Name` == "Total") %>%
      select(
        Year,
        Month,
        `Provider Parent Org Code`,
        `RTT Part Description`,
        `Total All`
      ) %>%
      mutate(
        Pathway = case_when(
          str_detect(`RTT Part Description`, "^Completed") ~ "Completed",
          str_detect(`RTT Part Description`, "^Incomplete") ~ "Incomplete",
          str_detect(`RTT Part Description`, "^New") ~ "New"
        )
      ) %>%
      group_by(Year, Month, `Provider Parent Org Code`, Pathway) %>%
      summarise(`Total All` = sum(`Total All`, na.rm = TRUE)) %>%
      ungroup() %>%
      pivot_wider(names_from = Pathway, values_from = `Total All`)

    # Bind to main STP dataframe
    stp_waits <- bind_rows(stp_waits, d_stp)
    stp_flow <- bind_rows(stp_flow, d_flow)

    # Current data contains STPs/ICSs, so merge in NHS Regions
    d <-
      d %>%
      left_join(stp_region, by = c("Provider Parent Org Code" = "STP20CDH"))
  } else {
    # Data before April 2020 already contains NHS Regions, so use lookup table at the top of this script to sanitise the names
    d <-
      d %>%
      left_join(nhs_region_lookup, by = c("Provider Parent Name"))

    # mutate(NHSER20NM = str_remove(`Provider Parent Name`, "NHS ENGLAND "),
    #        NHSER20NM = str_remove(NHSER20NM, " \\([A-Z\\s,]+\\)"),
    #        NHSER20NM = str_to_title(NHSER20NM))
  }

  if (d$Date[1] >= dmy("01-04-2021")) {
    d_region <-
      d %>%
      mutate(
        `Total waiting > 18 weeks` = rowSums(
          across(`Gt 18 To 19 Weeks SUM 1`:`Gt 104 Weeks SUM 1`),
          na.rm = TRUE
        ),
        `Total waiting > 52 weeks` = rowSums(
          across(`Gt 52 To 53 Weeks SUM 1`:`Gt 104 Weeks SUM 1`),
          na.rm = TRUE
        )
      ) %>%
      group_by(Year, Month, NHSER20NM, `Treatment Function Name`) %>%
      summarise(
        `Total waiting > 52 weeks` = sum(
          `Total waiting > 52 weeks`,
          na.rm = TRUE
        ),
        `Total waiting > 18 weeks` = sum(
          `Total waiting > 18 weeks`,
          na.rm = TRUE
        )
      )
  } else {
    d_region <-
      d %>%
      mutate(
        `Total waiting > 18 weeks` = rowSums(
          across(`Gt 18 To 19 Weeks SUM 1`:`Gt 52 Weeks SUM 1`),
          na.rm = TRUE
        )
      ) %>%
      group_by(Year, Month, NHSER20NM, `Treatment Function Name`) %>%
      summarise(
        `Total waiting > 52 weeks` = sum(`Gt 52 Weeks SUM 1`, na.rm = TRUE),
        `Total waiting > 18 weeks` = sum(
          `Total waiting > 18 weeks`,
          na.rm = TRUE
        )
      )
  }

  # Add regional data to main dataframe
  region_waits <- bind_rows(region_waits, d_region)

  print(paste0("Finished ", d$Month[1], " ", d$Year[1]))
}

# Convert months to factors so they plot in the right order
england_rtt_stp <-
  stp_waits %>%
  mutate(Month = factor(Month, levels = month.abb)) |>
  mutate(date = ym(paste0(Year, "-", Month))) |>
  select(
    stp20_nhs_code = `Provider Parent Org Code`,
    stp20_name = `Provider Parent Name`,
    date,
    year = Year,
    month = Month,
    treatment = `Treatment Function Name`,
    waits_over_18_weeks = `Total waiting > 18 weeks`,
    waits_over_52_weeks = `Total waiting > 52 weeks`
  )

england_rtt_flow_stp <-
  stp_flow %>%
  mutate(Month = factor(Month, levels = month.abb)) |>
  mutate(date = ym(paste0(Year, "-", Month))) |>
  select(
    stp20_nhs_code = `Provider Parent Org Code`,
    date,
    year = Year,
    month = Month,
    completed = Completed,
    incomplete = Incomplete,
    new = New
  )

england_rtt_region <-
  region_waits %>%
  mutate(Month = factor(Month, levels = month.abb)) |>
  mutate(date = ym(paste0(Year, "-", Month))) |>
  select(
    nhs_region20_name = NHSER20NM,
    date,
    year = Year,
    month = Month,
    treatment = `Treatment Function Name`,
    waits_over_18_weeks = `Total waiting > 18 weeks`,
    waits_over_52_weeks = `Total waiting > 52 weeks`
  )

# Save output to data/ folder
usethis::use_data(england_rtt_stp, overwrite = TRUE)
usethis::use_data(england_rtt_flow_stp, overwrite = TRUE)
usethis::use_data(england_rtt_region, overwrite = TRUE)
