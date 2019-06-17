
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


** Winsorize PNG3
* -----------------------------------------------
* treatment
sum PNG3 if r_treat == 1, d
scalar t_99 = r(p99)

replace PNG3 = t_99 if PNG3 > t_99 & !missing(PNG3) & r_treat == 1

sum PNG3 if r_treat == 1, d
scalar t_1= r(p1)

replace PNG3 = t_1 if PNG3 < t_1 & !missing(PNG3) & r_treat == 1


*control
sum PNG3 if r_treat == 0, d
scalar c_99 = r(p99)

replace PNG3 = c_99 if PNG3 > c_99 & !missing(PNG3) & r_treat == 0

sum PNG3 if r_treat == 0, d
scalar t_1= r(p1)

replace PNG3 = t_1 if PNG3 < t_1 & !missing(PNG3) & r_treat == 0
* -----------------------------------------------


** Winsorize expected_rev
* -----------------------------------------------
* treatment
sum expected_rev if r_treat == 1, d
scalar t_99 = r(p99)

replace expected_rev = t_99 if expected_rev > t_99 & !missing(expected_rev) & r_treat == 1

sum expected_rev if r_treat == 1, d
scalar t_1= r(p1)

replace expected_rev = t_1 if expected_rev < t_1 & !missing(expected_rev) & r_treat == 1


*control
sum expected_rev if r_treat == 0, d
scalar c_99 = r(p99)

replace expected_rev = c_99 if expected_rev > c_99 & !missing(expected_rev) & r_treat == 0

sum expected_rev if r_treat == 0, d
scalar t_1= r(p1)

replace expected_rev = t_1 if expected_rev < t_1 & !missing(expected_rev) & r_treat == 0
* -----------------------------------------------



lab var PNG2 "Planning time horizon (years)"
lab var PNG3 "Expected goats sold over next 6 months (count)"
lab var expected_rev "Expected tevenue over next 6 months (USD)"

lab var CO_TRN1 "Mandate is made available to members (0/1)"
lab var CO_TRN2 "Annual report is made available to members (0/1)"
lab var CO_TRN3 "Annual budget is made available to members (0/1)"
lab var CO_TRN4 "Financial report is made available to members (0/1)"
lab var CO_TRN5 "Meeting minutes are made available to members (0/1)"
lab var CO_TRN6 "Election results are made available to members (0/1)"
lab var CO_TRN7 "Sale records are made available to members (0/1)"

lab var MAN3 "Members (count)"
lab var revenue "Cooperative revenue (USD)"
lab var ICTassets "Total number of ICT assets (count)"
lab var Otherassets "Total number of non-ICT assets (count)"


*iebaltable

iebaltab revenue PNG2 PNG3 expected_rev ///
		CO_TRN1 CO_TRN2 CO_TRN3 CO_TRN4 CO_TRN5 ///
		CO_TRN6 CO_TRN7 ///
		COMM8b_1 COMM8d_1 ///
		MAN3 ICTassets Otherassets, rowvarlabels grpvar(treat) ///
		savetex("$d2/iebaltab1_nobanke_PAP.tex") replace


* ------------------------------------------------
		
		
		
* Household Data		
clear
use "$d3/r_HH_Merged_Ind.dta"



** Winsorize LS8 with true treatment status
* -----------------------------------------------
* treatment
sum LS8 if r_treat == 1, d
scalar t_99 = r(p99)

replace LS8 = t_99 if LS8 > t_99 & !missing(LS8) & r_treat == 1

sum LS8 if r_treat == 1, d
scalar t_1= r(p1)

replace LS8 = t_1 if LS8 < t_1 & !missing(LS8) & r_treat == 1


*control
sum LS8 if r_treat == 0, d
scalar c_99 = r(p99)

replace LS8 = c_99 if LS8 > c_99 & !missing(LS8) & r_treat == 0

sum LS8 if r_treat == 0, d
scalar t_1= r(p1)

replace LS8 = t_1 if LS8 < t_1 & !missing(LS8) & r_treat == 0
* -----------------------------------------------


** Winsorize co_opgoatno
* -----------------------------------------------
* treatment
sum co_opgoatno if r_treat == 1, d
scalar t_99 = r(p99)

replace co_opgoatno = t_99 if co_opgoatno > t_99 & !missing(co_opgoatno) & r_treat == 1

sum co_opgoatno if r_treat == 1, d
scalar t_1= r(p1)

replace co_opgoatno = t_1 if co_opgoatno < t_1 & !missing(co_opgoatno) & r_treat == 1


*control
sum co_opgoatno if r_treat == 0, d
scalar c_99 = r(p99)

replace co_opgoatno = c_99 if co_opgoatno > c_99 & !missing(co_opgoatno) & r_treat == 0

sum co_opgoatno if r_treat == 0, d
scalar t_1= r(p1)

replace co_opgoatno = t_1 if co_opgoatno < t_1 & !missing(co_opgoatno) & r_treat == 0
* -----------------------------------------------


** Winsorize rev_goat with true treatment status
* -----------------------------------------------
* treatment
sum rev_goat if treat == 1, d
scalar t_99 = r(p99)

replace rev_goat = t_99 if rev_goat > t_99 & !missing(rev_goat) & treat == 1

sum rev_goat if treat == 1, d
scalar t_1= r(p1)

replace rev_goat = t_1 if rev_goat < t_1 & !missing(rev_goat) & treat == 1


*control
sum rev_goat if treat == 0, d
scalar c_99 = r(p99)

replace rev_goat = c_99 if rev_goat > c_99 & !missing(rev_goat) & treat == 0

sum rev_goat if treat == 0, d
scalar t_1= r(p1)

replace rev_goat = t_1 if rev_goat < t_1 & !missing(rev_goat) & treat == 0

* -----------------------------------------------

** Winsorize rev_co_opgoat
* -----------------------------------------------
* treatment
sum rev_co_opgoat if r_treat == 1, d
scalar t_99 = r(p99)

replace rev_co_opgoat = t_99 if rev_co_opgoat > t_99 & !missing(rev_co_opgoat) & r_treat == 1

sum rev_co_opgoat if r_treat == 1, d
scalar t_1= r(p1)

replace rev_co_opgoat = t_1 if rev_co_opgoat < t_1 & !missing(rev_co_opgoat) & r_treat == 1


*control
sum rev_co_opgoat if r_treat == 0, d
scalar c_99 = r(p99)

replace rev_co_opgoat = c_99 if rev_co_opgoat > c_99 & !missing(rev_co_opgoat) & r_treat == 0

sum rev_co_opgoat if r_treat == 0, d
scalar t_1= r(p1)

replace rev_co_opgoat = t_1 if rev_co_opgoat < t_1 & !missing(rev_co_opgoat) & r_treat == 0
* -----------------------------------------------

** Winsorize net goat income
* -----------------------------------------------
* treatment
sum net_goat_income if treat == 1, d
scalar t_99 = r(p99)

replace net_goat_income = t_99 if net_goat_income > t_99 & !missing(net_goat_income) & treat == 1

sum net_goat_income if treat == 1, d
scalar t_1= r(p1)

replace net_goat_income = t_1 if net_goat_income < t_1 & !missing(net_goat_income) & treat == 1

*control
sum net_goat_income if treat == 0, d
scalar c_99 = r(p99)

replace net_goat_income = c_99 if net_goat_income > c_99 & !missing(net_goat_income) & treat == 0

sum net_goat_income if treat == 0, d
scalar t_1= r(p1)

replace net_goat_income = t_1 if net_goat_income < t_1 & !missing(net_goat_income) & treat == 0
* -----------------------------------------------



* ---------------------------------------------------------
** Replace Missing values with zero 
* LS9 , 
replace LS9 = 0 if LS9 ==.
replace co_opsalevalue = 0 if co_opsalevalue ==.
* ---------------------------------------------------------


destring MGT4, replace

lab var bCOM3 "Received sale information (0/1)"
lab var index_dTRN "Transparency discrepancy index (continuous)"
lab var co_opgoatno "Goats sold through cooperative (count)"
lab var LS8 "Goats sold (count)"
lab var rev_goat "Revenue per goat sold (USD)"
lab var rev_co_opgoat "Revenue per cooperative goat sold (USD)"
lab var net_goat_income "Net Goat Income (USD)"
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
lab var index_mgt "Goat management index (count)"
lab var index_emp "Goat empowerment index (count)"



*iebaltable

iebaltab bCOM3 index_dTRN co_opgoatno LS8 ///
		rev_goat rev_co_opgoat net_goat_income ///
		LS9  co_opsalevalue ///
		HH_TRN1 HH_TRN2 HH_TRN3 HH_TRN4 HH_TRN5 ///
		HH_TRN6 HH_TRN7 ///
		HHR4 HHR14 MEM11  ///
		dirt_floor nfloors index_mgt index_emp, rowvarlabels ///
		grpvar(treat) vce(cluster idx)  ///
		savetex("$d2/iebaltab2_nobanke_PAP.tex") replace
		
		
		
		
		
		
