clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5_test_finance.smcl", replace

cd "$d2"

** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"

* Finances

** Co-op vars
gl co_finance revenue rev_member costs cost_member ///
	assets assets_member liabilities liab_member goatrev goatrev_member ///
	net_rev net_rev_member net_finances net_finances_member
	

*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_finance)
tokenize $co_finance

forv i = 1/`listsize' {

	reg ``i'' r_treat i.strata, cluster(idx_n)
	
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
frmttable using MDE_finance.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Co-op Level - Finances: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Revenue"\"Rev. per Member"\"Costs"\"Costs per Mem."\"Assets"\"Assets per Mem."\"Liabilities"\"Liabilities per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Net Revenue"\"Net Rev. per Mem."\"Net Finances"\"Net Fin. per Mem.") replace


*** Strata dummies - Interaction
** Co-op vars
local listsize : list sizeof global(co_finance)
tokenize $co_finance

forv i = 1/`listsize' {

	reg ``i'' r_treat i.strata r_treat#i.strata, cluster(idx_n)
	
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
frmttable using MDE_finance.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Co-op Level - Finances: Strata - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Revenue"\"Rev. per Member"\"Costs"\"Costs per Mem."\"Assets"\"Assets per Mem."\"Liabilities"\"Liabilities per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Net Revenue"\"Net Rev. per Mem."\"Net Finances"\"Net Fin. per Mem.") addtable replace


*** Variables - No interaction
** Co-op vars
local listsize : list sizeof global(co_finance)
tokenize $co_finance

forv i = 1/`listsize' {

	reg ``i'' r_treat n_region MAN3 REC2 ///
	LS9, cluster(idx_n)
	
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
frmttable using MDE_finance.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Co-op Level - Finances: Variables - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Revenue"\"Rev. per Member"\"Costs"\"Costs per Mem."\"Assets"\"Assets per Mem."\"Liabilities"\"Liabilities per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Net Revenue"\"Net Rev. per Mem."\"Net Finances"\"Net Fin. per Mem.") addtable replace


*** Variables - Interaction
** Co-op vars
local listsize : list sizeof global(co_finance)
tokenize $co_finance

forv i = 1/`listsize' {

	reg ``i'' r_treat n_region MAN3 REC2 ///
	LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
	c.LS9#r_treat, cluster(idx_n)
	
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
frmttable using MDE_finance.doc, statmat(A) sdec(4) coljust(l;c;l;l) title("Co-op Level - Finances: Variables - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Revenue"\"Rev. per Member"\"Costs"\"Costs per Mem."\"Assets"\"Assets per Mem."\"Liabilities"\"Liabilities per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Net Revenue"\"Net Rev. per Mem."\"Net Finances"\"Net Fin. per Mem.") addtable replace

















