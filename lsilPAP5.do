clear all
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5.smcl", replace

cd "$d2"

** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"
encode idx, gen(idx_n)


* Communication

*** Strata dummies - No interaction
local varlist COM3 COM8 index_HH_comm
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
			mde_index_HH_comm, ., sd_index_HH_comm)
	}

* Strata table
frmttable using MDE_1.doc, statmat(A) sdec(4) title("Communication") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("HH info sales"\"HH info activities"\"HH level index") replace


* Goat Sales

** HH vars
gl hh_goatsales LS8 LS9_w co_opgoatno co_opsalevalue ///
				net_goat_income index_HH_goatsales ///
				visits_sale time_passed transp_cost index_salecost ///



** HH vars
local listsize : list sizeof global(hh_goatsales)
tokenize $hh_goatsales

forv i = 1/`listsize' {

	reg ``i'' r_treat i.str, cluster(idx)
	
	quietly {
		ereturn list
		scalar t_a = invttail(`e(df_r)',0.025) // alpha t-value
		scalar t_b = invttail(`e(df_r)',0.2) // beta t-value
		scalar mde_``i'' = (t_a + t_b)*_se[r_treat]
		
	* Calculate MDE as % of mean & # of standard deviations
		sum ``i''
		scalar mean_``i'' = mde_``i'' / r(mean) // % of treatment mean
		scalar sd_``i'' = mde_``i'' / r(sd)  // # of treatment sd's

	* matrix for table
		matrix mat_`i' = (mde_``i'',mean_``i'',sd_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using MDE_1.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Goat Sales") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"Net Goat Income"\"HH Goat Sales Index"\"Trader Visits per Sale"\"Time Passed"\"Transportation Costs"\"Sale Costs Index") ///
note("Currency measured in USD") addtable replace


* Transparency
** HH vars
gl hh_trn_d index_dTRN

local listsize : list sizeof global(hh_trn_d)
tokenize $hh_trn_d

forv i = 1/`listsize' {

	reg ``i'' r_treat i.strata, cluster(idx)
	
	quietly {
		ereturn list
		scalar t_a = invttail(`e(df_r)',0.025) // alpha t-value
		scalar t_b = invttail(`e(df_r)',0.2) // beta t-value
		scalar mde_``i'' = (t_a + t_b)*_se[r_treat]
		
	* Calculate MDE as % of mean & # of standard deviations
		sum ``i''
		scalar mean_``i'' = mde_``i'' / r(mean) // % of treatment mean
		scalar sd_``i'' = mde_``i'' / r(sd)  // # of treatment sd's

	* matrix for table
		matrix mat_`i' = (mde_``i'',mean_``i'',sd_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Strata table
frmttable using MDE_1.doc, statmat(A) sdec(4) title("Transparency") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Discrepancy Index") addtable replace



* IHS transformed variables
** HH vars
gl hh_IHS LS9_w_ln co_opsalevalue_ln net_goat_income_ln

local listsize : list sizeof global(hh_IHS)
tokenize $hh_IHS

forv i = 1/`listsize' {

	reg ``i'' r_treat i.strata, cluster(idx)
	
	quietly {
		ereturn list
		scalar t_a = invttail(`e(df_r)',0.025) // alpha t-value
		scalar t_b = invttail(`e(df_r)',0.2) // beta t-value
		scalar mde_``i'' = (t_a + t_b)*_se[r_treat]
		
	* Calculate MDE as % of mean & # of standard deviations
		sum ``i''
		scalar mean_``i'' = mde_``i'' / r(mean) // % of treatment mean
		scalar sd_``i'' = mde_``i'' / r(sd)  // # of treatment sd's

	* matrix for table
		matrix mat_`i' = (mde_``i'',mean_``i'',sd_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Strata table
frmttable using MDE_1.doc, statmat(A) sdec(4) title("HH - IHS Variables") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Ln(Goat Rev.)"\"Ln(Rev. through Co-op)"\"Ln(Net Goat Income)") addtable replace



** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"

* generate strata variable that excludes 4th strata (due to data error)


* Planning and Goals

** Co-op vars
gl co_PNG PNG1 PNG2 PNG3 expected_rev index_PNG

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_PNG)
tokenize $co_PNG

forv i = 1/`listsize' {

	reg ``i'' r_treat i.strata
	
	quietly {
		ereturn list
		scalar t_a = invttail(`e(df_r)',0.025) // alpha t-value
		scalar t_b = invttail(`e(df_r)',0.2) // beta t-value
		scalar mde_``i'' = (t_a + t_b)*_se[r_treat]
		
	* Calculate MDE as % of mean & # of standard deviations
		sum ``i''
		scalar mean_``i'' = mde_``i'' / r(mean) // % of treatment mean
		scalar sd_``i'' = mde_``i'' / r(sd)  // # of treatment sd's

	* matrix for table
		matrix mat_`i' = (mde_``i'',mean_``i'',sd_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using MDE_1.doc, statmat(A) sdec(4) title("Planning and Goals") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Business Plan"\"Planning Time Horizon"\"Expected Goats Sold"\"Expected Rev."\"PNG Index") addtable replace


* IHS transformed variables
** CO vars
gl co_IHS PNG3_ln expected_rev_ln

local listsize : list sizeof global(co_IHS)
tokenize $co_IHS

forv i = 1/`listsize' {

	reg ``i'' r_treat i.strata, cluster(idx)
	
	quietly {
		ereturn list
		scalar t_a = invttail(`e(df_r)',0.025) // alpha t-value
		scalar t_b = invttail(`e(df_r)',0.2) // beta t-value
		scalar mde_``i'' = (t_a + t_b)*_se[r_treat]
		
	* Calculate MDE as % of mean & # of standard deviations
		sum ``i''
		scalar mean_``i'' = mde_``i'' / r(mean) // % of treatment mean
		scalar sd_``i'' = mde_``i'' / r(sd)  // # of treatment sd's

	* matrix for table
		matrix mat_`i' = (mde_``i'',mean_``i'',sd_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Strata table
frmttable using MDE_1.doc, statmat(A) sdec(4) title("CO - IHS Variables") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Ln(Expected Goats Sold)"\"Ln(Expected Rev.)") addtable replace




