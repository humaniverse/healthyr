#' Critical care and General & Acute Beds
#'
#' A dataset containing NHS Trust level critical care and general and acute bed
#' availability information. This is taken from the urgent and emergency care
#' daily situation reports for each month of 2022.
#'
#' @format A data frame with 959 rows and 20 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{general_acute_beds_availabile}{"G&A beds available"}
#'   \item{general_acute_beds_occupied}{"G&A beds occupied"}
#'   \item{general_acute_beds_occupancy_rate}{"G&A occupancy rate"}
#'   \item{adult_general_acute_beds_available}{"Adult G&A beds available"}
#'   \item{adult_general_acute_beds_occupied}{"Adult G&A beds occupied"}
#'   \item{adult_general_acute_beds_occupancy_rate}{"Adult G&A occupancy rate"}
#'   \item{paediatric_general_acute_beds_available}{"Paediatric G&A beds available"}
#'   \item{paediatric_general_acute_beds_occupied}{"Paediatric G&A beds occupied"}
#'   \item{paediatric_general_acute_beds_occupancy_rate}{"Paediatric G&A occupancy rate"}
#'   \item{adult_critical_care_beds_available}{"Adult critical care beds available"}
#'   \item{adult_critical_care_beds_occupied}{"Adult critical care beds occupied"}
#'   \item{adult_critical_care_occupancy_rate}{"Adult critical care occupancy rate"}
#'   \item{paediatric_intensive_cared_beds_available}{"Paediatric intensive care beds available"}
#'   \item{paediatric_intensive_cared_beds_occupied}{"Paediatric intensive care beds occupied"}
#'   \item{paediatric_intensive_cared_occupancy_rate}{"Paediatric intensive care occupancy rate"}
#'   \item{neonatal_intensive_care_bed_avaialble}{"Neonatal intensive care beds available"}
#'   \item{neonatal_intensive_care_bed_occupied}{"Neonatal intensive care beds occupied"}
#'   \item{neonatal_intensive_care_occupancy_rate}{"Neonatal intensive care occupancy rate"}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"nhs_critical_general_acute_beds_22"

#' Hosptial Discharge Data - Criteria to Reside (2022)
#'
#' A dataset containing NHS Trust level hopsital discharge data on how many
#' patients do not meet criteria to reside for each day of 2022.
#'
#' @format A data frame with 25,894 rows and 3 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{do_not_meet_criteria_to_reside}{Number of patients who no longer meet the criteria to reside}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"nhs_criteria_to_reside_22"

#' Hosptial Discharge Data - Discharged Patients (2022)
#'
#' A dataset containing NHS Trust level hopsital discharge data on how many
#' patients were discharged for each day of 2022.
#'
#' @format A data frame with 25,894 rows and 5 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{discharged_by_1700}{Number of patients discharged by 17:00}
#'   \item{discharged_between_1701_2359}{Number of patients discharged between 17:01 and 23:59}
#'   \item{discharged_total}{Total number of patients discharged}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"nhs_discharged_patients_22"

#' Physchological Therpaies - IAPT (2022)
#'
#' A dataset containing NHS Trust level IAPT data.
#'
#' @format A data frame with 6,876 rows and 4 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{name}{Name of the variable}
#'   \item{value}{Value of the variable}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"nhs_iapt_22"

#' Delayed Discharge Bed Days by Health Board in Scotland
#'
#' A dataset containing Delayed Discharge Bed Days by Scottish Health Board.
#'
#' @format A data frame with 16,875 rows and 6 variables:
#' \describe{
#'   \item{hb_code}{Scottish Health Board code}
#'   \item{date}{Date}
#'   \item{age_group}{Age grouping is calculated as at the person's ready for discharge date}
#'   \item{delay_reason}{Reason for delay indicates the principal reason grouping for a person's delay at the end of the reporting month}
#'   \item{num_delayed_bed_days}{The total number of delayed bed days}
#'   \item{average_daily_delayed_beds}{The average daily number of delayed beds is calculated by dividing the total number of delayed discharge bed days in the month by the number of days in the calendar month}
#'   ...
#' }
#' @source \url{https://www.opendata.nhs.scot/}
"scotland_delayed_discharge_hb"

#' Delayed Discharge Bed Days by Council Area in Scotland
#'
#' A dataset containing Delayed Discharge Bed Days by Scottish Council Area
#'
#' @format A data frame with 38,250 rows and 6 variables:
#' \describe{
#'   \item{ltla_code}{Scottish Council Area code}
#'   \item{date}{Date}
#'   \item{age_group}{Age grouping is calculated as at the person's ready for discharge date}
#'   \item{delay_reason}{Reason for delay indicates the principal reason grouping for a person's delay at the end of the reporting month}
#'   \item{num_delayed_bed_days}{The total number of delayed bed days}
#'   \item{average_daily_delayed_beds}{The average daily number of delayed beds is calculated by dividing the total number of delayed discharge bed days in the month by the number of days in the calendar month}
#'   ...
#' }
#' @source \url{https://www.opendata.nhs.scot/}
"scotland_delayed_discharge_ltla"
