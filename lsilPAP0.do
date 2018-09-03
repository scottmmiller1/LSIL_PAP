clear all
set more off, perm

*log
cap log close
log using "$d1/lsilPAP0.smcl", replace


** Create co-op dataset from clean data **


******************************
** Co-op dataset

clear
use "$d3/Cooperative.dta"

drop *start* *end* *note* consent *GPS* ____version metainstanceID ___id ___parent* ___tags ___uuid ___sub*
rename role_CPSerLiv_rel_serLive_rel_se role_CPSerLiv_rel_serLive_rel

rename IDX idx

** Assign region names
destring ID1, replace
gen district = "Arghakanchhi" if ID1==51
replace district = "Arghakanchhi" if ID1== 51
replace district = "Baglung" if ID1== 45
replace district = "Banke" if ID1== 57
replace district = "Bardiya" if ID1== 58
replace district = "Chitwan" if ID1== 35
replace district = "Dang" if ID1== 56
replace district = "Dhading" if ID1== 30 
replace district = "Kaski" if ID1== 40
replace district = "Kapilbastu" if ID1== 50
replace district = "Lamjung" if ID1== 37
replace district = "Mahottari" if ID1== 18
replace district = "Morang" if ID1== 5
replace district = "Nawalparasi" if ID1== 48
replace district = "Nuwakot" if ID1== 28
replace district = "Palpa" if ID1== 47
replace district = "Parbat" if ID1== 44
replace district = "Pyuthan" if ID1== 52
replace district = "Rautahat" if ID1== 32
replace district = "Rupandehi" if ID1== 49
replace district = "Salyan" if ID1== 55
replace district = "Sarlahi" if ID1== 19
replace district = "Sindhuli" if ID1== 20
replace district = "Surkhet" if ID1== 59
replace district = "Tanahu" if ID1== 38

gen region = "Mid-Hills" if district=="Arghakanchhi" | district=="Baglung" | ///
	district=="Dhading" | district =="Kaski" | district =="Lamjung" | district=="Nuwakot" | ///
	district=="Palpa" | district =="Parbat" | district =="Pyuthan" | district =="Salyan" | ///
	district=="Tanahu" | district =="Sindhuli"
	 
replace region = "Terai" if district=="Banke" | district =="Bardiya" | district =="Kapilbastu" | ///
	district=="Mahottari" | district =="Morang" | district =="Nawalparasi" | ///
	district=="Rautahat" | district =="Rupandehi" | district=="Sarlahi" | district =="Surkhet" | ///
	district =="Chitwan" | district =="Dang"
	
** save labels and value labels in macros
	* role_GMequipmentprinterheader_mob is an invalid name
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

* Change Yes / No to binary
foreach v of varlist TRN1 TRN2 TRN3 TRN4 TRN5 TRN6 TRN6a TRN7 TRN14 TRN15 MAN1 MAN11 MAN15 MAN17 ///
		SER1 SER2 SER3 SER4 SER5 SER6 SER7 SER8 SER9 SER10 SER1* SERV2 SERV3 SERV4 SERV8 IND5 ///
		REC8 EQP1_1 EQP2_1* EQP3_1 EQP4_1 EQP5_1 EQP6_1 EQP7_1 EQP8_1 EQP9_1 EQP10_1 EQP11_1 ///
		EQP12_1 EQP13_1 EQP14_1 EQP15_1 EQP16 EQP17 EQP18 EQP19 FAL3 FAL4 PNG1 EAA1 EAA3  {
	quietly replace `v'=. if `v'==99
	quietly replace `v'=. if `v'==97
	quietly replace `v'=0 if `v'==2
	}

* rename TRN vars with Co-op indicator (have same name as HH data)
foreach v of varlist TRN* {
	rename `v' CO_`v'
	}	
	
	
** Collapse to 1-row per co-op
* strings
ds *ID* *MEM* *role* *IND* *REC* *REV* *EQP* *FAL* PNG* *EAA* *COMM* *GTT* *MAN* *SER* *GPR* CO_TRN* region district ___index, has(type string)
local Co_opstrings = "`r(varlist)'"

* numerics
ds *ID* *MEM* *role* *IND* *REC* *REV* *EQP* *FAL* PNG* *EAA* *COMM* *GTT* *MAN* *SER* *GPR* CO_TRN* region district ___index, has(type numeric)
local Co_opnumeric = "`r(varlist)'"

* collapse
collapse (mean) `Co_opnumeric' (firstnm) `Co_opstrings', by(idx)
*collapse (firstnm) `Co-opstrings', by(idx)


* re-assign labels post-collapse
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

* merge identifier
encode idx, gen(idx_n)

save "$d3/Cooperative_collapse.dta", replace


******************************
** HH dataset

* Livestock Sales Module
clear
use "$d3/Livestocksales.dta"

foreach v of var * {
	cap local vv = subinstr("`v'", "Livestock_Saleslivestock", "Livestock_Sales",.) // names too long for macros
	if _rc == 0 {
		rename `v' `vv'
		local v `vv'
	}
}
 
drop LS2 LS6 LS6_1 ___id ___uuid ___submission_time ///
		___parent_table_name ___tags ___notes LS4 
		
gen co_opsalevalue = LS9 if LS3==1 			
lab var co_opsalevalue "Total revenue, goats sold through co-op"

gen co_opgoatno = LS8 if LS3==1		
lab var co_opgoatno "Total goats sold through co-op"

destring *, replace
ds *, has(type numeric)
local numeric = "`r(varlist)'"		
recode `numeric' (99=.) (98=.) (97=.)


foreach v of varlist LS3 ///
		LS39 LS44 ///
		LS45 {
	quietly replace `v'=. if `v'==99
	quietly replace `v'=. if `v'==97
	quietly replace `v'=0 if `v'==2
}
 
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

* create # of sales variable
bysort ___parent_index: egen LS_n_sales=count(___parent_index)

collapse (firstnm) LS_n_sales (mean) LS3 *LS6* LS7 (sum) LS8 LS9 LS10 LS12 LS13 LS14 LS15 LS16 ///
		LS17 LS25 LS26 LS27 LS28 LS29 LS30 LS31 *LS32* LS33 LS34 LS35 LS36 LS37 ///
		LS38 LS39 LS40 LS41 LS42 *LS43* LS44 LS45 LS46 ///
		LS47 co_opsalevalue co_opgoatno , by(___parent_index)

foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}
		
* Top coding
g price = LS9/LS8

g n = _n

*scatter LS9 price, mlabel(n)

*br n LS8 LS9 price if n == 1035 | n == 10 | n == 11 | n == 1222 | n == 1199

su price, d
replace LS9 = r(p50)*LS8 if n == 1035 | n == 10 | n == 11 | n == 1222 | n == 1199

drop n price

su *LS8, d
replace LS8 = r(p50) if LS8 > 25 & ///
LS8 < . // Replaces outliers with median

save "$d3/Livestocksales_collapse.dta", replace


** Merge separate modules into Household

*household
clear
use"$d3/Household.dta"

decode ID1, gen(district)

replace district = "Arghakanchhi" if ID1== 51
replace district = "Baglung" if ID1== 45
replace district = "Banke" if ID1== 57
replace district = "Bardiya" if ID1== 58
replace district = "Chitwan" if ID1== 35
replace district = "Dang" if ID1== 56
replace district = "Dhading" if ID1== 30 
replace district = "Kaski" if ID1== 40
replace district = "Kapilbastu" if ID1== 50
replace district = "Lamjung" if ID1== 37
replace district = "Mahottari" if ID1== 18
replace district = "Morang" if ID1== 5
replace district = "Nawalparasi" if ID1== 48
replace district = "Nuwakot" if ID1== 28
replace district = "Palpa" if ID1== 47
replace district = "Parbat" if ID1== 44
replace district = "Pyuthan" if ID1== 52
replace district = "Rautahat" if ID1== 32
replace district = "Rupandehi" if ID1== 49
replace district = "Salyan" if ID1== 55
replace district = "Sarlahi" if ID1== 19
replace district = "Sindhuli" if ID1== 20
replace district = "Surkhet" if ID1== 59
replace district = "Tanahu" if ID1== 38

 
gen region = "Mid-Hills" if district=="Arghakanchhi" | district=="Baglung" | ///
	district=="Dhading" | district =="Kaski" | district =="Lamjung" | district=="Nuwakot" | ///
	district=="Palpa" | district =="Parbat" | district =="Pyuthan" | district =="Salyan" | ///
	district=="Tanahu" | district =="Sindhuli"
	 
replace region = "Terai" if district=="Banke" | district =="Bardiya" | district =="Kapilbastu" | ///
	district=="Mahottari" | district =="Morang" | district =="Nawalparasi" | ///
	district=="Rautahat" | district =="Rupandehi" | district=="Sarlahi" | district =="Surkhet" | ///
	district =="Chitwan" | district =="Dang"

	
* rename TRN vars with HH indicator (have same name as Co-op data)
foreach v of varlist TRN* {
	rename `v' HH_`v'
	}		
	
	
save "$d3/Household_edit.dta", replace


* -----------------------------------------------
* ---- create merge variable "___index"
use "$d3/Borrowing.dta"
rename A__parent_index ___index
save "$d3/Borrowing_edit.dta", replace

use "$d3/Children.dta"
rename ___index A___index
rename ___parent_index ___index
save "$d3/Children_edit.dta", replace

use "$d3/Roster.dta"
rename ___index A___index
rename ___parent_index ___index
save "$d3/Roster_edit.dta", replace

use "$d3/Livestocksales_collapse.dta"
*rename ___index A___index
rename ___parent_index ___index
save "$d3/Livestocksales_collapse_edit.dta", replace

* -----------------------------------------------



*create merged dataset 'modules_merged'
*Livestock Sales - Borrowing
use "$d3/Household_edit.dta", clear
merge m:m ___index using "$d3/Borrowing_edit.dta", force
rename _merge merge1
save "$d3/modules_merged.dta", replace

*Number of Children
use "$d3/modules_merged.dta", clear
merge m:m ___index using "$d3/Children_edit.dta", force
rename _merge merge2
save "$d3/modules_merged.dta", replace 

*Roster
use "$d3/modules_merged.dta", clear
merge m:m ___index using "$d3/Roster_edit.dta", force
rename _merge merge3
save "$d3/modules_merged.dta", replace  

*merge modules_merged into Household
use "$d3/modules_merged.dta", clear
merge m:m ___index using "$d3/Livestocksales_collapse_edit.dta", force
save "$d3/Household_Merged.dta", replace
 
 *______________________________________________________________________________ 
 
 
 
 ** Prepare Household_Merged to be collapsed by Co-op **
clear
use "$d3/Household_Merged.dta"
 
*drop irrelevant vars
*section timing, notes, section headers, other (specificy), etc.
drop start end *Note* HH_IDstartHHID HH_IDendHHID end_rooster Number_children_count ///
	Land_and_homestart_land Land_and_homeLand_and_home_note Land_and_homeEnd_land ///
	Co_opstart_coop MEM4_1 MEM9_1 ///
	Co_opMembershipMEM10MEM10_Header MEM13_1 Co_opServiceService_note MGT1_1 ///
	COM1_1 COM2_1 COM6_1 ///
	COM11_1 GTT4_1 Co_opGoat_transactionsGTT4_1 Co_opFollow_up_transparency_ques ///
	Savingsstart_savings SavingsSavings_Note ///
	SV2_1 Savingsend_savings Borrowingstart_borrowing Borrowingend_borrowing ///
	Food_Consumptionstart_food Food_ConsumptionGrainsGrains_N Food_ConsumptionPulsesPulses_n ///
	Food_ConsumptionMeat_fish_and_eg Food_ConsumptionDairy_productsDa Food_ConsumptionFruitsFruits_not ///
	Food_ConsumptionVegetablesVegeta Food_ConsumptionSugar_and_or_swe Food_ConsumptionOilOil_note ///
	time_food start_stockR Live_rel_emp_stockR ///
	Live_Entsta_liveE Live_Ent_liveE  ///
	Goat_Prod_Sys_goat GP2_1 GP4_1 ///
	GP8_1 Goat_Pro_Sys_goat Live_Sale_sales Live_Sale_sale ///
	PQ1_1 PQ1 GPS ///
	____version metainstanceID ___uuid ___submission_time ___tags ___notes ///
	merge1 merge2 Rosterstart_Rooster RosterRoster_Note merge3 _merge ///
	LSE10_2 LSE10_3 LSE10_1 SV8_1 ///
	LSE1 GP22_1 GP22_2 HHR1 HHR2 ///
	GP22_1 GP22_2


*drop multi-choice vars with individual dummys already created
drop COM1 COM2 COM6 COM7 ///
	GTT4 SV2 LSE22 ///
	GP4 GP12 GP18 GP22 ///
	GP25 LS48 PQ2 BR5 ///
	GP3 BR56 HHR10_1

 
 * Destring 1-2 dummys __ format to binary
	* 2 -> 0  1 -> 1 ______ Most are Y/N __> Y=1 N=0
	
 foreach v of varlist HSE6 HSE7 HSE10 ///
		MEM3 MEM6 MEM8 MEM12 ///
		MEM14 MEM16 SER1 SER2 ///
		SER3 SER4 SER6 SER7 ///
		SER8 SER9 SER10 SER11 ///
		SER12 SER13 SER14 SER15 ///
		SER16 SER17 SER18 SER19 MGT5 COM5 HH_TRN1 ///
		HH_TRN2 HH_TRN3 HH_TRN4 HH_TRN5 ///
		HH_TRN6 HH_TRN7 HH_TRN8 ///
		SV3 SV4 SV7 BR1 FC1A FC1B ///
		FC1E FC1F ///
		FC1H GP7 ///
		GP13 GP16 GP19 ///
		GP21 {
	quietly replace `v'=. if `v'==99
	quietly replace `v'=. if `v'==97
	quietly replace `v'=0 if `v'==2
}

foreach v of varlist HHR3 HHR5 HHR11 HHR13 HHR14 ///
		HHR15 HHR17 HHR18 HHR19 {
	quietly destring `v', replace
	quietly replace `v'=. if `v'==99
	quietly replace `v'=. if `v'==97
	quietly replace `v'=0 if `v'==2
	
}

quietly {
	destring *COM1* *COM2* *COM6*, replace 
	destring *COM7* *GTT* *SV2*, replace 
	destring *EMP* *LSE*, replace 
	destring *BR5* N0_childcal *HHR8* HHR12 *LS6*, replace 
	destring *GP* Roster_count Live_Sale_count, replace
}

save "$d3/Household_Merged_Edit.dta", replace
 
 *______________________________________________________________________________ 
 
** Collapse HH into 1 row per cooperative
 
use "$d3/Household_Merged_Edit.dta", clear

rename IDX idx
rename Co_opTransparencyTransparency_no Co_opTransparencyTransparency
rename Live_EntexofemaleExotic_Female Live_EntexofemaleExotic_F
rename Live_EntcrofemaleCross_Breed_F Live_EntcrofemaleCross
rename Live_EntCro_breed_female_goats Live_EntCro_breed_female
drop Co_opTransparencyTransparency

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

ds *HHR* *ID* *LND* *HSE* *MEM* *SER* *MGT* *COM* *GTT* *TRN* *SV* *BR* *FC* *EMP* *LS* *GP* region district, has(type string)
local HHstrings = "`r(varlist)'"
ds *HHR* *ID* *LND* *HSE* *MEM* *SER* *MGT* *COM* *GTT* *TRN* *SV* *BR* *FC* *EMP* *LS* *GP* region district, has(type numeric)
local HHnumeric = "`r(varlist)'"

collapse (firstnm) `HHstrings' (mean) `HHnumeric' co_opsalevalue co_opgoatno, by(idx)

* re-assign labels post-collapse
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

drop if idx == "" | idx == "2"

save "$d3/Household_Collapsed.dta", replace


  *------------------------------------------------------------------------------ 
 
 ** Merge Cooperative_collapse into Household_Collapsed

 clear 
 use "$d3/Household_Collapsed.dta"  
 
sort idx
drop if idx =="Karmath SEWC 2"
encode idx, gen(idx_n)
 
cd "$d3/"
merge 1:1 idx_n using "$d3/Cooperative_collapse.dta", force
drop *merge*

* Create per member measures of revenue and cost
destring REC7, replace
replace REC7 = REC7/1000
lab var REC7 "Total co-op cost, 1000 Rs"
destring REV4, replace
replace REV4 = REV4/1000
lab var REV4 "Total co-op revenue, 1000 Rs"

gen totrev_member = REV4 / MAN3
gen totcost_mem = REC7 / MAN3
gen goatssold_mem = REC1 / MAN3

lab var totrev_member "Co-op revenue (all sources) per member"
lab var totcost_mem "Co-op cost (all sources) per member"
lab var goatssold_mem "Co-op goats sold per member"

save "$d3/Baseline_Merged.dta", replace

 
 *********************************************












