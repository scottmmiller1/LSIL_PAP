clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5_test_goatsales.smcl", replace

cd "$d2"

** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"

* Goat Sales

** Co-op vars
gl co_goatsales goats_sold goats_sold_member goatrev goatrev_member goatrev_sold ///
				col_points index_CO_goatsales

** HH vars
gl hh_goatsales LS8 LS9 co_opgoatno co_opsalevalue ///
				co_opshare visits_sale time_passed transp_cost index_salecost
	

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_goatsales)
tokenize $co_goatsales

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

* Table
frmttable using MDE_goatsales.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Co-op Level - Co-op Goat Sales: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Goats Sold"\"Goats Sold per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Rev. per Goat Sold"\"Collection Points"\"CO Goat Sales Index") replace


** HH vars
local listsize : list sizeof global(hh_goatsales)
tokenize $hh_goatsales

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

* Table
frmttable using MDE_goatsales.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Co-op Level - HH Goat Sales: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"% Sold through Co-op"\"Trader Visits per Sale"\"Time Passed"\"Transportation Costs"\"Sale Costs Index") addtable replace



** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"

* Goat Sales

** Co-op vars
gl co_goatsales goats_sold goats_sold_member goatrev goatrev_member goatrev_sold ///
				col_points index_CO_goatsales

** HH vars
gl hh_goatsales LS8 LS9 co_opgoatno co_opsalevalue ///
				co_opshare visits_sale LS41 LS42 index_salecost
	

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_goatsales)
tokenize $co_goatsales

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

* Table
frmttable using MDE_goatsales.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("HH Level - Co-op Goat Sales: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Goats Sold"\"Goats Sold per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Rev. per Goat Sold"\"Collection Points"\"CO Goat Sales Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_goatsales)
tokenize $hh_goatsales

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

* Table
frmttable using MDE_goatsales.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("HH Level - HH Goat Sales: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"% Sold through Co-op"\"Trader Visits per Sale"\"Time Passed"\"Transportation Costs"\"Sale Costs Index") addtable replace

