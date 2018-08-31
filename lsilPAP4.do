
clear all
set more off, perm

*log
cap log close
log using "$d1/lsilPAP4.smcl", replace

cd "$d2" 
ssc install nmissing


***********************************************
** 				Single variables			 **
***********************************************

* Gross Margin

 
 
***********************************************
** 				co-op indicators			 **
*********************************************** 
 
** co-op dataset **
clear
use "Baseline_Merged_Str_wdistrictnames copy.dta"

* Drop Banke District & Pilot Co-op
drop if district == "Banke"
drop if treat == .

* Weights = 1 & control group
generate wgt = 1
generate stdgroup = treat


** Communication **

/* Variables 
# of times initiated contact with SHG : comm1
# of times SHG initiated contact : comm2
# of SHGs met with : role_BMBMgrp_in2COMM5
Factors that limit communication : (not in index - used as control vars)
*/

	** Total # of times initiated contact
	gen comm1 = role_BMBMgrp_in1COMM1a + role_BMBMgrp_in1COMM1b ///
	+ role_BMBMgrp_in1COMM1c + role_BMBMgrp_in1COMM1d
	gen comm2 = role_BMBMgrp_in2COMM2a + role_BMBMgrp_in2COMM2b ///
	+ role_BMBMgrp_in2COMM2c + role_BMBMgrp_in2COMM2d
	** Factors that limit communication
	local vlist a b c d e f
	foreach var of local vlist {
		destring role_BMBMgrp_in3COMM8`var', replace
		}

local local_CO_comm comm1 comm2 role_BMBMgrp_in2COMM5 
make_index_gr CO_comm wgt stdgroup `local_CO_comm' 

* # missing observations
nmissing index_CO_comm
npresent index_CO_comm


** Cooperative Finances **

/* Variables 
Revenue from all activities : role_GMrevenuandcostREV4
Costs from all activities : role_GMrevenuandcostcalc_REC7
Assets : role_GMFinLiabiliteisFAL1
Liabilities : role_GMFinLiabiliteisFAL2
*/

	** Make Costs and Liabilities negative
	gen costs = -role_GMrevenuandcostcalc_REC7
	gen liabilities = -role_GMFinLiabiliteisFAL2

local local_CO_finances role_GMrevenuandcostREV4 costs role_GMFinLiabiliteisFAL1 liabilities
make_index_gr CO_finances wgt stdgroup `local_CO_finances' 

* # missing observations
nmissing index_CO_finances
npresent index_CO_finances


** Decision-Making **

/* Variables 
Setting interest rate (loans) : MAN18a 
Setting interest rate (savings) : MAN18b
Setting prices (traders) : MAN18c
Buying equipment : MAN18d
General assembly dates: MAN18e
*/

	foreach i in 25 27 29 31 33 {
		destring role_CPMgt_and_membersh`i', replace
		replace role_CPMgt_and_membersh`i' = . if role_CPMgt_and_membersh`i' == 97
		replace role_CPMgt_and_membersh`i' = . if role_CPMgt_and_membersh`i' == 4
		}

local local_CO_decision role_CPMgt_and_membersh25 role_CPMgt_and_membersh27 ///
	role_CPMgt_and_membersh29 role_CPMgt_and_membersh31 role_CPMgt_and_membersh33
make_index_gr CO_decision wgt stdgroup `local_CO_decision' 

* # missing observations
nmissing index_CO_decision
npresent index_CO_decision


** Evaluation & Assessment **

/* Variables 
External Evaluation : role_GMevalEAA1
Available to Co-op : role_GMevalEAA3
*/

	** Make EAA binary
	foreach i in 1 3 { 
		destring role_GMevalEAA`i', replace
		replace role_GMevalEAA`i' = 0 if  role_GMevalEAA`i' == 2
		replace role_GMevalEAA`i' = . if  role_GMevalEAA`i' == 97
		}

local local_CO_EAA role_GMevalEAA1 role_GMevalEAA3
make_index_gr CO_EAA wgt stdgroup `local_CO_EAA' 

* # missing observations
nmissing index_CO_EAA
npresent index_CO_EAA


** Goat Sales ** 

/* Variables 
# of goats sold : role_GMrevenuandcostREC1
revenue : role_GMrevenuandcostREC2
# of organized sales at collection points : Co_opGoat_transactionsGTT1
*/

local local_CO_goatsales role_GMrevenuandcostREC1 role_GMrevenuandcostREC2 Co_opGoat_transactionsGTT1
make_index_gr CO_goatsales wgt stdgroup `local_CO_goatsales' 

* # missing observations
nmissing index_CO_goatsales
npresent index_CO_goatsales


** Management Quality **

/* Variables
Education : HHR13
*/

*---- Need to fix collapsed dataset to include IND variables ----*


** Planning and Goals **

/* Variables 
Business Plan : role_GMplanandgoalsPNG1
Planning Time Horizon : role_GMplanandgoalsPNG2
Expected Goats Sold : role_GMplanandgoalsPNG3
Expected Total Revenue : role_GMplanandgoalsPNG4
*/

	* make PNG1 binary
	destring role_GMplanandgoalsPNG1, replace
	replace role_GMplanandgoalsPNG1 = 0 if role_GMplanandgoalsPNG1 == 2
	replace role_GMplanandgoalsPNG1 = . if role_GMplanandgoalsPNG1 == 97

local local_CO_PNG role_GMplanandgoalsPNG1 role_GMplanandgoalsPNG2 ///
	role_GMplanandgoalsPNG3 role_GMplanandgoalsPNG4
make_index_gr CO_PNG wgt stdgroup `local_CO_PNG' 

* # missing observations
nmissing index_CO_goatsales
npresent index_CO_goatsales


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

	forvalues i=1/7 { 
		destring role_GMtransTRN`i', replace
		replace role_GMtransTRN`i' = 0 if role_GMtransTRN`i' == 2
		replace role_GMtransTRN`i' = . if role_GMtransTRN`i' == 97
		}

	* correlation between household and co-op transparency
	forvalues i=1/7 {
		corr Co_opTransparencyTRN`i' role_GMtransTRN`i' 
		sum Co_opTransparencyTRN`i' role_GMtransTRN`i' 
		}
	
** Management Transparency	
local local_CO_trans role_GMtransTRN1 role_GMtransTRN2 ///
	role_GMtransTRN3 role_GMtransTRN4 role_GMtransTRN5 ///
	role_GMtransTRN6 role_GMtransTRN7
make_index_gr CO_trans wgt stdgroup `local_CO_trans' 

* # missing observations
nmissing index_CO_trans
npresent index_CO_trans


***********************************************
** 			  household indicators			 **
***********************************************

** household dataset **
clear
use "Household_PAP.dta"

* Drop Banke District & Pilot Co-op
drop if district == "Banke"
drop if treat == .

* Weights = 1 & control group
*generate wgt = 1
*generate stdgroup = treat



* W&C Dietary Diversity

 gen WDD = Food_ConsumptionGrainsFC1A + Food_ConsumptionPulsesFC1B + Food_ConsumptionMeat_fish_and_e0 + ///
 Food_ConsumptionDairy_productsFC + Food_ConsumptionFruitsFC1E + Food_ConsumptionVegetablesFC1F ///
 + Food_ConsumptionSugar_and_or_sw0 + Food_ConsumptionOilFC1H

* # missing observations
nmissing WDD
npresent WDD


** Communication **

/* Variables 
# of times member received information about sales : Co_opCommunicationCOM3
# of times member received information about activities : Co_opCommunicationCOM8
*/

local local_HH_comm Co_opCommunicationCOM3 Co_opCommunicationCOM8 
make_index_gr HH_comm wgt stdgroup `local_HH_comm' 

* # missing observations
nmissing index_HH_comm
npresent index_HH_comm


** Goat Sales ** 

/* Variables 
# of goats sold : co_opgoatno
revenue : co_opsalevalue
# of organized sales at collection points : Co_opGoat_transactionsGTT1
*/

local local_HH_goatsales co_opgoatno co_opsalevalue Co_opGoat_transactionsGTT1 
make_index_gr HH_goatsales wgt stdgroup `local_HH_goatsales' 


** Membership **

/* Variables 
% of members who have attended a co-op meeting : Co_opMembershipMEM8
# of SHG meetings attended in the last 6 months ; Co_opMembershipMEM7
*/


local local_HH_membership Co_opMembershipMEM8 Co_opMembershipMEM7
make_index_gr membership wgt stdgroup `local_HH_membership' 

* # missing observations
nmissing index_HH_membership
npresent index_HH_membership


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


	forvalues i=1/7 { 
		destring role_GMtransTRN`i', replace
		replace role_GMtransTRN`i' = 0 if role_GMtransTRN`i' == 2
		replace role_GMtransTRN`i' = . if role_GMtransTRN`i' == 97
		}

	* correlation between household and co-op transparency
	forvalues i=1/7 {
		corr Co_opTransparencyTRN`i' role_GMtransTRN`i' 
		sum Co_opTransparencyTRN`i' role_GMtransTRN`i' 
		}


** Household Transparency
local local_HH_TRN Co_opTransparencyTRN1 Co_opTransparencyTRN2 ///
	Co_opTransparencyTRN3 Co_opTransparencyTRN4 Co_opTransparencyTRN5 ///
	Co_opTransparencyTRN6 Co_opTransparencyTRN7
make_index_gr HH_TRN wgt stdgroup `local_HH_TRN' 

* # missing observations
nmissing index_HH_TRN
npresent index_HH_TRN



	
** Transparency Discrepancy index
	forvalues i=1/7 { 
		gen dTRN`i' = 1 if role_GMtransTRN`i' == Co_opTransparencyTRN`i' ///
			&  !missing(role_GMtransTRN`i') & !missing(Co_opTransparencyTRN`i')
		replace dTRN`i' = 0 if role_GMtransTRN`i' != Co_opTransparencyTRN`i' ///
			&  !missing(role_GMtransTRN`i') & !missing(Co_opTransparencyTRN`i')
		}
		
	forvalues i=1/7 { 
		tab dTRN`i'
		nmissing dTRN`i'
		}
	
** Transparency Discrepancy
local local_dTRN dTRN1 dTRN2 dTRN3 dTRN4 dTRN5 dTRN6 dTRN7
make_index_gr dTRN wgt stdgroup `local_dTRN' 
	
* # missing observations
nmissing index_dTRN
npresent index_dTRN
	
	
	
	
	
	
	
	
	
	
	
	
	
	
