***********************************************************************************
** Title:	      AHA Data Input and Formating
** Author:        Kaylyn Sanbower
** Date created:  8/8/2019
** Date edited:   
***********************************************************************************
set more off

***********************************************************************************
/* Read and Clean AHA Data */
***********************************************************************************

import delimited "/Users/kaylynsanbower/Dropbox/Research-Projects/aha-data/data/input/AHA-2005_2017.csv", clear


*****************************
** 2005-2017 Data
rename v859 longi
drop dbegm dbegd dbegy dendm dendd dendy fism fisd fisy madmin telno netphone mlos
foreach x of varlist dtbeg dtend fisyr {
  gen `x'_clean=date(`x',"MDY")
  drop `x'
  rename `x'_clean `x'
  format `x' %td
}

tostring mloczip, replace
*replace systeln=subinstr(systeln,"-","",1)
*destring systeln, replace
gen fips=string(fstcd)+"_"+string(fcntycd)
sort fips
*rename npi_num npinum

** Hospital Characteristics
replace mngt=0 if mngt==.
replace netwrk=0 if netwrk==.
gen Own_Type=inrange(cntrl,12,16) + 2*inrange(cntrl,21,23) + 3*inrange(cntrl,30,33) + 4*inrange(cntrl,41,48)
gen Government=(Own_Type==1)
gen Nonprofit=(Own_Type==2)
gen Profit=(Own_Type==3)
gen Teaching_Hospital1=(mapp8==1) if mapp8!=.
gen Teaching_Hospital2=(mapp3==1 | mapp5==1 | mapp8==1 | mapp12==1 | mapp13==1)
gen System=(sysid!=. | mhsmemb==1)
gen Labor_Phys= ftemd
gen Labor_Residents=fteres
gen Labor_Nurse=ftern+ftelpn
gen Labor_Other=fteh-Labor_Phys-Labor_Residents-Labor_Nurse
replace Labor_Other=. if Labor_Other<=0

keep id mcrnum npinum sysid mname mlocaddr mloccity mlocstcd mloczip commty serv year fips lat longi hrrcode hsacode dtbeg dtend fisyr bdtot admtot ipdtot Teaching_Hospital1 Teaching_Hospital2 System Labor_* Profit Nonprofit Government divcode divname mcddc


export delimited /Users/kaylynsanbower/Dropbox/Research-Projects/aha-data/data/output/AHA-2005_2017-CLEAN.csv, replace


clear


***********************************************************************************
* All again for 2018 data, but there were some differences in the data structure 
***********************************************************************************

import delimited /Users/kaylynsanbower/Dropbox/Research-Projects/aha-data/data/input/AHA-2018.csv


*****************************
rename v860 longi
drop dbegm dbegd dbegy dendm dendd dendy fism fisd fisy madmin telno netphone mlos
foreach x of varlist dtbeg dtend fisyr {
  gen `x'_clean=date(`x',"MDY")
  drop `x'
  rename `x'_clean `x'
  format `x' %td
}

tostring mloczip, replace
*replace systeln=subinstr(systeln,"-","",1)
*destring systeln, replace
gen fips=string(fstcd)+"_"+string(fcntycd)
sort fips
*rename npi_num npinum

** Hospital Characteristics
replace mngt=0 if mngt==.
replace netwrk=0 if netwrk==.
gen Own_Type=inrange(cntrl,12,16) + 2*inrange(cntrl,21,23) + 3*inrange(cntrl,30,33) + 4*inrange(cntrl,41,48)
gen Government=(Own_Type==1)
gen Nonprofit=(Own_Type==2)
gen Profit=(Own_Type==3)
gen Teaching_Hospital1=(mapp8==1) if mapp8!=.
gen Teaching_Hospital2=(mapp3==1 | mapp5==1 | mapp8==1 | mapp12==1 | mapp13==1)
gen System=(sysid!=. | mhsmemb==1)
gen Labor_Phys= ftemd
gen Labor_Residents=fteres
gen Labor_Nurse=ftern+ftelpn
gen Labor_Other=fteh-Labor_Phys-Labor_Residents-Labor_Nurse
replace Labor_Other=. if Labor_Other<=0

keep id mcrnum npinum sysid mname mlocaddr mloccity mlocstcd mloczip commty serv year fips lat longi hrrcode hsacode dtbeg dtend fisyr bdtot admtot ipdtot Teaching_Hospital1 Teaching_Hospital2 System Labor_* Profit Nonprofit Government divcode divname mcddc


export delimited /Users/kaylynsanbower/Dropbox/Research-Projects/aha-data/data/output/AHA-2018-CLEAN.csv, replace 

