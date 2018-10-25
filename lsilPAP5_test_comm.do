
clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5_test_comm.smcl", replace

cd "$d2"

** Minimum Detectable Effects **


** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"
encode idx, gen(idx_n)

* Communication

*** Strata dummies - No interaction
local varlist comm1 comm2 contact COM3 COM8 index_CO_comm HHcontact
foreach v in `varlist' {
	
	reg `v' r_treat i.strata
	
	quietly { 
		ereturn list
		scalar t_a = invttail(`e(df_r)',0.025) // alpha t-value
		scalar t_b = invttail(`e(df_r)',0.2) // beta t-value
 
		scalar mde_`v' = (t_a + t_b)*_se[r_treat]
		} 

	* Calculate MDE as % of mean & # of standard deviations
	quietly {	
		sum `v'
		scalar mean_`v' = mde_`v' / r(mean) // % of treatment mean
		scalar sd_`v' = mde_`v' / r(sd)  // # of treatment sd's
		}
} 
quietly {
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_CO_comm, ., sd_index_CO_comm\ ///
			mde_HHcontact, mean_HHcontact, sd_HHcontact)
	}

* Strata table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("Co-op Level Communication: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Co-op Contact"\"HH info sales"\"HH info activities"\"co-op level index"\"Total HH Contact") replace



************************
* factors that limit comminication

** Strata - No interaction
* no control
reg contact r_treat i.strata

quietly scalar r2_n = e(r2)
* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	destring COMM8`v', replace
	reg contact COMM8`v' r_treat i.strata, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}
* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat i.strata, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Strata - No interaction") addtable replace



** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"
encode idx, gen(idx_n)

* Communication

*** Strata dummies - No interaction
local varlist COM3 COM8 index_HH_comm HHcontact
foreach v in `varlist' {
	
	reg `v' r_treat i.strata, cluster(idx_n)
	
	quietly { 
		ereturn list
		scalar t_a = invttail(`e(df_r)',0.025) // alpha t-value
		scalar t_b = invttail(`e(df_r)',0.2) // beta t-value
 
		scalar mde_`v' = (t_a + t_b)*_se[r_treat]
		} 

	* Calculate MDE as % of mean & # of standard deviations
	quietly {	
		sum `v'
		scalar mean_`v' = mde_`v' / r(mean) // % of treatment mean
		scalar sd_`v' = mde_`v' / r(sd)  // # of treatment sd's
		}
} 

quietly {
	matrix A = (mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_HH_comm, ., sd_index_HH_comm\ ///
			mde_HHcontact, mean_HHcontact, sd_HHcontact)
	}

* Strata table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("HH Level Communication: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("HH info sales"\"HH info activities"\"HH level index"\"Total HH Contact") addtable replace








