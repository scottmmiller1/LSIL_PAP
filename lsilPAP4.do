
/*******************************************************************************
lsilPAP4.d0		
					
- Creates indicator variables & ICW Summary Indices from
	r_CO_Merged_PAP.dta (co-op level dataset)
	and r_HH_Merged_PAP.dta (HH level dataset)
	Saves new datasets respectively as: 
	r_CO_Merged_Ind.dta
	r_HH_Merged_Ind.dta
	
*******************************************************************************/


clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP4.smcl", replace


cd "$d3" 

** co-op dataset **
clear
use "r_CO_Merged_PAP.dta"

* Drop Banke District & Pilot Co-op
drop if district == "Banke"
drop if r_treat ==.
drop if idx == "" 

encode region, gen(n_region) // create numerical region variable for regression


** Communication **

* factors that limit communication
/* Variables
Mobile Network : COMM8b
Distance : COMM8d
*/


* transparency
/* Variables
Mandate : CO_TRN1
Annual Report : CO_TRN2
Annual Budget : CO_TRN3
Financial Report: CO_TRN4
Meeting minutes : CO_TRN5
Election Results : CO_TRN6
Sale Records : CO_TRN7
*/


** Planning and Goals **

/* Variables 

Time Horizon : PNG2
Expected Goats Sold : PNG3
Expected Rev. : PNG4
*/

replace PNG2 =. if PNG2 == 99

* replace missing values with median
* ----------------------------------
forvalues i=2/4 {
	quietly sum PNG`i', d
	replace PNG`i' = `r(p50)' if PNG`i' ==. 
}
* ----------------------------------

* convert to USD
gen expected_rev = PNG4*(0.0099)


foreach v of varlist PNG3 expected_rev {
	
	** Winsorize with random treatment status
	* -----------------------------------------------
	gen `v'_wr = `v'
	
	* treatment
	sum `v'_wr if r_treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_wr = t_99 if `v'_wr > t_99 & !missing(`v'_wr) & r_treat == 1

	sum `v'_wr if r_treat == 1, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 1


	*control
	sum `v'_wr if r_treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_wr = c_99 if `v'_wr > c_99 & !missing(`v'_wr) & r_treat == 0

	sum `v'_wr if r_treat == 0, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 0
	* -----------------------------------------------
	
	** Winsorize with true treatment status
	* -----------------------------------------------
	gen `v'_w = `v'
	
	* treatment
	sum `v'_w if treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_w = t_99 if `v'_w > t_99 & !missing(`v'_w) & treat == 1

	sum `v'_w if treat == 1, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 1


	*control
	sum `v'_w if treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_w = c_99 if `v'_w > c_99 & !missing(`v'_w) & treat == 0

	sum `v'_w if treat == 0, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 0
	* -----------------------------------------------
}



** Cooperative Characteristics **

/* Variables 
Members : MAN3
Revenue from all activities : REV4
# of computers owned : EQP1_2
# of phones owned : EQP2_2
# of printers owned : EQP2_2X
# of weighing scales owned : EQP4_2
# of trucks or vans : EQP5_2
# of covered collection centers : EQP6_2
*/

gen goats_sold = REC1

* Convert to USD as of 1/1/18

gen revenue = REV4*(0.0099)
gen costs = REC7*(0.0099)
gen assets = FAL1*(0.0099)
gen liabilities = FAL2*(0.0099)
gen goatrev = REC4_1*(0.0099)

gen net_rev = revenue - costs
gen net_finances = (revenue - costs) + (assets - liabilities)

* per member
gen rev_member = revenue / MAN3
gen cost_member =  costs / MAN3
gen assets_member = assets / MAN3
gen liab_member = liabilities / MAN3
gen net_rev_member = net_rev / MAN3
gen net_finances_member = net_finances / MAN3
gen goatrev_member = goatrev / MAN3

** Replace Missing values with zero 
foreach v of varlist EQP1_2 EQP2_2 EQP2_2X EQP4_2 EQP5_2 EQP6_2 ///
					goats_sold revenue rev_member costs cost_mem {
	replace `v' = 0 if `v' ==.
}	


* ICT and non-ICT assets
gen ICTassets = EQP1_2 + EQP2_2
gen Otherassets = EQP2_2X + EQP4_2 + EQP5_2 + EQP6_2


* Sells goats
replace CO_SER15 = 1 if CO_SER15 > 0


save "$d3/r_CO_Merged_Ind.dta", replace



****************
** HH dataset **
clear
use "$d3/r_HH_Merged_PAP.dta"

* Drop Banke District & Pilot Co-op
drop if district == "Banke"
drop if r_treat == .
drop if idx == "" 


encode region, gen(n_region) // create numerical region variable for regression


** Awareness of Co-op Goat Selling **
replace CO_SER15 = 1 if CO_SER15 > 0

gen sales_awareness = 1 if SER15 == 1 & CO_SER15 == 1
replace sales_awareness = 1 if SER15 == 0 & CO_SER15 == 0
replace sales_awareness = 0 if SER15 == 0 & CO_SER15 == 1
replace sales_awareness = 0 if SER15 == 1 & CO_SER15 == 0



** Communication **

/* Variables 
Total times contacted about livestock sales : COM3
*/

replace COM3 = 0 if COM3 ==.
gen bCOM3 = 1 if COM3 > 0
replace bCOM3 = 0 if bCOM3 ==.

* Administrative transparency
/* Variables
Mandate : HH_TRN1
Annual Report : HH_TRN2
Annual Budget : HH_TRN3
Financial Report: HH_TRN4 
Meeting minutes : HH_TRN5
Election Results : HH_TRN6
Sale Records : HH_TRN7
Evaluations : HH_TRN8
*/



** Administrative transparency index
	forvalues i=1/7 { 
		replace CO_TRN`i' = 1 if CO_TRN`i' > 0
		gen dTRN`i' = 1 if CO_TRN`i' == HH_TRN`i' ///
			&  !missing(CO_TRN`i') & !missing(HH_TRN`i')
		replace dTRN`i' = 0 if CO_TRN`i' != HH_TRN`i' ///
			&  !missing(CO_TRN`i') & !missing(HH_TRN`i')
		}
		
	** Index with random treatment status
	* -----------------------------------------------
	* Weights = 1 & control group
	generate wgt = 1
	generate stdgroup = (r_treat == 0)		
		
	local local_dTRN dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7
	make_index_gr dTRN_r wgt stdgroup `local_dTRN' 
	* -----------------------------------------------
	
	** Index with true treatment status
	* -----------------------------------------------
	* Weights = 1 & control group
	replace stdgroup = (treat == 0)		
		
	local local_dTRN dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7
	make_index_gr dTRN wgt stdgroup `local_dTRN' 
	* -----------------------------------------------

* number of administrative services
egen TRN_no = rowtotal(CO_TRN1 CO_TRN2 CO_TRN3 CO_TRN4 CO_TRN5 CO_TRN6 CO_TRN7)

* Administrative transparency
/* Variables
Mandate : HH_TRN1
Annual Report : HH_TRN2
Annual Budget : HH_TRN3
Financial Report: HH_TRN4 
Meeting minutes : HH_TRN5
Election Results : HH_TRN6
Sale Records : HH_TRN7
Evaluations : HH_TRN8
*/



* Economic services transparency index
	rename CO_SER11a CO_SER11
	rename CO_SERV2 CO_SER19

	foreach i of numlist 1/4 6/15 18 19 { 
		replace CO_SER`i' = 1 if CO_SER`i' > 0
		gen dSER`i' = 1 if CO_SER`i' == SER`i' ///
			&  !missing(CO_SER`i') & !missing(SER`i')
		replace dSER`i' = 0 if CO_SER`i' != SER`i' ///
			&  !missing(CO_SER`i') & !missing(SER`i')
		}

	** Index with random treatment status
	* -----------------------------------------------
	* Weights = 1 & control group
	replace stdgroup = (r_treat	== 0)	
		
	* discrepancy index
	local local_dSER dSER1-dSER4 dSER6-dSER15 dSER18 dSER19
	make_index_gr dSER_r wgt stdgroup `local_dSER' 	
	* -----------------------------------------------
	
	** Index with true treatment status
	* -----------------------------------------------
	* Weights = 1 & control group
	replace stdgroup = (treat == 0)		
		
	* discrepancy index
	local local_dSER dSER1-dSER4 dSER6-dSER15 dSER18 dSER19
	make_index_gr dSER wgt stdgroup `local_dSER' 	
	* -----------------------------------------------	

egen SER_no = rowtotal(CO_SER1-CO_SER4 CO_SER6-CO_SER15 CO_SER18 CO_SER19)	
	
	
** Goat Sales ** 

/* Variables 
goats sold through co-op : co_opgoatno
# of goats sold : LS8
*/


** Replace Missing values with zero
* ----------------------------------------------- 
replace LS8 = 0 if LS8 ==.
replace co_opgoatno = 0 if co_opgoatno ==.
* -----------------------------------------------

foreach v of varlist LS8 co_opgoatno {
	
	** Winsorize with random treatment status
	* -----------------------------------------------
	gen `v'_wr = `v'
	
	* treatment
	sum `v'_wr if r_treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_wr = t_99 if `v'_wr > t_99 & !missing(`v'_wr) & r_treat == 1

	sum `v'_wr if r_treat == 1, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 1


	*control
	sum `v'_wr if r_treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_wr = c_99 if `v'_wr > c_99 & !missing(`v'_wr) & r_treat == 0

	sum `v'_wr if r_treat == 0, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 0
	* -----------------------------------------------
	
	** Winsorize with true treatment status
	* -----------------------------------------------
	gen `v'_w = `v'
	
	* treatment
	sum `v'_w if treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_w = t_99 if `v'_w > t_99 & !missing(`v'_w) & treat == 1

	sum `v'_w if treat == 1, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 1


	*control
	sum `v'_w if treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_w = c_99 if `v'_w > c_99 & !missing(`v'_w) & treat == 0

	sum `v'_w if treat == 0, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 0
	* -----------------------------------------------
}


** Goat Prices ** 

/* Variables 
Revenue per goat sold : LS9 / LS8
Revenue per goat sold through co-op : co_opsalevalue / co_opgoatno
*/

*drop rev_goat
gen rev_goat = LS9 / LS8 if LS8 != 0
gen rev_co_opgoat = co_opsalevalue / co_opgoatno if co_opgoatno != 0


** Replace Missing values with zero
* ----------------------------------------------- 
replace rev_goat = 0 if rev_goat ==.
replace rev_co_opgoat = 0 if rev_co_opgoat ==.
* -----------------------------------------------

* covert to USD
* ----------------------------------------------- 
replace rev_goat = rev_goat*(0.0099)
replace rev_co_opgoat = rev_co_opgoat*(0.0099)
* ----------------------------------------------- 


foreach v of varlist rev_goat rev_co_opgoat {
	
	** Winsorize goat price vars with random treatment status
	* -----------------------------------------------
	gen `v'_wr = `v'
	
	* treatment
	sum `v'_wr if r_treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_wr = t_99 if `v'_wr > t_99 & !missing(`v'_wr) & r_treat == 1

	sum `v'_wr if r_treat == 1, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 1


	*control
	sum `v'_wr if r_treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_wr = c_99 if `v'_wr > c_99 & !missing(`v'_wr) & r_treat == 0

	sum `v'_wr if r_treat == 0, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 0
	* -----------------------------------------------
	
	** Winsorize with true treatment status
	* -----------------------------------------------
	gen `v'_w = `v'
	
	* treatment
	sum `v'_w if treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_w = t_99 if `v'_w > t_99 & !missing(`v'_w) & treat == 1

	sum `v'_w if treat == 1, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 1


	*control
	sum `v'_w if treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_w = c_99 if `v'_w > c_99 & !missing(`v'_w) & treat == 0

	sum `v'_w if treat == 0, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 0
	* -----------------------------------------------
}

** Goat Income ** 

/* Variables 
Revenue per goat sold : rev_goat
# of goats: LS8

Amount spent purchasing goats: LSE12
Amount spent on feed/fodder : LSE15
Amount spent on vet care : LSE16
Amount spent on breeding fees : LSE17a * LSE17b
Amount spent on shelters : LSE18
Net goat income
*/



** Replace Missing values with zero
* ----------------------------------------------- 
foreach v of varlist LS9 LSE12 LSE15 LSE16 LSE17a LSE17b LSE18 {
	replace `v' = 0 if `v'==.
	}
* -----------------------------------------------


* generate net income
gen goat_costs = LSE12*(0.0099) + LSE15*(0.0099) + LSE16*(0.0099) + (LSE17a*LSE17b)*(0.0099) + LSE18*(0.0099)
gen net_goat_income = LS9*(0.0099) - goat_costs


foreach v of varlist net_goat_income {
	
	** Winsorize goat price vars with random treatment status
	* -----------------------------------------------
	gen `v'_wr = `v'
	
	* treatment
	sum `v'_wr if r_treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_wr = t_99 if `v'_wr > t_99 & !missing(`v'_wr) & r_treat == 1

	sum `v'_wr if r_treat == 1, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 1


	*control
	sum `v'_wr if r_treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_wr = c_99 if `v'_wr > c_99 & !missing(`v'_wr) & r_treat == 0

	sum `v'_wr if r_treat == 0, d
	scalar t_1= r(p1)

	replace `v'_wr = t_1 if `v'_wr < t_1 & !missing(`v'_wr) & r_treat == 0
	* -----------------------------------------------
	
	** Winsorize with true treatment status
	* -----------------------------------------------
	gen `v'_w = `v'
	
	* treatment
	sum `v'_w if treat == 1, d
	scalar t_99 = r(p99)

	replace `v'_w = t_99 if `v'_w > t_99 & !missing(`v'_w) & treat == 1

	sum `v'_w if treat == 1, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 1


	*control
	sum `v'_w if treat == 0, d
	scalar c_99 = r(p99)

	replace `v'_w = c_99 if `v'_w > c_99 & !missing(`v'_w) & treat == 0

	sum `v'_w if treat == 0, d
	scalar t_1= r(p1)

	replace `v'_w = t_1 if `v'_w < t_1 & !missing(`v'_w) & treat == 0
	* -----------------------------------------------
}




** Characteristics ** 

/* Variables 
Travel time to co-op (IHS)
Age : HHR4
Literacy : HHR14
Total # of SHG meetings attended in past 6 months : MEM11
Dirt floors: HSE6
More than 1 floor: HSE5
goat management index
*/


* number of SHG meetings
replace MEM11 = 0 if MEM11 ==.

* literacy
replace HHR14 = . if HHR4 < 18

* binary dirt floor variable
gen dirt_floor = 1 if HSE6 == 1
replace dirt_floor = 0 if HSE6 != 1

* binary number of floors
gen nfloors = 1 if HSE5 > 1
replace nfloors = 0 if HSE5 <= 1

** goat empowerment index
forvalues i = 2/12 {
	gen emp`i' = 1 if EMP`i'A == 1 & EMP14A == 1
	replace emp`i' = 0 if EMP`i'a_A == 1 | EMP`i'a_A == 2
	replace emp`i' = 0 if emp`i' ==.
}

gen index_emp = EMP1A + emp2 + emp3 + emp4 + emp5 + emp6 + emp7 + emp8 + emp9 + emp10 + emp11 + emp12

* loan
* BR1


* control variables 
* mobile network seriously limits comm
gen mobile_network = COMM8b == "1"

* travel time to co-op (IHS)
sum MEM10_a, d
*replace MEM10_a = `r(p99)' if MEM10_a > `r(p99)'
sum MEM10_b, d
*replace MEM10_b = `r(p99)' if MEM10_b > `r(p99)'

gen travel_time = MEM10_a*60 + MEM10_b
gen travel_time_ln = log(travel_time + sqrt(travel_time^2 + 1))

* co-op seller
* binary LS8
gen b_LS8 = 0
replace b_LS8 = 1 if LS8_w > 0

* binary co-op goatno
gen b_co_opgoatno = 0 
replace b_co_opgoatno = 1 if co_opgoatno_w > 0

* outside seller
gen b_outgoatno = 0
replace b_outgoatno = 1 if b_LS8 == 1 & co_opgoatno == 0


save "$d3/r_HH_Merged_Ind.dta", replace


* --------------------------------
* merge control vars into co-op dataset
** Collapse to 1-row per co-op
* strings

* collapse
collapse (mean) mobile_network travel_time_ln b_co_opgoatno b_outgoatno, by(idx)
*collapse (firstnm) `Co-opstrings', by(idx)

merge 1:1 idx using "$d3/r_CO_Merged_Ind.dta"
drop _merge

save "$d3/r_CO_Merged_Ind.dta", replace

*------------------------------------------------------------------------------ 
** Remove intermediary datasets
/*
erase "$d3/Household_Merged_Edit.dta"
erase "$d3/Baseline_Merged.dta"
erase "$d3/r_Baseline_Merged_Str.dta"
erase "$d3/r_CO_Merged_PAP.dta"
erase "$d3/r_HH_Merged_PAP.dta"



