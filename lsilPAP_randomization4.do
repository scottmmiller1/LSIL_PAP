

* Balance tables after dropping Banke district
clear 
use "$d3/r_Baseline_Merged_Str_treat.dta"


lab var COMM6_1 "Co-op sends sale info by word-of-mouth"
lab var COMM6_2 "Co-op sends sale info by SMS to SHG leaders"
lab var COMM6_3 "Co-op sends sale info by SMS to members"
lab var COMM6_4 "Co-op sends sale info by phone call to SHG leaders"
lab var COMM6_5 "Co-op sends sale info by phone call to members"
lab var COMM6_6 "Co-op sends sale info by announcement at SHG meetings"
lab var COMM6_7 "Co-op sends sale info by announcement at general assembly"
lab var COMM6_8 "Co-op does not send sale info"

lab var COMM1a "No. of times initiated SHG contact by SMS in past month"
lab var COMM1b "No. of times initiated SHG contact by phone in past month"
lab var COMM1c "No. of times initiated SHG contact by email in past month"
lab var COMM1d "No. of times initiated SHG contact face-to-face in past month"

lab var COMM2a "No. of times SHG leader initiated contact by SMS in past month"
lab var COMM2b "No. of times SHG leader initiated contact by phone in past month"
lab var COMM2c "No. of times SHG leader initiated  contact by email in past month"
lab var COMM2d "No. of times SHG leader initiated contact face-to-face in past month"

foreach v of varlist COMM8a COMM8b ///
COMM8c COMM8d COMM8e ///
COMM8f {
	qui tab `v', g(`v'_)
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8a_`j' "Internet `i' limits communication"
	local ++j
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8b_`j' "Mobile network `i' limits communication"
	local ++j
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8c_`j' "Cost of SMS `i' limits communication"
	local ++j
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8d_`j' "Distance between members `i' limits communication"
	local ++j
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8e_`j' "Road quality `i' limits communication"
	local ++j
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8f_`j' "Access to transport `i' limits communication"
	local ++j
}

foreach v of varlist COMM6_1 COMM6_2 COMM6_3 ///
COMM6_4 COMM6_5 COMM6_6 ///
COMM6_7 COMM6_8 ///
COMM8a_1 COMM8b_1 ///
COMM8c_1 COMM8d_1 ///
COMM8e_1  COMM8f_1 ///
COMM1a COMM1b COMM1c ///
COMM1d ///
COMM2a COMM2b COMM2c ///
COMM2d {
	cap destring `v', replace
}
		

*iebaltable

* New code
drop if district == "Banke" 

iebaltab MAN3 REV4 totrev_member ///
		REC7 totcost_mem ///
		REC1 goatssold_mem GTT1 ///
		COMM6_1 COMM6_2 COMM6_3 ///
		COMM6_4 COMM6_5 COMM6_6 ///
		COMM6_7 COMM6_8 ///
		COMM8a_1 COMM8b_1 ///
		COMM8c_1 COMM8d_1 ///
		COMM8e_1  COMM8f_1 ///
		COMM1a COMM1b COMM1c ///
		COMM1d ///
		COMM2a COMM2b COMM2c ///
		COMM2d ///
		GTT2 GTT3, rowvarlabels grpvar(treat) ///
		save("/Users/scottmiller/Dropbox (UFL)/LSIL/Stata files/Baseline/Randomization/Randomization Summary Stats/iebaltab1_nobanke_clean.xlsx") replace


clear
use "$d3/Household_Merged_Edit_treat.dta"

replace HHR14 = . if HHR4 < 18

rename Co_opTransparencyTransparency_no Co_opTransparency_no
rename Live_EntexofemaleExotic_Female Live_Exotic_Female
rename Live_EntcrofemaleCross_Breed_Fem Live_Cross_Breed_Fem
rename Live_EntCro_breed_female_goats Live_breed_female_goats

foreach v of var * {
	cap local vv = subinstr("`v'", "Follow_up", "Follup",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Food_Consumption", "Food_Cons",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "_related_", "",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Enterprises", "Enterp",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "questionnaire", "",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	local l`v' : variable label `v'
	local ll`v': val lab `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
	}
}
lab var COM3 "No. of times in past 6 months receive info about livestock sales"

* Winsorize LS9 by treatment status
sum LS9, d

* treatment
sum LS9 if treat == 1, d
scalar t_99 = r(p99)

replace LS9 = t_99 if LS9 > t_99 & !missing(LS9) & treat == 1

*control
sum LS9 if treat == 0, d
scalar c_99 = r(p99)

replace LS9 = c_99 if LS9 > c_99 & !missing(LS9) & treat == 0

** Replace Missing values with zero LS9
replace LS9 = 0 if LS9 ==.


collapse (firstnm) LS9 LS8 ///
		co_opgoatno co_opsalevalue ///
		HHR14 HSE5 HSE10  ///
		MGT5 COM3 COM5 ///
		BR1 BR BR2 ///
		BR3 GP21 treat idx ID1, by(___id) 

foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

decode ID1, gen(district)

replace district = "Arghakanchhi" if ID1== 51
replace district = "Baglung" if ID1== 45
replace district = "Banke" if ID1== 57
replace district = "Bardiya" if ID1== 58
replace district = "Chitwan" if ID1== 35
replace district = "Dang" if ID1== 56
replace district = "Dhading" if ID1== 30 
replace district = "Kaski" if ID1== 40
replace district = "Kapilbastu" if ID1== 50
replace district = "Lamjung" if ID1== 37
replace district = "Mahottari" if ID1== 18
replace district = "Morang" if ID1== 5
replace district = "Nawalparasi" if ID1== 48
replace district = "Nuwakot" if ID1== 28
replace district = "Palpa" if ID1== 47
replace district = "Parbat" if ID1== 44
replace district = "Pyuthan" if ID1== 52
replace district = "Rautahat" if ID1== 32
replace district = "Rupandehi" if ID1== 49
replace district = "Salyan" if ID1== 55
replace district = "Sarlahi" if ID1== 19
replace district = "Sindhuli" if ID1== 20
replace district = "Surkhet" if ID1== 59
replace district = "Tanahu" if ID1== 38

 
gen region = "Mid-Hills" if district=="Arghakanchhi" | district=="Baglung" | ///
	district=="Dhading" | district =="Kaski" | district =="Lamjung" | district=="Nuwakot" | ///
	district=="Palpa" | district =="Parbat" | district =="Pyuthan" | district =="Salyan" | ///
	district=="Tanahu" | district =="Sindhuli"
	 
replace region = "Terai" if district=="Banke" | district =="Bardiya" | district =="Kapilbastu" | ///
	district=="Mahottari" | district =="Morang" | district =="Nawalparasi" | ///
	district=="Rautahat" | district =="Rupandehi" | district=="Sarlahi" | district =="Surkhet" | ///
	district =="Chitwan" | district =="Dang"


*iebaltable

* New code
drop if district == "Banke" 

iebaltab LS9 LS8 ///
		co_opgoatno co_opsalevalue ///
		HHR14 HSE5 HSE10  ///
		MGT5 COM3 COM5 ///
		BR1 BR BR2 ///
		BR3 GP21, rowvarlabels ///
		grpvar(treat) vce(cluster idx)  ///
		save("/Users/scottmiller/Dropbox (UFL)/LSIL/Stata files/Baseline/Randomization/Randomization Summary Stats/iebaltab2_nobanke_clean3.xlsx") replace

