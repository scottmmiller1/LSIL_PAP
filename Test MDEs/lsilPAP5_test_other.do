clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5_test_other.smcl", replace

cd "$d2"

** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"


* Descision-Making

** Co-op vars
gl co_decision MAN18a MAN18b ///
MAN18c MAN18d MAN18e index_decision

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_decision)
tokenize $co_decision

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
frmttable using MDE_other.doc, statmat(A) sdec(4) title("Co-op Level - Decision-Making") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Loans"\"Savings"\"Traders"\"Buying Eq."\"Gen. Assembly"\"Decision Index") replace



* Evaluation & Assessment

** Co-op vars
gl co_EAA EAA1 EAA3 avg_EAA

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_EAA)
tokenize $co_EAA

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
frmttable using MDE_other.doc, statmat(A) sdec(4) title("Co-op Level - Evaluation & Assessment") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("External Evals"\"Makes Available"\"EAA Avg.") addtable replace


* Management Quality

** Co-op vars
gl co_MNG IND2 IND3 IND5 MEM2_1

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_MNG)
tokenize $co_MNG

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
frmttable using MDE_other.doc, statmat(A) sdec(4) title("Co-op Level - Management Quality") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Permanent Role"\"Receives Salary"\"Training"\"Years with Co-op") addtable replace



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
frmttable using MDE_other.doc, statmat(A) sdec(4) title("Co-op Level - Planning and Goals") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Business Plan"\"Planning Time Horizon"\"Expected Goats Sold"\"Expected Rev."\"PNG Index") addtable replace


