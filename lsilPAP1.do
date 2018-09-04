clear all
set more off, perm

*log
cap log close
log using "$d1/lsilPAP1.smcl", replace

use "$d3/Baseline_Merged.dta", clear

* drop all variables associated with original randomization
*`drop treat _merge n random random2 bin sub_bin strata


/* gen treat = 0
replace treat = 1 if HH_IDIDX == "Lekhbesi SEWC 1" // Pilot co-op
*/

drop if idx == "Lekhbesi SEWC 1" // Pilot co-op

* true treatment status: seed 3581 *
set seed 62184  // random seed to generate different treatment assignment

/*
* Region
tab region
*# of members
MAN3
* Co-op Revenue
REV4
* HH Goat Revenue
LS9
*/

* Region - HH Goat Rev
gen bin=. 
bysort region LS9 : gen random = uniform()
sort region LS9 random
bysort region: g n = _n 

count if region=="Terai"
replace bin=1 if n <= (r(N)/3) & region=="Terai"
replace bin=2 if n <= r(N)*(2/3) & n > (r(N)/3) & region=="Terai"
replace bin=3 if n <= r(N) & n > r(N)*(2/3) & region=="Terai"

count if region=="Mid-Hills"
replace bin=4 if n <= (r(N)/3) & region=="Mid-Hills"
replace bin=5 if n <= r(N)*(2/3) & n > (r(N)/3) & region=="Mid-Hills"
replace bin=6 if n <= r(N) & n > r(N)*(2/3) & region=="Mid-Hills"

tab region bin

drop n random

*  # of Members
sum MAN3, d
return list

gen sub_bin=.
bysort bin MAN3 : gen random = uniform()
sort bin MAN3 random
bysort bin: g n = _n 

forvalues i=1/6 { 
	count if bin==`i'
	replace sub_bin= `i'1 if n <= r(N)*(1/2) & bin==`i'
	replace sub_bin= `i'2 if n > r(N)*(1/2) & bin==`i'
}

tab sub_bin region
drop random  n

* Co-op rev
gen sub_sub_bin=.
bysort sub_bin REV4 : gen random = uniform()
sort sub_bin REV4 random
bysort sub_bin: g n = _n 

levelsof sub_bin, local(levels)
	foreach i in `levels' { 

	count if sub_bin==`i'
	replace sub_sub_bin= `i'1 if n <= r(N)*(1/2) & sub_bin==`i'
	replace sub_sub_bin= `i'2 if n > r(N)*(1/2) & sub_bin==`i'
}

tab sub_sub_bin region

drop random n

rename sub_sub_bin strata 

 * Randomization
 
bysort strata: gen random=uniform() // used to assign to treatment and control
sort strata random

bysort strata: gen n=_n
 
sum n if strata==51, d
return list
 
bysort strata: gen random2=uniform() // used to randomly assign odd-numbered strata to have 3 treated or 3 control 
 
levelsof strata, local(stratums) 

gen r_treat = 0
 
foreach i in `stratums' {
	count if strata==`i' 
	if r(N)==4 | r(N)==6 {
		sum n if strata==`i', d
		replace r_treat=1 if n <= r(p50) & strata==`i'
	}
	else {
		su random2 if strata == `i'
		scalar mu = r(mean) // local macros don't handle decimals well
		if mu < 0.5 {
			replace r_treat=1 if n <= 3 & strata==`i'
		}
		if mu >= 0.5 {
			replace r_treat=1 if n <= 2 & strata==`i'
		}		
	}

}

tab strata r_treat

bysort region: tab strata r_treat

save "$d3/r_Baseline_Merged_Str.dta", replace
 
