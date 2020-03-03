
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


lab var PNG2 "Planning time horizon (years)"
lab var PNG3_w "Expected goats sold over next 6 months (count)"
lab var expected_rev_w "Expected revenue over next 6 months (USD)"

lab var CO_TRN1 "Mandate is made available to members (0/1)"
lab var CO_TRN2 "Annual report is made available to members (0/1)"
lab var CO_TRN3 "Annual budget is made available to members (0/1)"
lab var CO_TRN4 "Financial report is made available to members (0/1)"
lab var CO_TRN5 "Meeting minutes are made available to members (0/1)"
lab var CO_TRN6 "Election results are made available to members (0/1)"
lab var CO_TRN7 "Sale records are made available to members (0/1)"
lab var CO_SER15 "Cooperative coordinates goat sales (0/1)"

lab var MAN3 "Members (count)"
lab var revenue "Cooperative revenue (USD)"
lab var ICTassets "Total number of ICT assets (count)"
lab var Otherassets "Total number of non-ICT assets (count)"


*iebaltable

iebaltab CO_SER15 revenue PNG2 PNG3_w expected_rev_w ///
		CO_TRN1 CO_TRN2 CO_TRN3 CO_TRN4 CO_TRN5 ///
		CO_TRN6 CO_TRN7 ///
		COMM8b_1 COMM8d_1 ///
		MAN3 ICTassets Otherassets, rowvarlabels grpvar(treat) covariates(i.strata) ///
		savetex("$d2/iebaltab1_nobanke_PAP.tex") replace


* ------------------------------------------------
		
		
		
* Household Data		
clear
use "$d3/r_HH_Merged_Ind.dta"


* ---------------------------------------------------------
** Replace Missing values with zero 
* LS9 , 
replace LS9 = 0 if LS9 ==.
replace co_opsalevalue = 0 if co_opsalevalue ==.
* ---------------------------------------------------------


destring MGT4, replace

lab var bCOM3 "Received sale information (0/1)"
lab var index_dTRN "Administrative transparency index (continuous)"
lab var co_opgoatno_w "Goats sold through cooperative (count)"
lab var LS8_w "Goats sold (count)"
lab var rev_goat_w "Revenue per goat sold (USD)"
lab var rev_co_opgoat_w "Revenue per cooperative goat sold (USD)"
lab var net_goat_income_w "Net Goat Income (USD)"
lab var LS9 "Goat revenue (USD)"
lab var co_opsalevalue "Goat revenue through cooperative (USD)"
lab var HHR4 "Age (years)"
lab var HHR14 "Literacy (0/1)"
lab var MEM11 "SHG Meetings Attended in Past 6 Months (count)"
lab var HH_TRN1 "Co-op makes its mandate available to its members (0/1)"
lab var HH_TRN2 "Co-op makes its annual report available to its members (0/1)"
lab var HH_TRN3 "Co-op makes its annual budget available to its members (0/1)"
lab var HH_TRN4 "Co-op makes its financial report available to its members (0/1)"
lab var HH_TRN5 "Co-op makes its meeting minutes available to its members (0/1)"
lab var HH_TRN6 "Co-op makes its election results available to its members (0/1)"
lab var HH_TRN7 "Co-op makes its sale records available to its members (0/1)"
lab var dirt_floor "Household has dirt floors (0/1)"
lab var nfloors "Household has more than one floor (0/1)"
lab var travel_time_ln "Log round-trip travel time to cooperative (minutes)"
lab var sales_awareness "Household is aware of cooperative goat sales (0/1)"
lab var index_dSER "Economic services transparency index (continuous)"

*iebaltable

iebaltab HHR4 HHR14 MEM11  ///
		dirt_floor nfloors ///
		sales_awareness bCOM3 index_dTRN index_dSER co_opgoatno_w LS8_w ///
		rev_goat_w rev_co_opgoat_w net_goat_income_w ///
		LS9 co_opsalevalue travel_time_ln ///
		HH_TRN1 HH_TRN2 HH_TRN3 HH_TRN4 HH_TRN5 ///
		HH_TRN6 HH_TRN7, rowvarlabels ///
		grpvar(treat) vce(cluster idx) covariates(i.strata)  ///
		savetex("$d2/iebaltab2_nobanke_PAP.tex") replace
		
		
		
		
		
		
