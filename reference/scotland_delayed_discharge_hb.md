# Delayed Discharge Bed Days by Health Board in Scotland

A dataset containing Delayed Discharge Bed Days by Scottish Health
Board.

## Usage

``` r
scotland_delayed_discharge_hb
```

## Format

A data frame with 24,750 rows and 6 variables:

- hb_code:

  Scottish Health Board code

- date:

  Date

- age_group:

  Age grouping is calculated as at the person's ready for discharge date

- delay_reason:

  Reason for delay indicates the principal reason grouping for a
  person's delay at the end of the reporting month

- num_delayed_bed_days:

  The total number of delayed bed days

- average_daily_delayed_beds:

  The average daily number of delayed beds is calculated by dividing the
  total number of delayed discharge bed days in the month by the number
  of days in the calendar month

## Source

<https://www.opendata.nhs.scot/>
