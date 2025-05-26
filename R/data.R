#' @importFrom tibble tibble
NULL

#' England Attribution from Type 3 A&E Providers to Acute Trusts (updated June 2022)
#'
#' A dataset mapping proportion of A&E attendances attributed to Acute Trusts from Type 3 A&E Providers,
#' including Minor Injury Units and Walk-in Centres
#'
#' @format A data frame with 218 rows and 3 variables:
#' \describe{
#'   \item{nhs_trust22_code_all}{NHS Trust (organisational) code}
#'   \item{nhs_trust22_code_acute}{NHS Trust (organisational) code - Acute Trusts only}
#'   \item{proportion_attendances_attributed_to_acute_trust}{Percentage of A&E attendances attributed to the Acute Trust}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_ae_acute_trust_attribution"

#' England Accident and Emergency Admissions by Integrated Care Board  - (2022-23)
#'
#' A dataset containing England Accident and Emergency attendances and Emergency Admissions at Integrated Care Board level, by month
#'
#' @format A data frame with 882 rows and 8 variables:
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
#' @format A data frame with 5,044 rows and 8 variables:
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
#' @format A data frame with 2,862 rows and 20 variables:
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

#' Disability by LTLA for England, 2021
#'
#' A dataset containing LTLA data on numbers disabled under the Equality Act.
#'
#' @format A data frame with 45,106 rows and 5 variables:
#' \describe{
#'   \item{nhs_trust22_name}{NHS Trust name}
#'   \item{nhs_trust22_code}{NHS Trust code}
#'   \item{date}{Date in the format year-month-day}
#'   \item{delay_reason}{The reason for the delayed discharge}
#'   \item{delay_count}{The number of delays}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/statistics/statistical-work-areas/discharge-delays/acute-discharge-situation-report/}
"england_delayed_discharge_reasons"

#' Disability by LTLA for England, 2021
#'
#' A dataset containing LTLA data on numbers disabled under the Equality Act.
#'
#' @format A data frame with 662 rows and 5 variables:
#' \describe{
#'   \item{ltla21_code}{LTLA code}
#'   \item{total_residents}{Total residents in the local authority}
#'   \item{disability_level}{Disabled or Not disabled under the Equality Act}
#'   \item{n}{number of people}
#'   \item{prop}{proportion of people}
#'   ...
#' }
#' @source \url{https://www.nomisweb.co.uk/sources/census_2021_bulk}
"england_disability_21"

#' Hospital ICB Discharge Data - Criteria to Reside
#'
#' A dataset containing NHS Integrated Care Board discharge data on how many
#' patients do not meet criteria to reside each day.
#'
#' @format A data frame with 26,758 rows and 3 variables:
#' \describe{
#'   \item{icb22_code}{Integrated Care Board code}
#'   \item{date}{Date}
#'   \item{do_not_meet_criteria_to_reside}{Number of patients who no longer meet the criteria to reside}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_icb_criteria_to_reside"

#' Hospital Trust Discharge Data - Criteria to Reside
#'
#' A dataset containing NHS Trust level hopsital discharge data on how many
#' patients do not meet criteria to reside each day.
#'
#' @format A data frame with 77,011 rows and 3 variables:
#' \describe{
#'   \item{nhs_trust22_code}{NHS Trust (organisational) code}
#'   \item{date}{Date}
#'   \item{do_not_meet_criteria_to_reside}{Number of patients who no longer meet the criteria to reside}
#'   ...
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_trust_criteria_to_reside"

#' Hospital ICB Discharge Data - Discharged Patients
#'
#' A dataset containing NHS Integrated Care Board discharge data on how many
#' patients were discharged each day. From June 2023 figures for discharged by
#' 17:00 and between 17:01 and 23:59 were no longer released.
#'
#' @format A data frame with 26,758 rows and 5 variables:
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
#' @format A data frame with 77,011 rows and 5 variables:
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
#' @format A data frame with 2,149 rows and 6 variables:
#' \describe{
#'   \item{ltla21_code}{2021 Lower tier local authority code}
#'   \item{year}{Year}
#'   \item{overall_score}{The overall health index score}
#'   \item{healthy_people_domain_score}{Score for the Healthy People domain}
#'   \item{healthy_lives_domain_score}{Score for the Healthy Lives domain}
#'   \item{healthy_places_domain_score}{Score for the Healthy Places domain}
#'   ...
#' }
#' @source \url{https://www.ons.gov.uk/}
"england_health_index"

#' England Health Index (ONS) - subdomains
#'
#' A dataset containing subdomain health index scores for the English lower tier
#' local authorities from 2015-2021.
#'
#' @format A data frame with 2,149 rows and 16 variables:
#' \describe{
#'   \item{ltla21_code}{2021 Lower tier local authority code}
#'   \item{year}{Year}
#'   \item{Difficulties in daily life}{Difficulties in daily life - Health People domain}
#'   \item{Mental health}{Mental health - Health People domain}
#'   \item{Mortality}{Mortality - Health People domain}
#'   \item{Personal well-being}{Personal well-being - Health People domain}
#'   \item{Physical health conditions}{Physical health conditions - Health People domain}
#'   \item{Behavioural risk factors}{Behavioural risk factors - Health Lives domain}
#'   \item{Children and young people}{Children and young people - Health Lives domain}
#'   \item{Physiological risk factors}{Physiological risk factors - Health Lives domain}
#'   \item{Protective measures}{Protective measures - Health Lives domain}
#'   \item{Access to green space}{Access to green space - Health Places domain}
#'   \item{Access to services}{Access to services - Health Places domain}
#'   \item{Crime}{Crime - Health Places domain}
#'   \item{Economic and working conditions}{Economic and working conditions - Health Places domain}
#'   \item{Living conditions}{Living conditions - Health Places domain}
#'   ...
#' }
#' @source \url{https://www.ons.gov.uk/}
"england_health_index_subdomains"

#' England Health Index (ONS) - underlying indicators
#'
#' A dataset containing underlying indicators for the ONS Health Index for
#' English lower tier local authorities from 2015-2021.
#'
#' @format A data frame with 120,344 rows and 4 variables:
#' \describe{
#'   \item{ltla21_code}{2021 Lower tier local authority code}
#'   \item{year}{Year}
#'   \item{indicator}{The name of the indicator}
#'   \item{value}{The value of the indicator}
#'   ...
#' }
#' @source \url{https://www.ons.gov.uk/}
"england_health_index_indicators"

#' England Health Index (ONS)
#'
#' A dataset containing overall health index scores for the English Integrated
#' Care Boards from 2015-2021.
#'
#' @format A data frame with 294 rows and 7 variables:
#' \describe{
#'   \item{icb22_code}{2022 Integrated Care Board code}
#'   \item{icb22_name}{2022 Integrated Care Board name}
#'   \item{year}{Year}
#'   \item{overall_score}{The overall health index score}
#'   \item{healthy_people_domain_score}{Score for the Healthy People domain}
#'   \item{healthy_lives_domain_score}{Score for the Healthy Lives domain}
#'   \item{healthy_places_domain_score}{Score for the Healthy Places domain}
#'   ...
#' }
#' @source \url{https://www.ons.gov.uk/}
"england_health_index_ics"

#' England Health Index (ONS) - subdomains
#'
#' A dataset containing subdomain health index scores for the English Integrated
#' Care Boards from 2015-2021.
#'
#' @format A data frame with 4,116 rows and 5 variables:
#' \describe{
#'   \item{icb22_code}{2022 Integrated Care Board code}
#'   \item{icb22_name}{2022 Integrated Care Board name}
#'   \item{year}{Year}
#'   \item{sub_domain}{The name of the subdomain}
#'   \item{value}{The value of the indicator}
#'   ...
#' }
#' @source \url{https://www.ons.gov.uk/}
"england_health_index_ics_indicators"

#' England Health Index (ONS) - underlying indicators
#'
#' A dataset containing underlying indicators for the ONS Health Index for
#' English Integrated Care Boards from 2015-2021.
#'
#' @format A data frame with 16,464 rows and 5 variables:
#' \describe{
#'   \item{icb22_code}{2022 Integrated Care Board code}
#'   \item{icb22_name}{2022 Integrated Care Board name}
#'   \item{year}{Year}
#'   \item{indicator}{The name of the indicator}
#'   \item{value}{The value of the indicator}
#'   ...
#' }
#' @source \url{https://www.ons.gov.uk/}
"england_health_index_ics_indicators"

#' Legal Partnership Status, England, 2021
#'
#' A dataset containing legal partnership status data at LTLA level
#'
#' @format A data frame with 5,627 rows and 5 variables:
#' \describe{
#'   \item{ltla21_code}{LTLA code}
#'   \item{total_population}{Population in the LTLA}
#'   \item{legal_partnership}{Type of legal partnership}
#'   \item{n}{Number of people}
#'   \item{prop}{Percentage}
#' }
#' @source \url{https://www.nomisweb.co.uk/sources/census_2021_bulk}
"england_legal_partnership_21"

#' Sexual orientation, England, 2021
#'
#' A dataset containing sexual orientation data at LTLA level
#'
#' @format A data frame with 1,655 rows and 5 variables:
#' \describe{
#'   \item{ltla21_code}{LTLA code}
#'   \item{total_residents}{Residents in the LTLA}
#'   \item{sexual_orientation}{Sexual orientation}
#'   \item{n}{Number of people}
#'   \item{prop}{Percentage}
#' }
#' @source \url{https://www.nomisweb.co.uk/sources/census_2021_bulk}
"england_sexual_orientation_21"


#' Psychological Therapies - IAPT
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
#' A dataset containing ICS/STP-level RTT data spanning from Apr 2020 to Feb
#' 2025.
#'
#' @format A data frame with 55,73 rows and 7 variables:
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
#' A dataset containing ICS/STP-level RTT data spanning from Jan 2019 to Feb
#' 2025.
#'
#' @format A data frame with 11,676 rows and 7 variables:
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

#' Consultant-led Referral to Treatment (RTT) by NHS Trust
#'
#' A dataset containing ICS/STP-level RTT data spanning from Jan 2019 to Feb
#' 2025.
#'
#' @format A data frame with 11,676 rows and 7 variables:
#' \describe{
#'   \item{nhs_trust22_code}{Code of NHS England trust}
#'   \item{nhs_trust22_name}{Name of NHS England trust}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{treatment}{Treatment function name}
#'   \item{waits_over_18_weeks}{Total waiting > 18 weeks}
#'   \item{waits_over_52_weeks}{Total waiting > 52 weeks}
#' }
#' @source \url{https://www.england.nhs.uk/}
"england_rtt_trust"

#' Consultant-led Referral to Treatment (RTT) pathway flow by ICS/STP
#'
#' A dataset containing ICS/STP-level RTT data spanning from Apr 2020 to Feb
#' 2025.
#'
#' @format A data frame with 2,478 rows and 7 variables:
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

#' Statutory homelessness in England
#'
#' A dataset containing statistics on households assessed as homeless and
#' households in temporary accommodation, by Local Authority.
#'
#' @format A data frame with 3 variables:
#' \describe{
#'   \item{ltla23_code}{Local Authority code}
#'   \item{Households assessed as homeless per (000s)}{Households assessed as homeless per 1,000 households in the Local Authority}
#'   \item{Households in temporary accommodation per 1,000}{Households in temporary accommodation per 1,000 households in the Local Authority}
#' }
#' @source \url{https://www.gov.uk/government/statistical-data-sets/live-tables-on-homelessness}
"england_homelessness"

#' Crime severity score in England
#'
#' Crime severity score is based on sentencing data, community order and fines.
#' Higher scores mean greater severity within an area.
#'
#' @format A data frame containing 2 columns.
#' \describe{
#'   \item{ltla23_code}{Local Authority code}
#'   \item{crime_severity_score}{Crime severity score (higher = more severe)}
#' }
#' @source \url{https://www.ons.gov.uk/peoplepopulationandcommunity/crimeandjustice/datasets/crimeseverityscoreexperimentalstatistics}
"england_crime_severity"


#' Underdoctored areas in England
#'
#' A dataset containing the ratio of patients to GP workforce, by Local Authority
#'
#' @format A data frame with 4 variables:
#' \describe{
#'   \item{ltla24_code}{Local Authority code (2024)}
#'   \item{total_patients}{Number of registered patients}
#'   \item{total_gp_fte}{Number of full-time equivalent GPs}
#'   \item{patients_per_gp}{Number of patients per GP}
#' }
"england_underdoctored_areas"

#' Underdoctored areas in Wales
#'
#' A dataset containing the ratio of patients to GP workforce, by Local Authority
#'
#' @format A data frame with 4 variables:
#' \describe{
#'   \item{ltla24_code}{Local Authority code (2024)}
#'   \item{total_patients}{Number of registered patients}
#'   \item{total_gp}{Number of GPs}
#'   \item{patients_per_gp}{Number of patients per GP}
#' }
"wales_underdoctored_areas"


#' Bed Availability in Northern Ireland
#'
#' A dataset containing hospital statistics on bed availability, bed occupancy
#' and inpatients data.
#'
#' @format A data frame with 13,327 rows and 14 variables:
#' \describe{
#'   \item{trust18_code}{Health and Social Care Trust code}
#'   \item{date}{Quarter ending date}
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
#' }
#' @source \url{https://www.health-ni.gov.uk/}
"ni_beds"

#' Provision of unpaid care (delayed discharge) in Northern Ireland
#'
#' A dataset containing unpaid care data in Local Government Districts in NI
#' from 2021 census.
#'
#' @format A data frame with 605 rows and 4 variables:
#' \describe{
#'   \item{ltla21_name}{Local Government Districts name}
#'   \item{ltla21_code}{Local Government Districts code}
#'   \item{variable}{Age band and count/percentage of unpaid care hours}
#'   \item{value}{Value of the chosen variable}
#'   ...
#' }
#' @source \url{https://www.nisra.gov.uk/}
"ni_unpaid_care_21"

#' Consultant-led Referral to Treatment (RTT) by Health & Social Care Trust
#'
#' A dataset containing RTT data for Health & Social Care Trusts in NI.
#'
#' @format A data frame with 2,706 rows and 7 variables:
#' \describe{
#'   \item{hsct22_name}{Health & Social Care Trust name}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{specialty}{Specialty}
#'   \item{waits_over_18_weeks}{Total waiting > 18 weeks}
#'   \item{waits_over_52_weeks}{Total waiting > 52 weeks}
#'   \item{total_waits}{Total waits}
#' }
#' @source \url{https://www.health-ni.gov.uk/topics/doh-statistics-and-research/hospital-waiting-times-statistics}
"ni_rtt_hsct"

#' Bed occupancy/availability in Scotland
#'
#' Beds by Board of Treatment and Specialty, 2016-2022.
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
#' @format A data frame with 20,025 rows and 6 variables:
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
#' @format A data frame with 153 rows and 5 variables:
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
#' @format A data frame with 2,295 rows and 7 variables:
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


#' Disability by LTLA for Wales, 2021
#'
#' A dataset containing LTLA data on numbers disabled under the Equality Act.
#'
#' @format A data frame:
#' \describe{
#'   \item{ltla21_code}{LTLA code}
#'   \item{total_residents}{Total residents in the local authority}
#'   \item{disability_level}{Disabled or Not disabled under the Equality Act}
#'   \item{n}{number of people}
#'   \item{prop}{proportion of people}

#'   ...
#' }
#' @source \url{https://www.nomisweb.co.uk/sources/census_2021_bulk}
"wales_disability_21"
#' Homelessness in Scotland
#'
#' A dataset containing statistics on households assessed as homeless and
#' households in temporary accommodation, by Local Authority.
#'
#' @format A data frame with 3 variables:
#' \describe{
#'   \item{ltla21_code}{Local Authority code}
#'   \item{Assessed as homeless or threatened with homelessness per 1,000}{Households assessed as homeless per 1,000 households in the Local Authority}
#'   \item{Households in temporary accommodation per 1,000}{Households in temporary accommodation per 1,000 households in the Local Authority}
#' }
#' @source \url{https://www.gov.scot/collections/homelessness-statistics/}
"scotland_homelessness"

#' Emergency department performance statistics
#'
#' A dataset containing performance against waiting times targets by hospital.
#'
#' @format A data frame with 72,171 rows and 5 variables:
#' \describe{
#'   \item{hospital_code}{Hospital code}
#'   \item{hospital_department}{Hospital or department name}
#'   \item{date}{Date}
#'   \item{performance_measure}{Performance measure}
#'   \item{performance_target}{Performance taget}
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_ae_performance"

#' Underdoctored areas in Scotland
#'
#' A dataset containing the ratio of patients to GP workforce, by Local Authority
#'
#' @format A data frame with 4 variables:
#' \describe{
#'   \item{ltla21_code}{Local Authority code (2021)}
#'   \item{total_gp}{Number of full-time equivalent GPs}
#'   \item{total_patients}{Number of registered patients}
#'   \item{patients_per_gp}{Number of patients per GP}
#' }
"scotland_underdoctored_areas"

#' Consultant-led Referral to Treatment (RTT) by Local Health Board
#'
#' A dataset containing RTT data for Wales.
#'
#' @format A data frame with 1,652 rows and 6 variables:
#' \describe{
#'   \item{lhb22_code}{Local Health Board code}
#'   \item{lhb22_name}{Local Health Board name}
#'   \item{date}{Date}
#'   \item{pathway_stage}{Stage of the treatment pathway}
#'   \item{waits_over_18_weeks}{Total waiting > 18 weeks}
#'   \item{waits_over_53_weeks}{Total waiting > 53 weeks}
#'   \item{total_waits}{Total waiting}
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_rtt_lhb"

#' Wales ambulance waiting times - (2022)
#'
#' A dataset containing Welsh emergency ambulance calls and responses to red
#' calls, by local health boards (HB) and month
#'
#' @format A data frame with 288 rows and 9 variables:
#' \describe{
#'   \item{date}{Date}
#'   \item{hb_code}{Local health board code}
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
#' @format A data frame with 3,103 rows and 7 variables:
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
#' @format A data frame with 7,517 rows and 7 variables:
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

#' Legal Partnership Status, Wales, 2021
#'
#' A dataset containing legal partnership status data at LTLA level
#'
#' @format A data frame:
#' \describe{
#'   \item{ltla21_code}{LTLA code}
#'   \item{total_population}{Population in the LTLA}
#'   \item{legal_partnership}{Type of legal partnership}
#'   \item{n}{Number of people}
#'   \item{prop}{Percentage}
#' }
#' @source \url{https://www.nomisweb.co.uk/sources/census_2021_bulk}
"wales_legal_partnership_21"

#' Sexual orientation, Wales, 2021
#'
#' A dataset containing sexual orientation data at LTLA level
#'
#' @format A data frame:
#' \describe{
#'   \item{ltla21_code}{LTLA code}
#'   \item{total_residents}{Residents in the LTLA}
#'   \item{sexual_orientation}{Sexual orientation}
#'   \item{n}{Number of people}
#'   \item{prop}{Percentage}
#' }
#' @source \url{https://www.nomisweb.co.uk/sources/census_2021_bulk}
"wales_sexual_orientation_21"
#' Homelessness in Wales
#'
#' A dataset containing statistics on households assessed as homeless and
#' households in temporary accommodation, by Local Authority.
#'
#' @format A data frame with 3 variables:
#' \describe{
#'   \item{ltla21_code}{Local Authority code}
#'   \item{Homeless or threatened with homelessness per 1,000}{Households assessed as homeless per 1,000 households in the Local Authority}
#'   \item{Households in temporary accommodation per 1,000}{Households in temporary accommodation per 1,000 households in the Local Authority}
#' }
#' @source \url{https://statswales.gov.wales/}
"wales_homelessness"

#' Crime severity score in Wales
#'
#' Crime severity score is based on sentencing data, community order and fines.
#' Higher scores mean greater severity within an area.
#'
#' @format A data frame containing 2 columns.
#' \describe{
#'   \item{ltla23_code}{Local Authority code}
#'   \item{crime_severity_score}{Crime severity score (higher = more severe)}
#' }
#' @source \url{https://www.ons.gov.uk/peoplepopulationandcommunity/crimeandjustice/datasets/crimeseverityscoreexperimentalstatistics}
"wales_crime_severity"

#' Scotland A&E Admission Outcomes
#'
#' A dataset containing Scotland hospital-level admission outcomes stratified by age group (from 2018-01 to 2025-02)
#'
#' @format A data frame with 86,688 rows and 6 variables:
#' \describe{
#'   \item{hospital_code}{Hospital code}
#'   \item{hospital_name}{Hospital name}
#'   \item{date}{Date}
#'   \item{admission}{Admission outcome}
#'   \item{age}{Age group}
#'   \item{attendances}{Total number of attendances falling into each category}
#'   ...
#' }
#' @source \url{https://publichealthscotland.scot/healthcare-system/urgent-and-unscheduled-care/accident-and-emergency/downloads-and-open-data/our-downloads/}
"scotland_ae_admission"

#' Scotland A&E attendances
#'
#' A dataset of hospital-level A&E attendances and waiting times for Scotland (from 2007-07 to 2025-02).
#'
#' @format A data frame with 17,844 rows and 6 variables:
#' \describe{
#'   \item{hospital_code}{Hospital code}
#'   \item{hospital_name}{Hospital name}
#'   \item{date}{Date}
#'   \item{attendances}{Number of total attendances}
#'   \item{within_4_hours}{Number of attendances lasting less than 4 hours}
#'   \item{over_4_hours}{Number of attendances lasting more than 4 hours}
#'   ...
#' }
#' @source \url{https://publichealthscotland.scot/healthcare-system/urgent-and-unscheduled-care/accident-and-emergency/downloads-and-open-data/our-downloads/}
"scotland_ae_attendance"

#' Delayed discharge reasons for Wales, 2023 April - 2025 March
#'
#' A dataset containing delayed discharge data stratified by local health board and the reason for delay.
#'
#' @format A data frame with 5,220 rows and 5 variables:
#' \describe{
#'   \item{lhb22_code}{Health Board code}
#'   \item{lhb22_name}{Health Board name}
#'   \item{date}{Date in the format year-month-day}
#'   \item{delay_reason}{The reason for the delayed discharge}
#'   \item{delay_count}{The number of delays}
#'   ...
#' }
#' @source \url{https://statswales.gov.wales/Catalogue/Health-and-Social-Care/NHS-Performance/pathway-of-care-delays/pathwayofcaredelays-by-localhealthboardprovider-date}
"wales_delayed_discharge_reasons"

#' Northern Ireland Emergency Care Waiting Times
#'
#' Emergency care waiting times for departments (hospitals) in Norther Ireland Health & Social Care Trusts.
#'
#' @format A data frame containing 8 columns.
#' \describe{
#'   \item{trust18_code}{Health and Social Care Trust code}
#'   \item{trust18_name}{Health and Social Care Trust name}
#'   \item{department}{Department name}
#'   \item{date}{Date}
#'   \item{total}{Total attendances}
#'   \item{under_4_hours}{Attendances with waiting times under 4 hours}
#'   \item{between_4_12_hours}{Attendances with waiting times between 4 and 12 hours}
#'   \item{over_12_hours}{Attendances with waiting times over 12 hours}
#' }
#' @source \url{https://datavis.nisra.gov.uk/health/ni-emergency-care-waiting-times-data-oct-dec-24.html#table}
"ni_waiting_times"

#' Care at Home in Scotland
#'
#' Scotland Health-Board level data for the number of people (per 1,000 population) supported by care at home (from 2018-Q1 to 2024-Q1).
#'
#' @format A data frame containing 800 rows and 4 columns.
#' \describe{
#'   \item{ltla24_code}{2024 Lower tier local authority code}
#'   \item{ltla24_name}{2024 Lower tier local authority name}
#'   \item{date}{Date}
#'   \item{care_at_home_per_1000}{Number of people (per 1,000 population) receiving care at home}
#' }
#' @source \url{https://publichealthscotland.scot/publications/care-at-home-statistics-for-scotland/care-at-home-statistics-for-scotland-support-and-services-funded-by-health-and-social-care-partnerships-in-scotland-20232024/dashboard/}
"scotland_care_at_home"

#' Underdoctored areas in Northern Ireland
#'
#' A dataset containing the ratio of patients to GP workforce, by Local Authority
#'
#' @format A data frame with 6 variables:
#' \describe{
#'   \item{ltla21_code}{Local Authority code (2021)}
#'   \item{ltla21_name}{Local Authority name (2021)}
#'   \item{date}{year}
#'   \item{total_patients}{Number of registered patients}
#'   \item{total_gp}{Number of GPs}
#'   \item{patients_per_gp}{Number of patients per GP}
#' }
"ni_underdoctored_areas"
