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

* Merge and save dataset
merge m:m idx using "r_CO_Merged_PAP.dta", force

save r_HHmerged_PAP.dta, replace






