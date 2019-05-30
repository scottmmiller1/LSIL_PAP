clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP4.smcl", replace


/*******************************************************************************
lsilPAP4.d0		
					
- Creates indicator variables & ICW Summary Indices from
	r_CO_Merged_PAP.dta (co-op level dataset)
	and r_HH_Merged_PAP.dta (HH level dataset)
	Saves new datasets respectively as: 
	r_CO_Merged_Ind.dta
	r_HH_Merged_Ind.dta
	
*******************************************************************************/

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


** Communication **

* factors that limit communication
/* Variables
Mobile Network : COMM8b
Distance : COMM8d
*/


** Transparency **

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
Business Plan : PNG1
Time Horizon : PNG2
Expected Goats Sold : PNG3
Expected Rev. : PNG4
*/

gen expected_rev = PNG4*(0.0099)
replace PNG2 =. if PNG2 == 99


local local_PNG PNG1 PNG2 PNG3 expected_rev
make_index_gr PNG wgt stdgroup `local_PNG'



** Cooperative Characteristics **

/* Variables 
Members : MAN3
# of goats sold : REC1
Revenue from all activities : role_GMrevenuandcostREV4
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
foreach v of varlist EQP1_2 EQP2_2 EQP2_2X EQP4_2 EQP5_2 EQP6_2 {
	replace `v' = 0 if `v' ==.
}
replace goats_sold = 0 if goats_sold ==.
replace revenue = 0 if revenue ==.

replace rev_member = 0 if rev_member ==.
replace costs = 0 if costs ==.
replace cost_mem = 0 if cost_mem ==.		


* ICT and non-ICT assets
gen ICTassets = EQP1_2 + EQP2_2
gen Otherassets = EQP2_2X + EQP4_2 + EQP5_2 + EQP6_2



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



** Communication **

/* Variables 
Total times contacted about livestock sales : COM3
Total times contacted about livestock activities : COM8
*/

replace COM3 = 0 if COM3 ==.
replace COM8 = 0 if COM8 ==.

local local_HHcomm COM3 COM8
make_index_gr HHcomm wgt stdgroup `local_HHcomm' 


** Transparency **

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


	
** Transparency Discrepancy index
	forvalues i=1/7 { 
		gen dTRN`i' = 1 if CO_TRN`i' == HH_TRN`i' ///
			&  !missing(CO_TRN`i') & !missing(HH_TRN`i')
		replace dTRN`i' = 0 if CO_TRN`i' != HH_TRN`i' ///
			&  !missing(CO_TRN`i') & !missing(HH_TRN`i')
		}
		
local local_dTRN dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7
make_index_gr dTRN wgt stdgroup `local_dTRN' 




** Goat Sales ** 

/* Variables 
# of goats sold : LS8
goat revenue : LS9
goats sold through co-op : co_opgoatno
goat revenue through co-op : co_opsalevalue

Amount spent purchasing goats: LSE12
Amount spent on feed/fodder : LSE15
Amount spent on vet care : LSE16
Amount spent on breeding fees : LSE17a * LSE17b
Amount spent on shelters : LSE18
Net goat income
*/


** household level vars

** Winsorize LS9
* -----------------------------------------------
gen LS9_w = LS9

* treatment
sum LS9_w if r_treat == 1, d
scalar t_99 = r(p99)

replace LS9_w = t_99 if LS9_w > t_99 & !missing(LS9_w) & r_treat == 1

*control
sum LS9_w if r_treat == 0, d
scalar c_99 = r(p99)

replace LS9_w = c_99 if LS9_w > c_99 & !missing(LS9_w) & r_treat == 0
* -----------------------------------------------


** Replace Missing values with zero
* ----------------------------------------------- 
* LS9 , 
replace LS9_w = 0 if LS9_w ==.
replace LS8 = 0 if LS8 ==.
replace co_opsalevalue = 0 if co_opsalevalue ==.
replace co_opgoatno = 0 if co_opgoatno ==.
foreach v of varlist LSE12 LSE15 LSE16 LSE17a LSE17b LSE18 {
	replace `v' = 0 if `v'==.
	}
* -----------------------------------------------


* covert to USD
replace LS9_w = LS9_w*(0.0099)
replace co_opsalevalue = co_opsalevalue*(0.0099)

* generate net income
gen goat_costs = LSE12*(0.0099) + LSE15*(0.0099) + LSE16*(0.0099) + (LSE17a*LSE17b)*(0.0099) + LSE18*(0.0099)
gen net_goat_income = LS9_w - goat_costs


local local_HH_goatsales LS8 LS9_w co_opgoatno co_opsalevalue net_goat_income
make_index_gr HH_goatsales wgt stdgroup `local_HH_goatsales' 



** Characteristics ** 

/* Variables 
Age : HHR4
Literacy : HHR14
Total # of SHG meetings attended in past 6 months : MEM11
Trust co-op leadership : MGT4
*/

replace MEM11 = 0 if MEM11 ==.
replace HHR14 = . if HHR4 < 18



save "$d3/r_HH_Merged_Ind.dta", replace



