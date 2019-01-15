clear all
set more off, perm

*log
cap log close
log using "$d1/lsilPAP1.smcl", replace


/*******************************************************************************
lsilPAP1.d0		
					
- Merge true and randomized treatment status from lsilPAP_rand1/2
	into clean datasets to be used for power calculations
	
*******************************************************************************/

** Load merged baseline dataset
use "$d3/Baseline_Merged.dta", clear


** Add true and randomized treatment status to this dataset
* Merge treatment status from original randomization

* Original dataset
clear
use "$d4/Merged/r_Baseline_Merged_Str.dta"
recast str99 idx // idx is str99 in Baseline_Merged

keep idx treat r_treat

save "$d3/treat.dta", replace

merge 1:1 idx using "$d3/Baseline_Merged.dta"
drop if _merge == 2 // co-ops dropped in original treatment status
drop if district == "Banke"

save "$d3/r_Baseline_Merged_Str.dta", replace

 
