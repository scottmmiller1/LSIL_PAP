
/*******************************************************************************
lsilPAP_rand0.do		
					
- Runs a random permutation of treatment status to be used for 
	minimum detectable effect calculations
	
*******************************************************************************/


cap log close
clear
cd "$d1"

log using "$d1/lsilPAP_rand2.smcl", replace

use "$d4/Merged/Baseline_Merged_Str.dta", clear


* drop original randomization variables
drop bin sub_bin strata random n random2


* true treatment status: seed 3581 * random seed = 62184 
set seed 62184  // random seed to generate different treatment assignment


* Region - HH Goat Rev
gen bin=. 
bysort region Livestock_SalesLS9 : gen random = uniform()
sort region Livestock_SalesLS9 random
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
sum role_CPMgt_and_membershi1, d
return list

gen sub_bin=.
bysort bin role_CPMgt_and_membershi1 : gen random = uniform()
sort bin role_CPMgt_and_membershi1 random
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
bysort sub_bin role_GMrevenuandcostREV4 : gen random = uniform()
sort sub_bin role_GMrevenuandcostREV4 random
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
save "$d4/Merged/r_Baseline_Merged_Str.dta", replace
 
