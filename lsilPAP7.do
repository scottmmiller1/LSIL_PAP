
clear 
use "$d3/r_CO_Merged_Ind.dta"


* Balance tables after dropping Banke district
clear 
use "$d3/r_CO_Merged_Ind_treat.dta"


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


lab var revenue "Co-op Revenue (USD)"
lab var rev_member "Co-op Revenue per Member (USD)"
lab var costs "Co-op Costs (UDS)"
lab var cost_mem "Co-op Costs per Member (USD)"
lab var net_rev "Co-op Net Revenue (UDS)"
lab var net_rev_member "Co-op Net Revenue per Member (USD)"
lab var goats_sold "Co-op Goats Sold"
lab var goatssold_mem "Co-op Goats Sold per Member"
lab var MAN3 "\# of Members"
lab var PNG1 "Does the cooperative have a written business plan?"
lab var PNG2 "Planning Tume Horizon (Years)"
lab var PNG3 "Expected Goats Sold over next 6 months"
lab var expected_rev "Expected Revenue over next 6 months (USD)"
lab var index_PNG "Planning & Goals Summary Index"
lab var CO_TRN1 "Co-op makes its mandate available to its members"
lab var CO_TRN2 "Co-op makes its annual report available to its members"
lab var CO_TRN3 "Co-op makes its annual budget available to its members"
lab var CO_TRN4 "Co-op makes its financial report available to its members"
lab var CO_TRN5 "Co-op makes its meeting minutes available to its members"
lab var CO_TRN6 "Co-op makes its election results available to its members"
lab var CO_TRN7 "Co-op makes its sale records available to its members"
lab var GTT1 "% of goats expected to be sold through co-op"
lab var GTT2 "% of goats expected to be sold through other channels"
lab var GTT3 "% of goats expected to not be sold"

*iebaltable

iebaltab revenue rev_member costs cost_mem net_rev net_rev_member ///
		goats_sold goatssold_mem MAN3 ///
		PNG1 PNG2 PNG3 expected_rev index_PNG ///
		COMM6_1 COMM6_2 ///
		COMM6_4 COMM6_5 COMM6_6 ///
		COMM6_7 COMM6_8 ///
		COMM8a_1 COMM8b_1 ///
		COMM8c_1 COMM8d_1 ///
		COMM8e_1  COMM8f_1 ///
		CO_TRN1 CO_TRN2 CO_TRN3 CO_TRN4 CO_TRN5 ///
		CO_TRN6 CO_TRN7 ///
		GTT1 GTT2 GTT3, rowvarlabels grpvar(treat) ///
		savetex("/Users/scottmiller/Dropbox (UFL)/LSIL/Pre-Analysis Plan/Stata Files/iebaltab1_nobanke_PAP.tex") replace

	
* ------------------------------------------------
		
* Household Data		
clear
use "$d3/r_HH_Merged_Ind_treat.dta"

replace HHR14 = . if HHR4 < 18

*rename Co_opTransparencyTransparency_no Co_opTransparency_no
*rename Live_EntexofemaleExotic_Female Live_Exotic_Female
*rename Live_EntcrofemaleCross_Breed_Fem Live_Cross_Breed_Fem
*rename Live_EntCro_breed_female_goats Live_breed_female_goats

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


* ----------------------------------------------------------
* Winsorize LS9 by true treatment status
sum LS9, d

* treatment
sum LS9 if treat == 1, d
scalar t_99 = r(p99)

replace LS9 = t_99 if LS9 > t_99 & !missing(LS9) & treat == 1

*control
sum LS9 if treat == 0, d
scalar c_99 = r(p99)

replace LS9 = c_99 if LS9 > c_99 & !missing(LS9) & treat == 0

** Replace Missing values with zero 
* LS9 , 
replace LS9 = 0 if LS9 ==.
replace co_opsalevalue = 0 if co_opsalevalue ==.
* ---------------------------------------------------------


foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}


lab var COM3 "HH Info Sales"
lab var COM8 "HH Info Activities"
lab var index_HH_comm "Communication Summary Index"
lab var LS8 "Goats Sold"
lab var LS9 "Goats Revenue (USD)"
lab var co_opgoatno "Goats Sold through Co-op"
lab var co_opsalevalue "Goat Revenue through Co-op (USD)"
lab var net_goat_income "Net Goat Income (USD)"
lab var index_HH_goatsales "Goat Sales Summary Index"
lab var visits_sale "Trader Visits per Sale"
lab var time_passed "Time between Contact & Sale (Days)"
lab var transp_cost "Transportation Costs (USD)"
lab var index_salecost "Sales Cost Summary Index"
lab var index_dTRN "Transparency Discrepancy Summary Index"



*iebaltable

iebaltab COM3 COM8 index_HH_comm ///
		LS8 LS9 co_opgoatno co_opsalevalue ///
		net_goat_income index_HH_goatsales ///
		visits_sale time_passed transp_cost index_salecost ///
		index_dTRN ///
		HHR14 HSE5 HSE10  ///
		MGT5 ///
		BR BR2, rowvarlabels ///
		grpvar(treat) vce(cluster idx)  ///
		savetex("/Users/scottmiller/Dropbox (UFL)/LSIL/Pre-Analysis Plan/Stata Files/iebaltab2_nobanke_PAP.tex") replace
		
		
		
		
		
		
