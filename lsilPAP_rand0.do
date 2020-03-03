
/*******************************************************************************
lsilPAP_rand0.do		
					
- Collapses livestock sales data into one row per hh
	
- Merges household and cooperative data. Top codes total goats sold and total
livestock revenue at hh level. 
	
*******************************************************************************/

cap log close
set more off, perm

cd "$d1"
log using "$d1/lsilPAP_rand0.smcl", replace


* ------------------------------------------------------------------------------
** Collapse livestock sales module to HH level **

* load livestock sales data
use "$d4/Household/Livestock_Sales_livestock.dta", clear

* shorten names that are too long for macros
foreach v of var * {
	cap local vv = subinstr("`v'", "Livestock_Saleslivestock", "Livestock_Sales",.)
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
}

* drop non-data observations / administrative tags / unused variables
drop Livestock_SalesLS2 Livestock_SalesLS6 ///
		Livestock_SalesLS6_1 ___id ___uuid ___submission_time ///
		___index ___parent_table_name ___tags ___notes Livestock_SalesLS4 
drop if ___parent_index ==.

* generate 'revenue from goat sales made through co-op'		
gen co_opsalevalue = Livestock_SalesLS9 if Livestock_SalesLS3=="1" 			
lab var co_opsalevalue "Total revenue, goats sold through co-op"

* generate 'number of goat sales made through co-op'	
gen co_opgoatno = Livestock_SalesLS8 if Livestock_SalesLS3=="1"		
lab var co_opgoatno "Total goats sold through co-op"

* destring all variables
destring *, replace		
recode * (99=.) (98=.) (97=.)
 
* save variable labels to re-apply post collapse 
foreach v of var * {
	cap local vv = subinstr("`v'", "Livestock_Sales", "Livestock_Sales",.) // names too long for macros
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

* collapse to HH level
collapse (mean) Livestock_SalesLS3 *Livestock_SalesLS6* ///
		Livestock_SalesLS7 (sum) Livestock_SalesLS8 Livestock_SalesLS9 ///
		Livestock_SalesLS10 Livestock_SalesLS12 Livestock_SalesLS13 ///
		Livestock_SalesLS14 Livestock_SalesLS15 Livestock_SalesLS16 ///
		Livestock_SalesLS17 Livestock_SalesLS25 Livestock_SalesLS26 ///
		Livestock_SalesLS27 Livestock_SalesLS28 Livestock_SalesLS29 ///
		Livestock_SalesLS30 Livestock_SalesLS31 *Livestock_SalesLS32* ///
	    Livestock_SalesLS33 Livestock_SalesLS34 ///
		Livestock_SalesLS35 Livestock_SalesLS36 Livestock_SalesLS37 ///
		Livestock_SalesLS38 Livestock_SalesLS39 Livestock_SalesLS40 ///
		Livestock_SalesLS41 Livestock_SalesLS42 *Livestock_SalesLS43* ///
		Livestock_SalesLS44 Livestock_SalesLS45 Livestock_SalesLS46 ///
		Livestock_SalesLS47 co_opsalevalue co_opgoatno , by(___parent_index)

* reapply variable labels		
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}
		
** Top coding obvious outliers
g price = Livestock_SalesLS9/Livestock_SalesLS8
g n = _n
*scatter Livestock_SalesLS9 price, mlabel(n)
*br n Livestock_SalesLS8 Livestock_SalesLS9 price if n == 1035 | n == 10 | n == 11 | n == 1222 | n == 1199

su price, d
replace Livestock_SalesLS9 = r(p50)*Livestock_SalesLS8 if n == 1035 | n == 10 | n == 11 | n == 1222 | n == 1199

drop n price

su *LS8, d
replace Livestock_SalesLS8 = r(p50) if Livestock_SalesLS8 > 25 & ///
Livestock_SalesLS8 < . // Replaces outliers with median


* save collapsed data
save "$d4/Household/Livestock_sales_collapse.dta", replace


* --------------------------------------------------------------------
 * Collection Points Module
clear
use "$d4/Co-op/role_CP_Collectionpoint.dta"
 
drop role_CPCollectionpointCollection ___id ___uuid ___submission_time ___parent_table_name ___tags ___notes
 
destring role_CPCollectionpointCollectio0, replace
recode * (99=.) (98=.) (97=.)
	 
collapse (mean) role_CPCollectionpointCollectio0 (sum) role_CPCollectionpointCollectio1 ///
		role_CPCollectionpointCollectio4 role_CPCollectionpointCollectio5, by(___index)
 
save "$d4/Co-op/role_CP_Collectionpoint_collapsed.dta", replace
 
use "$d4/Co-op/Cooperative.dta", clear
 
cap drop _merge
 
merge 1:1 ___index using "$d4/Co-op/role_CP_Collectionpoint_collapsed.dta"
 
save "$d4/Co-op/Cooperative1.dta", replace



** Merge Cooperative & Household Data **
* ------------------------------------------------------------------------------
** Create co-op dataset collapsed to 1-row per co-op **

cd "$d4/Co-op/"  

* load co-op data
use "$d4/Co-op/Cooperative1.dta", clear

* generate names for region variable
destring ID1, replace
gen region = "" 
replace region = "Arghakanchhi" if ID1==51
replace region = "Baglung" if ID1==45
replace region = "Banke" if ID1==57
replace region = "Bardiya" if ID1==58
replace region = "Chitwan" if ID1==35
replace region = "Dang" if ID1==56
replace region = "Dhading" if ID1==30
replace region = "Kaski" if ID1==40
replace region = "Kapilbastu" if ID1==50
replace region = "Lamjung" if ID1==37
replace region = "Mahottari" if ID1==18
replace region = "Morang" if ID1==5
replace region = "Nawalparasi" if ID1==48
replace region = "Nuwakot" if ID1==28
replace region = "Palpa" if ID1==47
replace region = "Parbat" if ID1==44
replace region = "Pyuthan" if ID1==52
replace region = "Rautahat" if ID1==32
replace region = "Rupandehi" if ID1==49
replace region = "Salyan" if ID1==55
replace region = "Sarlahi" if ID1==19
replace region = "Sindhuli" if ID1==20
replace region = "Surkhet" if ID1==59
replace region = "Tanahu" if ID1==38

* group regions into "Mid-Hills" and "Terai"
replace region = "Mid-Hills" if region=="Arghakanchhi" | region=="Baglung" | ///
	region=="Dhading" | region =="Kaski" | region =="Lamjung" | region=="Nuwakot" | ///
	region=="Palpa" | region =="Parbat" | region =="Pyuthan" | region =="Salyan" | ///
	region=="Tanahu" | region =="Sindhuli"
	 
replace region = "Terai" if region=="Banke" | region =="Bardiya" | region =="Kapilbastu" | ///
	region=="Mahottari" | region =="Morang" | region =="Nawalparasi" | ///
	region=="Rautahat" | region =="Rupandehi" | region=="Sarlahi" | region =="Surkhet" | ///
	region =="Chitwan" | region =="Dang"

save "$d4/Co-op/Cooperative1.dta", replace
  
 
* Co-op dataset contains 3-interviews per co-op
* create separate datasets for each role

* -------------------------------- 
*Role 1 (Chairperson)
use "$d4/Co-op/Cooperative1.dta", clear
 
keep *id* *ID* *CP* role region

* save labels and value labels in macros
foreach v of var * {
	cap local vv = subinstr("`v'", "CPManagement", "CPMgt",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "CPServices", "CPSer",.)
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "transactions", "trans",.)
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Collection", "Coll",.)
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

ds *CP* region, has(type string)
local CPstrings = "`r(varlist)'"
ds *CP*, has(type numeric)
local CPnumeric = "`r(varlist)'"

collapse (firstnm) `CPstrings' (mean) `CPnumeric', by(idx role)

* re-assign labels post-collapse
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

drop if role !="1"

sort idx

save "$d4/Co-op/role1.dta", replace 

 
* -------------------------------- 
*Role 2 (General Manager)
use "$d4/Co-op/Cooperative1.dta", clear

keep *id* *ID* *GM* role region

* save labels and value labels in macros
foreach v of var * {
	cap local vv = subinstr("`v'", "GMequipment", "GMeqpmt",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "GMEquipment", "GMEqpmt",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "GMFinancial", "GMFin",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "planning", "plan",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}	
	cap local vv = subinstr("`v'", "evalassment", "eval",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "transpernacy", "trans",.) // names too long for macros
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

ds *GM* region, has(type string)
local GMstrings = "`r(varlist)'"
ds *GM*, has(type numeric)
local GMnumeric = "`r(varlist)'"

collapse (firstnm) `GMstrings' (mean) `GMnumeric', by(idx role)

* re-assign labels post-collapse
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

drop if role !="2"

save "$d4/Co-op/role2.dta", replace
 
 
* -------------------------------- 
*Role 3 (Board Member)
use "$d4/Co-op/Cooperative1.dta", clear

keep *id* *ID* *BM* role region

* save labels and value labels in macros
foreach v of var * {
	cap local vv = subinstr("`v'", "intro", "in",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "transactions", "trans",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Planning", "plan",.) // names too long for macros
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

ds *BM* region, has(type string)
local BMstrings = "`r(varlist)'"
ds *BM*, has(type numeric)
local BMnumeric = "`r(varlist)'"

collapse (firstnm) `BMstrings' (mean) `BMnumeric', by(idx role)

* re-assign labels post-collapse
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

drop if role !="3"

save "$d4/Co-op/role3.dta", replace
 
* -------------------------------- 
* merge separate roles to create one dataset at the co-op level
* each co-op (row) will now contain all 3-role interviews
 
*numeric idx identifiers
use "$d4/Co-op/role1.dta", clear
sort idx
*drop idx_n
encode idx, gen(idx_n)
save "$d4/Co-op/role1.dta", replace

use "$d4/Co-op/role2.dta", clear
sort idx
*drop idx_n
encode idx, gen(idx_n)
save "$d4/Co-op/role2.dta", replace
 
use "$d4/Co-op/role3.dta", clear
sort idx
*drop idx_n
encode idx, gen(idx_n)
save "$d4/Co-op/role3.dta", replace
  
*merge dataset
use "$d4/Co-op/role1.dta", clear
merge 1:1 idx_n using role2.dta
save "$d4/Co-op/co-op_merged.dta", replace
drop _merge
 

use "$d4/Co-op/co-op_merged.dta", clear
drop _merge
merge 1:1 idx_n using role3.dta
rename _merge merge3
save "$d4/Co-op/co-op_merged.dta", replace


* ------------------------------------------------------------------------------
** Create Household dataset collapsed to 1-row per HH **
 
** Merge separate modules into Household
cd "$d4/Household/"

*create merge variable 'merge_id'
*household
use "$d4/Household/Household.dta", clear
gen merge_id = ___index

* generate region variable
destring HH_IDID1, replace
gen region = "Arghakanchhi" if HH_IDID1==51
replace region = "Baglung" if HH_IDID1==45
replace region = "Banke" if HH_IDID1==57
replace region = "Bardiya" if HH_IDID1==58
replace region = "Chitwan" if HH_IDID1==35
replace region = "Dang" if HH_IDID1==56
replace region = "Dhading" if HH_IDID1==30
replace region = "Kaski" if HH_IDID1==40
replace region = "Kapilbastu" if HH_IDID1==50
replace region = "Lamjung" if HH_IDID1==37
replace region = "Mahottari" if HH_IDID1==18
replace region = "Morang" if HH_IDID1==5
replace region = "Nawalparasi" if HH_IDID1==48
replace region = "Nuwakot" if HH_IDID1==28
replace region = "Palpa" if HH_IDID1==47
replace region = "Parbat" if HH_IDID1==44
replace region = "Pyuthan" if HH_IDID1==52
replace region = "Rautahat" if HH_IDID1==32
replace region = "Rupandehi" if HH_IDID1==49
replace region = "Salyan" if HH_IDID1==55
replace region = "Sarlahi" if HH_IDID1==19
replace region = "Sindhuli" if HH_IDID1==20
replace region = "Surkhet" if HH_IDID1==59
replace region = "Tanahu" if HH_IDID1==38

replace region = "Mid-Hills" if region=="Arghakanchhi" | region=="Baglung" | ///
	region=="Dhading" | region =="Kaski" | region =="Lamjung" | region=="Nuwakot" | ///
	region=="Palpa" | region =="Parbat" | region =="Pyuthan" | region =="Salyan" | ///
	region=="Tanahu" | region =="Sindhuli"
	 
replace region = "Terai" if region=="Banke" | region =="Bardiya" | region =="Kapilbastu" | ///
	region=="Mahottari" | region =="Morang" | region =="Nawalparasi" | ///
	region=="Rautahat" | region =="Rupandehi" | region=="Sarlahi" | region =="Surkhet" | ///
	region =="Chitwan" | region =="Dang"

* save HH dataset	
save "$d4/Household/Household1.dta", replace

* --------------------------------
*Livestock Sales
*clear 
use "$d4/Household/Livestock_sales_collapse.dta"
gen merge_id = ___parent_index
save "$d4/Household/Livestock_sales_collapse.dta", replace

* --------------------------------
*Borrowing
use "$d4/Household/Borrowing.dta", clear
gen merge_id = ___parent_index 
save "$d4/Household/Borrowing1.dta", replace 

* --------------------------------
*Number of Children
use "$d4/Household/Number of Children.dta", clear
gen merge_id = ___parent_index 
save "$d4/Household/Number of Children1.dta", replace

* --------------------------------
*Roster
use "$d4/Household/Rooster.dta", clear
gen merge_id = ___parent_index   
save "$d4/Household/Rooster1.dta", replace


* create merged dataset 'modules_merged'

* --------------------------------
*Livestock Sales - Borrowing
use "$d4/Household/Household1.dta", clear
merge m:m merge_id using Borrowing1.dta, force
rename _merge merge1
save "$d4/Household/modules_merged.dta", replace

* --------------------------------
*Number of Children
use "$d4/Household/modules_merged.dta", clear
merge m:m merge_id using "$d4/Household/Number of Children1.dta", force
rename _merge merge2
save "$d4/Household/modules_merged.dta", replace 

* --------------------------------
*Roster
use "$d4/Household/modules_merged.dta", clear
merge m:m merge_id using "$d4/Household/Rooster1.dta", force
rename _merge merge3
save "$d4/Household/modules_merged.dta", replace  

* --------------------------------
*merge modules_merged into Household
use "$d4/Household/modules_merged.dta", clear
merge m:1 merge_id using "$d4/Household/Livestock_sales_collapse.dta", force
save "$d4/Household/Household_Merged.dta", replace
 
 
*------------------------------------------------------------------------------- 
** Prepare Household_Merged to be collapsed by Co-op **
 
use "$d4/Household/Household_Merged.dta", clear
 
*drop irrelevant vars
*section timing, notes, section headers, other (specificy), etc.
drop start end HH_IDstartHHID HH_IDendHHID end_rooster Number_children_count ///
	Land_and_homestart_land Land_and_homeLand_and_home_note Land_and_homeEnd_land ///
	Co_opstart_coop Co_opMembershipMEM2header_MEM2 Co_opMembershipMEM4_1 Co_opMembershipMEM9_1 ///
	Co_opMembershipMEM10MEM10_Header Co_opMembershipMEM13_1 Co_opManagementMGT1_1 ///
	Co_opCommunicationCOM1_1 Co_opCommunicationCOM2_1 Co_opCommunicationCOM6_1 ///
	Co_opCommunicationCOM11_1 Co_opGoat_transactionsGTT4_1 Co_opTransparencyTransparency_no ///
	Co_opFollow_up_transparency_que4 Savingsstart_savings SavingsSavings_Note ///
	SavingsSV2_1 Savingsend_savings Borrowingstart_borrowing Borrowingend_borrowing ///
	Food_Consumptionstart_food Food_ConsumptionGrainsGrains_Not Food_ConsumptionPulsesPulses_not ///
	Food_ConsumptionMeat_fish_and_eg Food_ConsumptionDairy_productsDa Food_ConsumptionFruitsFruits_not ///
	Food_ConsumptionVegetablesVegeta Food_ConsumptionSugar_and_or_swe Food_ConsumptionOilOil_note ///
	time_food start_stockR Livestock_related_empowerment021 Livestock_related_empowermentend ///
	Livestock_Enterprisesstart_lives Livestock_Enterpriseslocalfemale Livestock_EnterpriseslocalmaleLo ///
	Livestock_Enterprisesexoticfemal Livestock_Enterprisesend_livesto Goat_Production_Systemstart_goat ///
	Goat_Production_SystemGoat_Produ Goat_Production_SystemGP2_1 Goat_Production_SystemGP4_1 ///
	Goat_Production_SystemGP8_1 Goat_Production_Systemend_goat Livestock_Salesstart_sales ///
	Post_questionnairePQ1_1 Post_questionnairePQ1 Post_questionnaireGPS ///
	____version metainstanceID ___uuid ___submission_time ___tags ___notes BorrowingBorrowBorrowing_Note ///
	merge1 merge2 Rosterstart_Rooster RosterRoster_Note merge3 _merge ///
    HH_IDID5_2 Livestock_EnterprisesLSE10_2 Livestock_EnterprisesLSE10_3 Livestock_EnterprisesLSE10_1 SavingsSV8_1 ///
	Livestock_EnterprisesLSE1 Goat_Production_SystemGP22_1 Goat_Production_SystemGP22_2 RosterHHR1 RosterHHR2 ///
	Goat_Production_SystemGP22_1 Goat_Production_SystemGP22_2


*drop multi-choice vars with individual dummys already created
drop Co_opCommunicationCOM1 Co_opCommunicationCOM2 Co_opCommunicationCOM6 Co_opCommunicationCOM7 ///
	Co_opGoat_transactionsGTT4 SavingsSV2 Livestock_related_empowermentEMP Livestock_related_empowermentEM8 ///
	Livestock_related_empowermentE09 Livestock_related_empowermentE21 Livestock_related_empowermentE32 ///
	Livestock_related_empowermentE44 Livestock_related_empowermentE55 Livestock_related_empowermentE66 ///
	Livestock_related_empowermentE77 Livestock_related_empowermentE88 Livestock_related_empowermentE99 ///
	Livestock_related_empowerment010 Livestock_related_empowerment024 Livestock_EnterprisesLSE22 ///
	Goat_Production_SystemGP4 Goat_Production_SystemGP12 Goat_Production_SystemGP18 Goat_Production_SystemGP22 ///
	Goat_Production_SystemGP25 Livestock_SalesLS48 Post_questionnairePQ2 BorrowingBorrowBR5 ///
	Goat_Production_SystemGP3 BorrowingBorrowBR56 BorrowingBorrow_count RosterHHR10_1	

 
*create multi-choice dummys for other relevant vars
foreach v of varlist HH_IDID7 HH_IDID8 HH_IDHHR7 HHR7_calc Land_and_homeLND2 ///
		Land_and_homeLND3 Land_and_homeHSE1 Land_and_homeHSE2 Land_and_homeHSE3 ///
		Land_and_homeHSE8 Land_and_homeHSE9 Land_and_homeHSE11 Land_and_homeHSE12 ///
		Land_and_homeHSE13 Co_opMembershipMEM4 Co_opMembershipMEM5 Co_opMembershipMEM9 ///
		Co_opMembershipMEM13 Co_opManagementMGT1 Co_opManagementMGT2 Co_opManagementMGT6 ///
		Co_opCommunicationCOM4 Co_opCommunicationCOM10 Co_opCommunicationCOM11 {
	quietly tab `v', generate(`v'_)
    drop `v'
}

*Rename Livestock Related Enterprises -----
rename Livestock_related_empowermentE08 LSE08 
rename Livestock_related_empowermentE20 LSE20
rename Livestock_related_empowermentE31 LSE31
rename Livestock_related_empowermentE43 LSE43
rename Livestock_related_empowermentE54 LSE54
rename Livestock_related_empowermentE65 LSE65
rename Livestock_related_empowermentE76 LSE76
rename Livestock_related_empowermentE87 LSE87
rename Livestock_related_empowermentE98 LSE98
rename Livestock_related_empowerment009 LS009
rename Livestock_related_empowerment020 LSE020
rename Livestock_related_empowerment022 LSE022
rename Livestock_related_empowerment023 LSE023


* generate tabbed variables
foreach v of varlist LSE08 LSE20 LSE31 LSE43 LSE54 LSE65 LSE76 LSE87 ///
		LSE98 LS009 LSE022 LSE023 {
	quietly tab `v', generate(`v'_)
    drop `v'	
}
foreach v of varlist Goat_Production_SystemGP5 Goat_Production_SystemGP6 ///
		Goat_Production_SystemGP8 Goat_Production_SystemGP17 Goat_Production_SystemGP20 ///
		BorrowingBorrowBR7 RosterHHR9 {
    quietly tab `v', generate(`v'_)
    drop `v'
}
	
* shorten variable names
rename Livestock_SalesLS43LS43 LSS4343
rename Livestock_SalesLS43LS40 LSS4340
rename Livestock_SalesLS43LS41 LSS4341

* generate tabbed variables		
foreach v of varlist RosterHHR10 RosterHHR16 *Livestock_SalesLS7* *Livestock_SalesLS38* {
    quietly tab `v', generate(`v'_)
    drop `v'
} 
foreach v of varlist Goat_Production_SystemGP2 Goat_Production_SystemGP14 Goat_Production_SystemGP24 ///
		BorrowingBorrowBR4 RosterHHR8 {
    quietly tab `v', generate(`v'_)
    drop `v'
}
 
 
* Destring 1-2 dummys -- format to binary
	* 2 -> 0  1 -> 1 ------ Most are Y/N --> Y=1 N=0
foreach v of varlist Land_and_homeHSE6 Land_and_homeHSE7 Land_and_homeHSE10 ///
		Co_opMembershipMEM3 Co_opMembershipMEM6 Co_opMembershipMEM8 Co_opMembershipMEM12 ///
		Co_opMembershipMEM14 Co_opMembershipMEM16 Co_opServiceSER1 Co_opServiceSER2 ///
		Co_opServiceSER3 Co_opServiceSER4 Co_opServiceSER6 Co_opServiceSER7 ///
		Co_opServiceSER8 Co_opServiceSER9 Co_opServiceSER10 Co_opServiceSER11 ///
		Co_opServiceSER12 Co_opServiceSER13 Co_opServiceSER14 Co_opServiceSER15 ///
		Co_opServiceSER16 Co_opServiceSER17 Co_opServiceSER18 Co_opServiceSER19 ///
		Co_opFollow_up_service_questions Co_opFollow_up_service_question0 Co_opFollow_up_service_question1 ///
		Co_opFollow_up_service_question2 Co_opFollow_up_service_question3 Co_opFollow_up_service_question4 ///
		Co_opFollow_up_service_question5 Co_opFollow_up_service_question6 Co_opFollow_up_service_question7 ///
		Co_opFollow_up_service_question8 Co_opFollow_up_service_question9 Co_opManagementMGT3_1 ///
		Co_opManagementMGT4 Co_opManagementMGT5 Co_opCommunicationCOM5 Co_opTransparencyTRN1 ///
		Co_opTransparencyTRN2 Co_opTransparencyTRN3 Co_opTransparencyTRN4 Co_opTransparencyTRN5 ///
		Co_opTransparencyTRN6 Co_opTransparencyTRN7 Co_opTransparencyTRN8 Co_opFollow_up_transparency_ques ///
		Co_opFollow_up_transparency_que0 Co_opFollow_up_transparency_que1 Co_opFollow_up_transparency_que2 ///
		Co_opFollow_up_transparency_que3 SavingsSV3 SavingsSV4 SavingsSV7 SavingsSV8 ///
		BorrowingBR1 Food_ConsumptionGrainsFC1A Food_ConsumptionPulsesFC1B Food_ConsumptionMeat_fish_and_e0 ///
		Food_ConsumptionDairy_productsFC Food_ConsumptionFruitsFC1E Food_ConsumptionVegetablesFC1F ///
		Food_ConsumptionSugar_and_or_sw0 Food_ConsumptionOilFC1H Goat_Production_SystemGP7 ///
		Goat_Production_SystemGP13 Goat_Production_SystemGP16 Goat_Production_SystemGP19 ///
		Goat_Production_SystemGP21 RosterHHR3 RosterHHR5 RosterHHR11 RosterHHR13 RosterHHR14 ///
		RosterHHR15 RosterHHR17 RosterHHR18 RosterHHR19 Livestock_SalesLS3 ///
		Livestock_SalesLS39 Livestock_SalesLS44 ///
		Livestock_SalesLS45 {
	quietly destring `v', replace
	quietly replace `v'=. if `v'==99 | `v'== .
	quietly replace `v'=0 if `v'==2
}
 
* Destring 0-1 dummys
foreach v of varlist * {
	cap local vv = subinstr("`v'", "Livestock_Saleslivestock", "Livestock_Sales", .)
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
}

quietly destring *Co_opCommunicationCOM1* *Co_opCommunicationCOM2* *Co_opCommunicationCOM6*, replace 
quietly destring *Co_opCommunicationCOM7* *Co_opGoat_transactionsGTT4* *SavingsSV2* *Livestock_related_empowermentEM*, replace 
quietly destring *Livestock_related_empowermentE1* *Livestock_related_empowermentE2* *Livestock_related_empowermentE3*, replace 
quietly destring *Livestock_related_empowermentE4* *Livestock_related_empowermentE5* *Livestock_related_empowermentE6*, replace 
quietly destring *Livestock_related_empowermentE7* *Livestock_related_empowermentE8* *Livestock_related_empowermentE9*, replace 
quietly destring *Livestock_related_empowerment0* *Livestock_Enterprises* *Livestock_SalesLS*, replace 
quietly destring *BorrowingBorrowBR5* Number_childrencalculation *RosterHHR8* RosterHHR12 *Livestock_SalesLS6*, replace 
quietly destring *Goat_Production_SystemGP* Roster_count Livestock_related_empowermentE07 *LSE08* Livestock_Sales_count, replace

save "$d4/Household/Household_Merged_Edit.dta", replace	 
 
 
*------------------------------------------------------------------------------  
** Collapse HH into 1 row per cooperative
 
use "$d4/Household/Household_Merged_Edit.dta", clear

rename HH_IDIDX idx

* Shorten names that are too long for macros
foreach v of var * {
	cap local vv = subinstr("`v'", "Follow_up_", "Follup",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Food_Consumption", "Food_Cons",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Livestock_related_empowerment", "Livestock_empowerment",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Livestock_Enterprises", "Livestock_Enter",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
	cap local vv = subinstr("`v'", "Post_questionnaire", "Post_",.) // names too long for macros
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

ds *HH_* *Roster* *Land* *Co_op* *Savings* *Borrowing* *Food* *LS* *Prod*, has(type string)
local HHstrings = "`r(varlist)'"
ds *HH_* *Roster* *Land* *Co_op* *Savings* *Borrowing* *Food* *LS* *Prod*, has(type numeric)
local HHnumeric = "`r(varlist)'"

collapse (firstnm) `HHstrings' (mean) `HHnumeric' co_opsalevalue co_opgoatno, by(idx)

* re-assign labels post-collapse
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

* saved collapsed HH data
save "$d4/Household/Household_Collapsed.dta", replace


*------------------------------------------------------------------------------  
** Merge Co-op_merged into HH_Collapsed

clear 
use "$d4/Household/Household_Collapsed.dta"  
 
sort idx
drop if idx =="Karmath SEWC 2"
encode idx, gen(idx_n)
 
merge 1:1 idx_n using "$d4/Co-op/co-op_merged.dta"
drop *merge*

* Create per member measures of revenue and cost
destring role_GMrevenuandcostcalc_REC7, replace
replace role_GMrevenuandcostcalc_REC7 = role_GMrevenuandcostcalc_REC7/1000
lab var role_GMrevenuandcostcalc_REC7 "Total co-op cost, 1000 Rs"
destring role_GMrevenuandcostREV4, replace
replace role_GMrevenuandcostREV4 = role_GMrevenuandcostREV4/1000
lab var role_GMrevenuandcostREV4 "Total co-op revenue, 1000 Rs"

gen totrev_member = role_GMrevenuandcostREV4 / role_CPMgt_and_membershi1
gen totcost_mem = role_GMrevenuandcostcalc_REC7 / role_CPMgt_and_membershi1
gen goatssold_mem = role_GMrevenuandcostREC1 / role_CPMgt_and_membershi1

lab var totrev_member "Co-op revenue (all sources) per member"
lab var totcost_mem "Co-op cost (all sources) per member"
lab var goatssold_mem "Co-op goats sold per member"

save "$d4/Merged/Baseline_Merged.dta", replace
 
 
*------------------------------------------------------------------------------  
** Remove intermediary datasets
* co-op
erase "$d4/Co-op/role_CP_Collectionpoint_collapsed.dta" 
erase "$d4/Co-op/Cooperative1.dta"
erase "$d4/Co-op/co-op_merged.dta"
forvalues i=1/3 {
	erase "$d4/Co-op/role`i'.dta"
}
* household 
erase "$d4/Household/Borrowing1.dta"
erase "$d4/Household/Household_Collapsed.dta"
erase "$d4/Household/Household_Merged_Edit.dta"
erase "$d4/Household/Household_Merged.dta"
erase "$d4/Household/Household1.dta"
erase "$d4/Household/Livestock_sales_collapse.dta"
erase "$d4/Household/modules_merged.dta"
erase "$d4/Household/Number of Children1.dta"
erase "$d4/Household/Rooster1.dta"
*

 *********************************************
 
log close
