
/*******************************************************************************
lsilPAP6.d0		
					
- Generates summary statistic tables
	
*******************************************************************************/


clear
set more off, perm
cd "$d2"


** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"


** Co-op indicators **

gl co_summ MAN3 revenue costs net_rev rev_member net_rev_member goatrev ///
		PNG1 PNG2 PNG3 expected_rev index_PNG

local listsize : list sizeof global(co_summ)
tokenize $co_summ

forv i = 1/`listsize' {
		
	quietly {
		sum ``i''
		return list
		scalar N_``i'' = r(N) // N
		scalar mean_``i'' = r(mean) // mean
		scalar sd_``i'' = r(sd)  // sd
		scalar min_``i'' = r(min)  // sd
		scalar max_``i'' = r(max)  // sd
		
	* matrix for table
		matrix mat_`i' = (N_``i'',mean_``i'',sd_``i'',min_``i'',max_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using CO_summary.tex, tex statmat(A) sdec(2) coljust(l;c;l;l) title("Cooperative Indicators - Summmary Statistics") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("\# of Members"\"Revenue (USD)"\"Costs (USD)"\"Net Revenue (USD)"\"Revenue per Member (USD)"\"Net Revenue per Member (USD)"\"Goat Revenue"\"Co-op has a Business Plan"\"Planning Time Horizon (Years)"\"Expected Goats Sold"\"Expected Revenue (USD)"\"Planning \& Goals Summary Index")replace
 
 
 
* ------------------------------------------- 
 
 
** finance **
gl co_finance revenue rev_member costs cost_member ///
	assets assets_member liabilities liab_member goatrev goatrev_member ///
	net_rev net_rev_member net_finances net_finances_member
	
** Co-op vars
local listsize : list sizeof global(co_finance)
tokenize $co_finance

forv i = 1/`listsize' {
		
	quietly {
		sum ``i''
		return list
		scalar N_``i'' = r(N) // N
		scalar mean_``i'' = r(mean) // mean
		scalar sd_``i'' = r(sd)  // sd
		scalar min_``i'' = r(min)  // sd
		scalar max_``i'' = r(max)  // sd
		
	* matrix for table
		matrix mat_`i' = (N_``i'',mean_``i'',sd_``i'',min_``i'',max_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("Co-op Level - Finances: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Revenue"\"Rev. per Member"\"Costs"\"Costs per Mem."\"Assets"\"Assets per Mem."\"Liabilities"\"Liabilities per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Net Revenue"\"Net Rev. per Mem."\"Net Finances"\"Net Fin. per Mem.") ///
note("Currency measured in USD") replace
	
	
* ------------------------------------------- 


** goat sales **

** Co-op vars
gl co_goatsales goats_sold goatrev 
	
** Co-op vars
local listsize : list sizeof global(co_goatsales)
tokenize $co_goatsales

forv i = 1/`listsize' {
		
	quietly {
		sum ``i''
		return list
		scalar N_``i'' = r(N) // N
		scalar mean_``i'' = r(mean) // mean
		scalar sd_``i'' = r(sd)  // sd
		scalar min_``i'' = r(min)  // sd
		scalar max_``i'' = r(max)  // sd
		
	* matrix for table
		matrix mat_`i' = (N_``i'',mean_``i'',sd_``i'',min_``i'',max_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("Co-op Level - Co-op Goat Sales: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Goats Sold"\"Goat Revenue") ///
note("Currency measured in USD") addtable replace




** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"


** HH indicators **

gl hh_summ COM3 COM8 index_HHcomm ///
				LS8 LS9_w co_opgoatno co_opsalevalue ///
				net_goat_income index_HH_goatsales ///
				index_dTRN ///
				

local listsize : list sizeof global(hh_summ)
tokenize $hh_summ

forv i = 1/`listsize' {
		
	quietly {
		sum ``i''
		return list
		scalar N_``i'' = r(N) // N
		scalar mean_``i'' = r(mean) // mean
		scalar sd_``i'' = r(sd)  // sd
		scalar min_``i'' = r(min)  // sd
		scalar max_``i'' = r(max)  // sd
		
	* matrix for table
		matrix mat_`i' = (N_``i'',mean_``i'',sd_``i'',min_``i'',max_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using HH_summary.tex, tex statmat(A) sdec(2) coljust(l;c;l;l) title("Household Indicators - Summmary Statistics") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("HH info sales"\"HH info activities"\"HH communication index"\"Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"Net Goat Income"\"HH Goat Sales Index"\"Transparency Discrepancy Index")replace
 


** communication **
gl hh_comm COM3 COM8 index_HHcomm
	
** Co-op vars
local listsize : list sizeof global(hh_comm)
tokenize $hh_comm

forv i = 1/`listsize' {
		
	quietly {
		sum ``i''
		return list
		scalar N_``i'' = r(N) // N
		scalar mean_``i'' = r(mean) // mean
		scalar sd_``i'' = r(sd)  // sd
		scalar min_``i'' = r(min)  // sd
		scalar max_``i'' = r(max)  // sd
		
	* matrix for table
		matrix mat_`i' = (N_``i'',mean_``i'',sd_``i'',min_``i'',max_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("HH Level - Communication: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("HH info sales"\"HH info activities"\"HH level index") addtable replace
 
 
* ------------------------------------------- 

** goat sales **

gl hh_goatsales LS8 LS9 co_opgoatno co_opsalevalue net_goat_income


 
** HH vars
local listsize : list sizeof global(hh_goatsales)
tokenize $hh_goatsales

forv i = 1/`listsize' { 
 
	quietly {
		sum ``i''
		return list
		scalar N_``i'' = r(N) // N
		scalar mean_``i'' = r(mean) // mean
		scalar sd_``i'' = r(sd)  // sd
		scalar min_``i'' = r(min)  // sd
		scalar max_``i'' = r(max)  // sd
		
	* matrix for table
		matrix mat_`i' = (N_``i'',mean_``i'',sd_``i'',min_``i'',max_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("HH Level - HH Goat Sales: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"Net Goat Income") ///
note("Currency measured in USD") addtable replace 
 
* ------------------------------------------- 	

	
** Transparency **

** HH vars
gl hh_trn_d HH_TRN1 HH_TRN2 ///
	HH_TRN3 HH_TRN4 HH_TRN5 ///
	HH_TRN6 HH_TRN7

 
** HH vars
local listsize : list sizeof global(hh_trn_d)
tokenize $hh_trn_d

forv i = 1/`listsize' {
 
	quietly {
		sum ``i''
		return list
		scalar N_``i'' = r(N) // N
		scalar mean_``i'' = r(mean) // mean
		scalar sd_``i'' = r(sd)  // sd
		scalar min_``i'' = r(min)  // sd
		scalar max_``i'' = r(max)  // sd
		
	* matrix for table
		matrix mat_`i' = (N_``i'',mean_``i'',sd_``i'',min_``i'',max_``i'')
		}
}
matrix A = mat_1
forv i = 2/`listsize' { // appends into single matrix
	matrix A = A \ mat_`i'
}

* Table
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("HH Level - HH Awareness: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records") addtable replace
 
	
