# England Accident and Emergency Admissions by Trust - (2021-25)

A dataset containing England Accident and Emergency attendances and
Emergency Admissions at provider level, by month.

## Usage

``` r
england_trust_accidents_emergency
```

## Format

A data frame with 7,895 rows and 8 variables:

- nhs_trust22_code:

  NHS Trust (organisational) code

- total_attendances:

  The total number of patients in an A&E service seeking medical
  attention

- attendances_over_4hours:

  The number of patients seeking medical attention that spend over 4
  hours from arrival to admission, transfer or discharge

- total_emergency_admissions:

  The total number of admissions to a hospital bed as an emergency

- emergency_admissions_over_4hours:

  The number of patients seeking admission to a hospital bed as an
  emergency that spend over 4 hours from decision to admit to admission

- pct_attendance_over_4hours:

  The percentage of attendance that spend over 4 hours from arrival to
  admission, transfer of discharge

- date:

  Date

- pct_emergency_admissions_over_4hours:

  The percentage of emergency admissions that spend over 4 hours from
  decision to admit to admission

## Source

<https://www.england.nhs.uk/>

## Details

Data notes:

- Due to a cyber-attack several sites have been unable to provide
  complete data since August 2022

- Fourteen trusts are field testing new A&E performance standards and as
  a result are not required to report attendances over four hours from
  May 2019
