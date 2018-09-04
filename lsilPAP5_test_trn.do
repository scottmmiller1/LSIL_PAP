clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5_test_trn.smcl", replace

cd "$d2"

** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"

* Transparency

** Co-op vars
gl co_trn CO_TRN1 CO_TRN2 ///
	CO_TRN3 CO_TRN4 CO_TRN5 ///
	CO_TRN6 CO_TRN7 index_CO_TRN
	
** HH vars
gl hh_trn HH_TRN1 HH_TRN2 ///
	HH_TRN3 HH_TRN4 HH_TRN5 ///
	HH_TRN6 HH_TRN7 index_HH_TRN index_dTRN avg_dTRN


*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - Co-op Transparency: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index")


** HH vars
local listsize : list sizeof global(hh_trn)
tokenize $hh_trn

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

* Strata table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - HH Awareness: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace


*** Strata dummies - Interaction
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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

* Strata table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - Co-op Transparency: Strata - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_trn)
tokenize $hh_trn

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

* Strata table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - HH Awareness: Strata - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace


*** Variables - No interaction	
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - Co-op Transparency: Variables - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_trn)
tokenize $hh_trn

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - HH Awareness: Variables - No interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace


*** Variables - Interaction	
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - Co-op Transparency: Variables - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_trn)
tokenize $hh_trn

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("Co-op Level - HH Awareness: Variables - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace




** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"

* Transparency

** HH vars
gl hh_trn_d HH_TRN1 HH_TRN2 ///
	HH_TRN3 HH_TRN4 HH_TRN5 ///
	HH_TRN6 HH_TRN7 index_HH_TRN index_dTRN avg_dTRN


*** Strata dummies - No interaction
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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

* Strata table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - Co-op Transparency: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_trn_d)
tokenize $hh_trn_d

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

* Strata table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - HH Awareness: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace


*** Strata dummies - Interaction
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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

* Strata table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - Co-op Transparency: Strata - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_trn_d)
tokenize $hh_trn_d

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

* Strata table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - HH Awareness: Strata - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace


*** Variables - No interaction	
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - Co-op Transparency: Variables - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_trn_d)
tokenize $hh_trn_d

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - HH Awareness: Variables - No interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace


*** Variables - Interaction	
** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - Co-op Transparency: Variables - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace


** HH vars
local listsize : list sizeof global(hh_trn_d)
tokenize $hh_trn_d

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

* Variables table
frmttable using MDE_trn.doc, statmat(A) sdec(4) title("HH Level - HH Awareness: Variables - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace

