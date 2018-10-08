clear all
set more off, perm

*log
cap log close
log using "$d1/lsilPAP2.smcl", replace

** create merged dataset at HH level **
cd "$d3"


* co-op data with treatment status
clear
use "r_Baseline_Merged_Str.dta"
		
save r_CO_Merged_PAP.dta, replace


** Household Dataset **
clear
use "$d3/Household_Merged_Edit.dta"

rename IDX idx

drop Co_opTransparencyTransparency_no Live_EntexofemaleExotic_Female Live_EntcrofemaleCross_Breed_Fem
rename Live_EntCro_breed_female_goats Live_EntCro_breed_female

* Collapse to one row per HH.
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

ds *HHR* *ID* *LND* *HSE* *MEM* *SER* *MGT* *COM* *GTT* *TRN* *SV* *BR* *FC* *EMP* *LS* *GP* region district idx, has(type string)
local HHstrings = "`r(varlist)'"
ds *HHR* *ID* *LND* *HSE* *MEM* *SER* *MGT* *COM* *GTT* *TRN* *SV* *BR* *FC* *EMP* *LS* *GP* region district idx, has(type numeric)
local HHnumeric = "`r(varlist)'"

collapse (firstnm) `HHstrings' (mean) `HHnumeric' co_opsalevalue co_opgoatno, by(___index)

* re-assign labels post-collapse
foreach v of var * {
	label var `v' "`l`v''"
	cap label val `v' "`ll`v''"
}

* Merge and save dataset
merge m:m idx using "r_CO_Merged_PAP.dta", force

save r_HH_Merged_PAP.dta, replace






