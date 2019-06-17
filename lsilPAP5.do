
/*******************************************************************************
lsilPAP5.d0		
					
- Calculates MDEs for each indicator
	
*******************************************************************************/


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
gl hh_comm bCOM3 index_dTRN

local listsize : list sizeof global(hh_comm)
tokenize $hh_comm

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


* Strata table
frmttable using MDE_1.doc, statmat(A) sdec(4) title("Communication") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("HH received sale info"\"Transparency index") replace


* Goat Sales

** HH vars
gl hh_goatsales co_opgoatno_w LS8_w

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
rtitle("Goats Sold through Cooperative"\"Total Goats Sold") ///
note("Currency measured in USD") addtable replace



* Goat Prices

** HH vars
gl hh_goatprice rev_goat_w rev_co_opgoat_w

local listsize : list sizeof global(hh_goatprice)
tokenize $hh_goatprice

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
frmttable using MDE_1.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Goat Price") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Revenue per Goat"\"Revenue per Cooperative Goat") ///
note("Currency measured in USD") addtable replace




* Net Goat Income

** HH vars
gl hh_income rev_goat_w LS8_w net_goat_income_w

local listsize : list sizeof global(hh_income)
tokenize $hh_income

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
frmttable using MDE_1.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Goat Income") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Revenue per Goat"\"Goats Sold"\"Net Goat Income") ///
note("Currency measured in USD") addtable replace


** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"


* Planning and Goals

** Co-op vars
gl co_PNG PNG2 PNG3_w expected_rev_w

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_PNG)
tokenize $co_PNG

forv i = 1/`listsize' {

	reg ``i'' r_treat i.strata, robust
	
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
rtitle("Planning Time Horizon"\"Expected Goats Sold"\"Expected Rev.") addtable replace



