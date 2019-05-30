
/*******************************************************************************
lsilPAP7.d0		
					
- Generates balance tables
	
*******************************************************************************/


* Balance tables after dropping Banke district
clear 
use "$d3/r_CO_Merged_Ind.dta"


foreach v of varlist COMM8b COMM8d {
	qui tab `v', g(`v'_)
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8b_`j' "Mobile network `i' limits communication"
	local ++j
}

local j 1
foreach i in seriously somewhat "doesn't" {
	lab var COMM8d_`j' "Distance between members `i' limits communication"
	local ++j
}


foreach v of varlist COMM8b_1 COMM8d_1 {
	cap destring `v', replace
}

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

lab var MAN3 "Members"
lab var goats_sold "Co-op Goats Sold"
lab var revenue "Co-op Revenue (USD)"
lab var ICTassets "Total number of ICT assets"
lab var Otherassets "Total number of non-ICT assets"


*iebaltable

iebaltab COMM8b_1 COMM8d_1 ///
		PNG1 PNG2 PNG3 expected_rev index_PNG ///
		CO_TRN1 CO_TRN2 CO_TRN3 CO_TRN4 CO_TRN5 ///
		CO_TRN6 CO_TRN7 ///
		MAN3 goats_sold revenue ICTassets Otherassets, rowvarlabels grpvar(treat) ///
		savetex("$d2/iebaltab1_nobanke_PAP.tex") replace


* ------------------------------------------------
		
* Household Data		
clear
use "$d3/r_HH_Merged_Ind.dta"


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


destring MGT4, replace

lab var COM3 "HH Info Sales"
lab var COM8 "HH Info Activities"
lab var index_HHcomm "Communication Summary Index"
lab var LS8 "Goats Sold"
lab var LS9 "Goats Revenue (USD)"
lab var co_opgoatno "Goats Sold through Co-op"
lab var co_opsalevalue "Goat Revenue through Co-op (USD)"
lab var net_goat_income "Net Goat Income (USD)"
lab var index_HH_goatsales "Goat Sales Summary Index"
lab var index_dTRN "Transparency Discrepancy Summary Index"
lab var HHR4 "Age"
lab var HHR14 "Literacy"
lab var MEM11 "SHG Meetings Attended in Past 6 Months"
lab var MGT4 "Trust Cooperative Leadership"
lab var HH_TRN1 "Co-op makes its mandate available to its members"
lab var HH_TRN2 "Co-op makes its annual report available to its members"
lab var HH_TRN3 "Co-op makes its annual budget available to its members"
lab var HH_TRN4 "Co-op makes its financial report available to its members"
lab var HH_TRN5 "Co-op makes its meeting minutes available to its members"
lab var HH_TRN6 "Co-op makes its election results available to its members"
lab var HH_TRN7 "Co-op makes its sale records available to its members"


*iebaltable

iebaltab COM3 COM8 index_HHcomm ///
		LS8 LS9 co_opgoatno co_opsalevalue ///
		net_goat_income index_HH_goatsales ///
		HH_TRN1 HH_TRN2 HH_TRN3 HH_TRN4 HH_TRN5 ///
		HH_TRN6 HH_TRN7 index_dTRN ///
		HHR4 HHR14 MEM11  ///
		MGT4, rowvarlabels ///
		grpvar(treat) vce(cluster idx)  ///
		savetex("$d2/iebaltab2_nobanke_PAP.tex") replace
		
		
		
		
		
		
