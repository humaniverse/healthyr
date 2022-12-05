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

#' Wales ambulance waiting times - (2022)
#'
#' A dataset containing Welsh emergency ambulance calls and responses to red 
#' calls, by local health boards (HB) and month
#'
#' @format A data frame with 176 rows and 9 variables:
#' \describe{
#'   \item{date}{Date}
#'   \item{hb_code}{Local health board coade}
#'   \item{hb}{Name of local health board}
#'   \item{red_calls}{Number of red calls}
#'   \item{red_calls_resulting_in_an_emergency_response_at_the_scene}{Number of red call resulting in an emergency response at the scene}
#'   \item{amber_calls}{Number of amber calls}
#'   \item{green_calls}{Number of green calls}
#'   \item{red_calls_resulting_in_an_emergency_response_at_the_scene_within_8_minutes}{Number of red call resulting in an emergency response at the scene within 8 minutes}
#'   \item{red_calls_percent_of_emergency_responses_arriving_at_the_scene_within_8_minutes}{Percentage of emergency responses to red calls arriving at the scene within 8 minutes}
#'   
#'   ...
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_ambulance_waiting_times"

#' Wales bed availability - (2022)
#'
#' A dataset containing Welsh monthly NHS beds data by measure, site and 
#' specialty 
#'
#' @format A data frame with 176 rows and 9 variables:
#' \describe{
#'   \item{date}{Date}
#'   \item{hb_code}{Local health board coade}
#'   \item{hb}{Name of local health board}
#'   \item{red_calls}{Number of red calls}
#'   \item{red_calls_resulting_in_an_emergency_response_at_the_scene}{Number of red call resulting in an emergency response at the scene}
#'   \item{amber_calls}{Number of amber calls}
#'   \item{green_calls}{Number of green calls}
#'   \item{red_calls_resulting_in_an_emergency_response_at_the_scene_within_8_minutes}{Number of red call resulting in an emergency response at the scene within 8 minutes}
#'   \item{red_calls_percent_of_emergency_responses_arriving_at_the_scene_within_8_minutes}{Percentage of emergency responses to red calls arriving at the scene within 8 minutes}
#'   
#'   ...
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_critical_general_acute_beds"