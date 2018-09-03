clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP4_test.smcl", replace

cd "$d3" 


** co-op dataset **
clear
use "r_CO_Merged_PAP.dta"

* Drop Banke District & Pilot Co-op
drop if district == "Banke"
drop if r_treat == .
drop if idx == "" 

* Weights = 1 & control group
generate wgt = 1
generate stdgroup = r_treat

encode region, gen(n_region) // create numerical region variable for regression

** Communication **

/* Variables 
# of times initiated contact with SHG : comm1
# of times SHG initiated contact : comm2
Factors that limit communication : (not in index - used as control vars)
*/

	* # of times initiated contact with SHG : comm1
	gen comm1 = COMM1a + COMM1b ///
	+ COMM1c + COMM1d
	* # of times SHG initiated contact : comm2
	gen comm2 = COMM2a + COMM2b ///
	+ COMM2c + COMM2d
	** Total # of times initiated contact
	gen contact = comm1 + comm2
	
	** Factors that limit communication
	/*
	local vlist a b c d e f
	foreach var of local vlist {
		destring COMM8`var', replace
		}
	*/
	
* co-op comm index
local local_CO_comm_full contact COM3 COM8
make_index_gr CO_comm_full wgt stdgroup `local_CO_comm_full' 

* factors that limit communication
	* principal components index


** Transparency **

/* Variables
Mandate : Co_opTransparencyTRN1
Annual Report : Co_opTransparencyTRN2
Annual Budget : Co_opTransparencyTRN3
Financial Report: Co_opTransparencyTRN4 
Meeting minutes : Co_opTransparencyTRN5
Election Results : Co_opTransparencyTRN6
Sale Records : Co_opTransparencyTRN7
Evaluations : Co_opTransparencyTRN8
*/

	/*
	forvalues i=1/7 { 
		destring role_GMtransTRN`i', replace
		replace role_GMtransTRN`i' = 0 if role_GMtransTRN`i' == 2
		replace role_GMtransTRN`i' = . if role_GMtransTRN`i' == 97
		}
	*/
	
** Co-op Transparency	
local local_CO_TRN CO_TRN1 CO_TRN2 ///
	CO_TRN3 CO_TRN4 CO_TRN5 ///
	CO_TRN6 CO_TRN7
make_index_gr CO_TRN wgt stdgroup `local_CO_TRN' 


** Household Awareness
local local_HH_TRN HH_TRN1 HH_TRN2 ///
	HH_TRN3 HH_TRN4 HH_TRN5 ///
	HH_TRN6 HH_TRN7
make_index_gr HH_TRN wgt stdgroup `local_HH_TRN' 


** Discrepancy
	forvalues i=1/7 { 
		gen dTRN`i' = -(CO_TRN`i' - HH_TRN`i')^2
		}
		
local local_dTRN dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7
make_index_gr dTRN wgt stdgroup `local_dTRN' 

* average discrepancy
egen avg_dTRN = rowmean(dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7)


** Cooperative Finances **

/* Variables 
Revenue from all activities : role_GMrevenuandcostREV4
Costs from all activities : role_GMrevenuandcostcalc_REC7
Assets : role_GMFinLiabiliteisFAL1
Liabilities : role_GMFinLiabiliteisFAL2
Goat Rev : role_GMrevenuandcostREC4_1
Members : role_CPMgt_and_membershi1
*/

gen revenue = REV4 // names too long for macros
gen costs = REC7
gen assets = FAL1
gen liabilities = FAL2
gen goatrev = REC4_1

gen net_rev = REV4 - REC7
gen net_finances = (REV4 - REC7) ///
					+ (FAL1 - FAL2)

* per member
gen rev_member = REV4 / MAN3
gen cost_member =  REC7 / MAN3
gen assets_member = FAL1 / MAN3
gen liab_member = FAL2 / MAN3
gen net_rev_member = net_rev / MAN3
gen net_finances_member = net_finances / MAN3
gen goatrev_member = REC4_1 / MAN3


** Goat Sales ** 

/* Variables 
# of goats sold : role_GMrevenuandcostREC1
goat revenue : role_GMrevenuandcostREC4_1
# of organized sales at collection points : Co_opGoat_transactionsGTT1
Members : role_CPMgt_and_membershi1
Goat revenue per member : goatrev_member
*/

** co-op level vars
gen goats_sold = REC1
gen goats_sold_member = REC1 / MAN3
* goatrev
* goatrev_member
gen goatrev_sold = REC4_1 / REC1
gen col_points = GTT1

local local_CO_goatsales goats_sold goatrev col_points
make_index_gr CO_goatsales wgt stdgroup `local_CO_goatsales' 


** household level vars
gen co_opshare = 0
replace co_opshare = co_opgoatno / LS8 if LS8 != 0
gen visits_sale = LS40 / LS_n_sales

local local_HH_goatsales LS8 LS9 co_opgoatno co_opsalevalue co_opshare visits_sale
make_index_gr HH_goatsales wgt stdgroup `local_HH_goatsales' 

local local_salecost visits_sale LS41 LS42
make_index_gr salecost wgt stdgroup `local_salecost' 


save "$d3/r_CO_Merged_Ind.dta", replace




****************
** HH dataset **
clear
use "r_HH_Merged_PAP.dta"

* Drop Banke District & Pilot Co-op
drop if district == "Banke"
drop if r_treat == .
drop if idx == "" 

* Weights = 1 & control group
generate wgt = 1
generate stdgroup = r_treat

encode region, gen(n_region) // create numerical region variable for regression

** Communication **

/* Variables 
# of times initiated contact with SHG : comm1
# of times SHG initiated contact : comm2
Factors that limit communication : (not in index - used as control vars)
*/

	* # of times initiated contact with SHG : comm1
	gen comm1 = COMM1a + COMM1b ///
	+ COMM1c + COMM1d
	* # of times SHG initiated contact : comm2
	gen comm2 = COMM2a + COMM2b ///
	+ COMM2c + COMM2d
	** Total # of times initiated contact
	gen contact = comm1 + comm2
	
	** Factors that limit communication
	/*
	local vlist a b c d e f
	foreach var of local vlist {
		destring COMM8`var', replace
		}
	*/

* contact
* sum contact comm1 comm2, detail


* HH comm index
local local_HH_comm COM3 COM8
make_index_gr HH_comm wgt stdgroup `local_HH_comm' 

* HH full comm index
local local_HH_comm_full contact COM3 COM8
make_index_gr HH_comm_full wgt stdgroup `local_HH_comm_full' 

* factors that limit communication
	* principal components index



** Transparency **

/* Variables
Mandate : Co_opTransparencyTRN1
Annual Report : Co_opTransparencyTRN2
Annual Budget : Co_opTransparencyTRN3
Financial Report: Co_opTransparencyTRN4 
Meeting minutes : Co_opTransparencyTRN5
Election Results : Co_opTransparencyTRN6
Sale Records : Co_opTransparencyTRN7
Evaluations : Co_opTransparencyTRN8
*/

	/*
	forvalues i=1/7 { 
		destring role_GMtransTRN`i', replace
		replace role_GMtransTRN`i' = 0 if role_GMtransTRN`i' == 2
		replace role_GMtransTRN`i' = . if role_GMtransTRN`i' == 97
		}
	*/
	
** Co-op Transparency	
local local_CO_TRN CO_TRN1 CO_TRN2 ///
	CO_TRN3 CO_TRN4 CO_TRN5 ///
	CO_TRN6 CO_TRN7
make_index_gr CO_TRN wgt stdgroup `local_CO_TRN' 		

** Household Awareness
local local_HH_TRN HH_TRN1 HH_TRN2 ///
	HH_TRN3 HH_TRN4 HH_TRN5 ///
	HH_TRN6 HH_TRN7
make_index_gr HH_TRN wgt stdgroup `local_HH_TRN' 

	
** Transparency Discrepancy index
	forvalues i=1/7 { 
		gen dTRN`i' = 1 if CO_TRN`i' == HH_TRN`i' ///
			&  !missing(CO_TRN`i') & !missing(HH_TRN`i')
		replace dTRN`i' = 0 if CO_TRN`i' != HH_TRN`i' ///
			&  !missing(CO_TRN`i') & !missing(HH_TRN`i')
		}
		
local local_dTRN dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7
make_index_gr dTRN wgt stdgroup `local_dTRN' 

* average discrepancy
egen avg_dTRN = rowmean(dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7)


** Finances **

** co-op vars

/* Variables 
Revenue from all activities : role_GMrevenuandcostREV4
Costs from all activities : role_GMrevenuandcostcalc_REC7
Assets : role_GMFinLiabiliteisFAL1
Liabilities : role_GMFinLiabiliteisFAL2
Goat Rev : role_GMrevenuandcostREC4_1
Members : role_CPMgt_and_membershi1
*/

gen revenue = REV4 // names too long for macros
gen costs = REC7
gen assets = FAL1
gen liabilities = FAL2
gen goatrev = REC4_1

gen net_rev = REV4 - REC7
gen net_finances = (REV4 - REC7) ///
					+ (FAL1 - FAL2)

* per member
gen rev_member = REV4 / MAN3
gen cost_member =  REC7 / MAN3
gen assets_member = FAL1 / MAN3
gen liab_member = FAL2 / MAN3
gen net_rev_member = net_rev / MAN3
gen net_finances_member = net_finances / MAN3
gen goatrev_member = REC4_1 / MAN3


** Goat Sales ** 

/* Variables 
# of goats sold : Livestock_SalesLS8
goat revenue : Livestock_SalesLS9
goats sold through co-op : co_opgoatno
goat revenue through co-op : co_opsalevalue
share through co-op : co_opshare
trader visits home : Livestock_SalesLS40
time passed before sale : Livestock_SalesLS41
transportation cost : Livestock_SalesLS42
*/

** co-op level vars
gen goats_sold = REC1
gen goats_sold_member = REC1 / MAN3
* goatrev
* goatrev_member
gen goatrev_sold = REC4_1 / REC1
gen col_points = GTT1

local local_CO_goatsales goats_sold goatrev col_points
make_index_gr CO_goatsales wgt stdgroup `local_CO_goatsales' 


** household level vars
gen co_opshare = 0
replace co_opshare = co_opgoatno / LS8 if LS8 != 0
gen visits_sale = LS40 / LS_n_sales

local local_HH_goatsales LS8 LS9 co_opgoatno co_opsalevalue co_opshare visits_sale
make_index_gr HH_goatsales wgt stdgroup `local_HH_goatsales' 

local local_salecost visits_sale LS41 LS42
make_index_gr salecost wgt stdgroup `local_salecost' 

save "$d3/r_HH_Merged_Ind.dta", replace























