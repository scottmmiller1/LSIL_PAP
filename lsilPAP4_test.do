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
drop if r_treat ==.
drop if idx == "" 

* Weights = 1 & control group
generate wgt = 1
generate stdgroup = r_treat

encode region, gen(n_region) // create numerical region variable for regression

** Winsorize LS9
* treatment
sum LS9 if r_treat == 1, d
scalar t_99 = r(p99)

replace LS9 = t_99 if LS9 > t_99 & !missing(LS9) & r_treat == 1

*control
sum LS9 if r_treat == 0, d
scalar c_99 = r(p99)

replace LS9 = c_99 if LS9 > c_99 & !missing(LS9) & r_treat == 0


** Replace Missing values with zero 
* LS9 , 
replace LS9 = 0 if LS9 ==.
replace co_opsalevalue = 0 if co_opsalevalue ==.




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
	
	* Total # of times HH is contacted
	gen HHcontact = COM3 + COM8
	

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

* Convert to USD as of 1/1/18

gen revenue = REV4*(0.0099) // names too long for macros
gen costs = REC7*(0.0099)
gen assets = FAL1*(0.0099)
gen liabilities = FAL2*(0.0099)
gen goatrev = REC4_1*(0.0099)

gen net_rev = revenue - costs
gen net_finances = (revenue - costs) ///
					+ (assets - liabilities)

* per member
gen rev_member = revenue / MAN3
gen cost_member =  costs / MAN3
gen assets_member = assets / MAN3
gen liab_member = liabilities / MAN3
gen net_rev_member = net_rev / MAN3
gen net_finances_member = net_finances / MAN3
gen goatrev_member = goatrev / MAN3

** Replace Missing values with zero 
*  , 
replace revenue = 0 if revenue ==.
replace rev_member = 0 if rev_member ==.
replace costs = 0 if costs ==.
replace cost_mem = 0 if cost_mem ==.		


** Goat Sales ** 

/* Variables 
# of goats sold : REC1
goat revenue : REC4_1
# of organized sales at collection points : GTT1
Members : MAN3
Goat revenue per member : goatrev_member
Trader visits per sale
Time passed
Transportation costs
*/

** co-op level vars
gen goats_sold = REC1
gen goats_sold_member = REC1 / MAN3
* goatrev
* revenue per goat sold
gen goatrev_sold = goatrev / REC1
gen col_points = GTT1

local local_CO_goatsales goats_sold goatrev col_points
make_index_gr CO_goatsales wgt stdgroup `local_CO_goatsales' 


** household level vars
gen co_opshare = 0
replace co_opshare = co_opgoatno / LS8 if LS8 != 0
gen visits_sale = -1*(LS40 / LS_n_sales)
gen time_passed = -1*(LS41)
gen transp_cost = -1*(LS42*(0.0099))

local local_HH_goatsales LS8 LS9 co_opgoatno co_opsalevalue
make_index_gr HH_goatsales wgt stdgroup `local_HH_goatsales' 

local local_salecost visits_sale time_passed transp_cost
make_index_gr salecost wgt stdgroup `local_salecost' 


* Gross margin -- Net rev. per goat

/* Costs
Amount spent purchasing goats: LSE12
Amount spent on feed/fodder : LSE15
Amount spent on vet care : LSE16
Amount spent on breeding fees : LSE17a * LSE17b
Amount spent on shelters : LSE18
*/

gen goat_costs = LSE12*(0.0099) + LSE15*(0.0099) + LSE16*(0.0099) + (LSE17a*LSE17b)*(0.0099) + LSE18*(0.0099)
gen net_goat_income = LS9*(0.0099) - goat_costs
gen netincome_goat = net_goat_income / LS8



** Decision-Making **

/* Variables 
Setting interest rate (loans) : MAN18a 
Setting interest rate (savings) : MAN18b
Setting prices (traders) : MAN18c
Buying equipment : MAN18d
General assembly dates: MAN18e
*/

* destring
foreach v of varlist MAN18a MAN18b ///
MAN18c MAN18d MAN18e {
	destring `v', replace
}	

local local_decision MAN18a MAN18b MAN18c MAN18d MAN18e 
make_index_gr decision wgt stdgroup `local_decision'



** Evaluation & Assessment **

/* Variables 
External Evaluation : EAA1
Available to Co-op : EAA3
*/

egen avg_EAA = rowmean(EAA1 EAA3)


** Planning and Goals **

/* Variables 
Business Plan : PNG1
Time Horizon : PNG2
Expected Goats Sold : PNG3
Expected Rev. : PNG4
*/

gen expected_rev = PNG4*(0.0099)

local local_PNG PNG1 PNG2 PNG3 expected_rev
make_index_gr PNG wgt stdgroup `local_PNG'

save "$d3/r_CO_Merged_Ind.dta", replace



****************
** HH dataset **
clear
use "$d3/r_HH_Merged_PAP.dta"

* Drop Banke District & Pilot Co-op
drop if district == "Banke"
drop if r_treat == .
drop if idx == "" 

* Weights = 1 & control group
generate wgt = 1
generate stdgroup = r_treat

encode region, gen(n_region) // create numerical region variable for regression


** Winsorize LS9
* treatment
sum LS9 if r_treat == 1, d
scalar t_99 = r(p99)

replace LS9 = t_99 if LS9 > t_99 & !missing(LS9) & r_treat == 1

*control
sum LS9 if r_treat == 0, d
scalar c_99 = r(p99)

replace LS9 = c_99 if LS9 > c_99 & !missing(LS9) & r_treat == 0


** Replace Missing values with zero 
* LS9 , 
replace LS9 = 0 if LS9 ==.
replace co_opsalevalue = 0 if co_opsalevalue ==.


** Communication **

* Variables 

	* Total # of times HH is contacted
	gen HHcontact = COM3 + COM8


* HH comm index
local local_HH_comm COM3 COM8
make_index_gr HH_comm wgt stdgroup `local_HH_comm' 

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


** household level vars
gen co_opshare = 0
replace co_opshare = co_opgoatno / LS8 if LS8 != 0
gen visits_sale = -1*(LS40 / LS_n_sales)
gen time_passed = -1*(LS41)
gen transp_cost = -1*(LS42*(0.0099))


/* Costs
Amount spent purchasing goats: LSE12
Amount spent on feed/fodder : LSE15
Amount spent on vet care : LSE16
Amount spent on breeding fees : LSE17a * LSE17b
Amount spent on shelters : LSE18
*/

gen goat_costs = LSE12*(0.0099) + LSE15*(0.0099) + LSE16*(0.0099) + (LSE17a*LSE17b)*(0.0099) + LSE18*(0.0099)
gen net_goat_income = LS9*(0.0099) - goat_costs
gen netincome_goat = net_goat_income / LS8


local local_HH_goatsales LS8 LS9 co_opgoatno co_opsalevalue net_goat_income
make_index_gr HH_goatsales wgt stdgroup `local_HH_goatsales' 

local local_salecost visits_sale time_passed transp_cost
make_index_gr salecost wgt stdgroup `local_salecost' 


save "$d3/r_HH_Merged_Ind.dta", replace



