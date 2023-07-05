#' England Accident and Emergency Admissions by Integrated Care Board  - (2022-23)
#'
#' A dataset containing England Accident and Emergency attendances and Emergency Admissions at Integrated Care Board level, by month
#'
#' @format A data frame with 546 rows and 8 variables:
#' \describe{
#'   \item{icb22_code}{Integrated Care Board code}
#'   \item{total_attendances}{The total number of patients in an A&E service seeking medical attention}
#'   \item{attendances_over_4hours}{The number of patients seeking medical attention that spend over 4 hours from arrival to admission, transfer or discharge}
#'   \item{total_emergency_admissions}{The total number of admissions to a hospital bed as an emergency}
#'   \item{emergency_admissions_over_4hours}{The number of patients seeking admission to a hospital bed as an emergency that spend over 4 hours from decision to admit to admission}
#'   \item{pct_attendance_over_4hours}{The percentage of attendance that spend over 4 hours from arrival to admission, transfer of discharge}
#'   \item{date}{Date}
#'   \item{pct_emergency_admissions_over_4hours}{The percentage of emergency admissions that spend over 4 hours from decision to admit to admission}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_icb_accidents_emergency"

#' England Accident and Emergency Admissions by Trust - (2021-23)
#'
#' A dataset containing England Accident and Emergency attendances and Emergency Admissions at provider level, by month.
#'
#' @format A data frame with 3,828 rows and 8 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{total_attendances}{The total number of patients in an A&E service seeking medical attention}
#'   \item{attendances_over_4hours}{The number of patients seeking medical attention that spend over 4 hours from arrival to admission, transfer or discharge}
#'   \item{total_emergency_admissions}{The total number of admissions to a hospital bed as an emergency}
#'   \item{emergency_admissions_over_4hours}{The number of patients seeking admission to a hospital bed as an emergency that spend over 4 hours from decision to admit to admission}
#'   \item{pct_attendance_over_4hours}{The percentage of attendance that spend over 4 hours from arrival to admission, transfer of discharge}
#'   \item{date}{Date}
#'   \item{pct_emergency_admissions_over_4hours}{The percentage of emergency admissions that spend over 4 hours from decision to admit to admission}
#'   ...
#' }
#' @details
#' Data notes:
#' - Due to a cyber-attack several sites have been unable to provide complete data since August 2022
#' - Fourteen trusts are field testing new A&E performance standards and as a result are not required to report attendances over four hours from May 2019
#'
#' @source \url{https://www.england.nhs.uk/}
"england_trust_accidents_emergency"

#' Critical care and General & Acute Beds
#'
#' A dataset containing NHS Trust level critical care and general and acute bed
#' availability information. This is taken from the urgent and emergency care
#' daily situation reports. Bed numbers are daily figures averaged over the
#' month.
#'
#' @format A data frame with 1,644 rows and 20 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{general_acute_beds_available}{"G&A beds available"}
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
"england_critical_general_acute_beds"

#' Hosptial ICB Discharge Data - Criteria to Reside
#'
#' A dataset containing NHS Integrated Care Board discharge data on how many
#' patients do not meet criteria to reside each day.
#'
#' @format A data frame with 17,892 rows and 3 variables:
#' \describe{
#'   \item{icb22_code}{Integrated Care Board code}
#'   \item{date}{Date}
#'   \item{do_not_meet_criteria_to_reside}{Number of patients who no longer meet the criteria to reside}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_icb_criteria_to_reside"

#' Hosptial Trust Discharge Data - Criteria to Reside
#'
#' A dataset containing NHS Trust level hopsital discharge data on how many
#' patients do not meet criteria to reside each day.
#'
#' @format A data frame with 51,515 rows and 3 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{do_not_meet_criteria_to_reside}{Number of patients who no longer meet the criteria to reside}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_trust_criteria_to_reside"

#' Hosptial ICB Discharge Data - Discharged Patients
#'
#' A dataset containing NHS Integrated Care Board discharge data on how many
#' patients were discharged each day.
#'
#' @format A data frame with 17,892 rows and 5 variables:
#' \describe{
#'   \item{icb22_code}{Integrated Care Board code}
#'   \item{date}{Date}
#'   \item{discharged_by_1700}{Number of patients discharged by 17:00}
#'   \item{discharged_between_1701_2359}{Number of patients discharged between 17:01 and 23:59}
#'   \item{discharged_total}{Total number of patients discharged}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_icb_discharged_patients"

#' Hosptial Trust Discharge Data - Discharged Patients
#'
#' A dataset containing NHS Trust level hopsital discharge data on how many
#' patients were discharged each day.
#'
#' @format A data frame with 51,515 rows and 5 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{discharged_by_1700}{Number of patients discharged by 17:00}
#'   \item{discharged_between_1701_2359}{Number of patients discharged between 17:01 and 23:59}
#'   \item{discharged_total}{Total number of patients discharged}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_trust_discharged_patients"

#' England Health Index (ONS)
#'
#' A dataset containing overall health index scores for the English lower tier
#' local authorities from 2015-2021.
#'
#' @format A data frame with 2,149 rows and 3 variables:
#' \describe{
#'   \item{ltla21_code}{2021 Lower tier local authority code}
#'   \item{year}{Year}
#'   \item{overall_score}{The overall health index score}
#'   ...
#' }
#' @source \url{https://www.ons.gov.uk/}
"england_health_index"

#' Physchological Therpaies - IAPT
#'
#' A dataset containing NHS Sub Integrated Care Board (formerly CCGs) data.
#'
#' @format A data frame with 8,162 rows and 4 variables:
#' \describe{
#'   \item{sicbl22_code}{Sub Integrated Care Board code}
#'   \item{date}{Date}
#'   \item{name}{Name of the variable}
#'   \item{value}{Value of the variable}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_sicb_iapt"

#' Physchological Therpaies - IAPT
#'
#' A dataset containing NHS Trust level IAPT data.
#'
#' @format A data frame with 5,082 rows and 4 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{name}{Name of the variable}
#'   \item{value}{Value of the variable}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_trust_iapt"

#' Consultant-led Referral to Treatment (RTT) by ICS/STP
#'
#' A dataset containing ICS/STP-level RTT data.
#'
#' @format A data frame with 27,196 rows and 7 variables:
#' \describe{
#'   \item{stp20_nhs_code}{NHS code for the ICS/STP}
#'   \item{stp20_name}{Name of the ICS/STP}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{treatment}{Treatment function name}
#'   \item{waits_over_18_weeks}{Total waiting > 18 weeks}
#'   \item{waits_over_52_weeks}{Total waiting > 52 weeks}
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_rtt_stp"

#' Consultant-led Referral to Treatment (RTT) by NHS Region
#'
#' A dataset containing ICS/STP-level RTT data.
#'
#' @format A data frame with 6,804 rows and 7 variables:
#' \describe{
#'   \item{nhs_region20_name}{Name of NHS England region}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{treatment}{Treatment function name}
#'   \item{waits_over_18_weeks}{Total waiting > 18 weeks}
#'   \item{waits_over_52_weeks}{Total waiting > 52 weeks}
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_rtt_region"

#' Consultant-led Referral to Treatment (RTT) pathway flow by ICS/STP
#'
#' A dataset containing ICS/STP-level RTT data.
#'
#' @format A data frame with 1,260 rows and 7 variables:
#' \describe{
#'   \item{stp20_nhs_code}{NHS code for the ICS/STP}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{completed}{Number of pathways completed}
#'   \item{incomplete}{Number of incomplete pathways}
#'   \item{new}{Number of new pathways}
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_rtt_flow_stp"

#' Bed Occupany
#'
#' A dataset containing Health and Social Care Trust level bed occupancy data.
#'
#' @format A data frame with 5 rows and 5 variables:
#' \describe{
#'   \item{trust18_code}{Health and Social Care Trust code code}
#'   \item{date}{Date}
#'   \item{beds_available_count}{Total number of available beds}
#'   \item{beds_occupied_count}{Total number of occupied beds}
#'   \item{beds_occupied_percentage}{The percentage of occupied beds}
#'   ...
#' }
#' @source \url{https://www.health-ni.gov.uk/}
"ni_bed_occupancy"

#' Bed Availability in Northern Ireland
#'
#' A dataset containing hospital statistics on bed availability, bed occupancy and inpatients data.
#'
#' @format A data frame with 13,237 rows and 17 variables:
#' \describe{
#'   \item{financial_year}{Financial year}
#'   \item{quarter_ending}{Quarter ending date}
#'   \item{HSC}{Health and Social Care Trust locations}
#'   \item{hospital}{Hospital name}
#'   \item{programme_of_care}{Programme of care}
#'   \item{specialty}{Specialty}
#'   \item{total_available_beds}{Total number of available beds}
#'   \item{average_available_beds}{Average number of available beds}
#'   \item{total_occupied_beds}{Total number of occupied beds}
#'   \item{average_occupied_beds}{Average number of occupied beds}
#'   \item{total_inpatients}{Total number of inpatients}
#'   \item{total_day_case}{Total number of day cases}
#'   \item{elective_inpatient}{Number of elective inpatients}
#'   \item{non_elective_inpatient}{Number of non-elective inpatients}
#'   \item{regular_attenders}{Number of regular attenders}
#'   \item{total_discharged_beds}{Total number of discharged beds}
#'   \item{average_discharged_beds}{Average number of discharged beds}
#' }
#' @source \url{https://www.health-ni.gov.uk/}
"ni_beds"

#' Consultant-led Referral to Treatment (RTT) by Health & Social Care Trust
#'
#' A dataset containing RTT data for Health & Social Care Trusts in NI.
#'
#' @format A data frame with 1,992 rows and 7 variables:
#' \describe{
#'   \item{hsct22_name}{Health & Social Care Trust name}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{specialty}{Specialty}
#'   \item{waits_over_18_weeks}{Total waiting > 18 weeks}
#'   \item{waits_over_52_weeks}{Total waiting > 52 weeks}
#' }
#' @source \url{https://www.health-ni.gov.uk/}
"ni_rtt_hsct"

#' Bed occupancy/availability in Scotland
#'
#' Beds by Board of Treatment and Specialty, 2016-2021.
#'
#' @format A data frame with 11,060 rows and 6 variables:
#' \describe{
#'   \item{hb19_code}{Scottish Health Board code}
#'   \item{date}{Date, representing the start of the quarter}
#'   \item{specialty}{Name of the specialty}
#'   \item{average_number_available_staffed_beds}{Daily average number of available staffed beds}
#'   \item{average_number_occupied_beds}{Daily average number of occupied beds}
#'   \item{percent_occupied_beds}{Percentage (%) of daily occupancy of beds}
#'   ...
#' }
#' @source \url{https://www.opendata.nhs.scot}
"scotland_beds"

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
#' @format A data frame with 41,310 rows and 6 variables:
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

#' Consultant-led Referral to Treatment (RTT) in Scotland
#'
#' A dataset containing RTT data for Scotland.
#'
#' @format A data frame with 144 rows and 5 variables:
#' \describe{
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{waits_over_18_weeks_count}{Total number waiting > 18 weeks}
#'   \item{waits_over_18_weeks_percent}{Percent waiting > 18 weeks}
#' }
#' @source \url{https://www.opendata.nhs.scot/}
"scotland_rtt"

#' Consultant-led Referral to Treatment (RTT) by Scottish Health Board
#'
#' A dataset containing RTT data for Scottish Health Boards.
#'
#' @format A data frame with 2,160 rows and 7 variables:
#' \describe{
#'   \item{hb19_code}{Scottish Health Board code}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{specialty}{Specialty}
#'   \item{waits_over_18_weeks_count}{Total number waiting > 18 weeks}
#'   \item{waits_over_18_weeks_percent}{Percent waiting > 18 weeks}
#' }
#' @source \url{https://www.opendata.nhs.scot/}
"scotland_rtt_hb"

#' Consultant-led Referral to Treatment (RTT) by Local Health Board
#'
#' A dataset containing RTT data for Wales.
#'
#' @format A data frame with 1,260 rows and 6 variables:
#' \describe{
#'   \item{lhb22_code}{Local Health Board code}
#'   \item{lhb22_name}{Local Health Board name}
#'   \item{date}{Date}
#'   \item{pathway_stage}{Stage of the treatment pathway}
#'   \item{waits_over_18_weeks}{Total waiting > 18 weeks}
#'   \item{waits_over_53_weeks}{Total waiting > 53 weeks}
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_rtt_lhb"

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

#' Wales health board bed availability - (2022)
#'
#' A dataset containing Welsh monthly NHS beds data by health board, measure,
#' and specialty
#'
#' @format A data frame with 633 rows and 7 variables:
#' \describe{
#'   \item{date}{Date}
#'   \item{health_board_code}{Local health board code}
#'   \item{health_board_name}{Name of local health board}
#'   \item{specialism}{Name of specialism}
#'   \item{daily_beds_available}{Average number of daily beds available}
#'   \item{daily_beds_occupied}{Average number of daily beds occucpied}
#'   \item{beds_occupancy_rate}{Bed occupancy rate}
#'
#'   ...
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_health_board_critical_general_acute_beds"

#' Wales hospital bed availability - (2022)
#'
#' A dataset containing Welsh monthly NHS beds data by hospital site, measure,
#' and specialty
#'
#' @format A data frame with 4171 rows and 7 variables:
#' \describe{
#'   \item{date}{Date}
#'   \item{hospital_code}{Local health board code}
#'   \item{hospital_name}{Name of local health board}
#'   \item{specialism}{Name of specialism}
#'   \item{daily_beds_available}{Average number of daily beds available}
#'   \item{daily_beds_occupied}{Average number of daily beds occucpied}
#'   \item{beds_occupancy_rate}{Bed occupancy rate}
#'
#'   ...
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_hospitals_critical_general_acute_beds"
