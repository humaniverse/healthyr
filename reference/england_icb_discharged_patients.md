# Hospital ICB Discharge Data - Discharged Patients

A dataset containing NHS Integrated Care Board discharge data on how
many patients were discharged each day. From June 2023 figures for
discharged by 17:00 and between 17:01 and 23:59 were no longer released.

## Usage

``` r
england_icb_discharged_patients
```

## Format

A data frame with 51,727 rows and 5 variables:

- icb22_code:

  Integrated Care Board code

- date:

  Date

- discharged_by_1700:

  Number of patients discharged by 17:00

- discharged_between_1701_2359:

  Number of patients discharged between 17:01 and 23:59

- discharged_total:

  Total number of patients discharged

## Source

<https://www.england.nhs.uk/>
