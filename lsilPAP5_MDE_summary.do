
clear
set more off, perm
cd "$d2"

** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"


** Co-op indicators **

gl co_summ MAN3 revenue costs net_rev rev_member net_rev_member ///
		PNG1 PNG2 PNG3 expected_rev index_PNG CO_TRN1 CO_TRN2 ///
		CO_TRN3 CO_TRN4 CO_TRN5 CO_TRN6 CO_TRN7

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
rtitle("\# of Members"\"Revenue (USD)"\"Costs (USD)"\"Net Revenue (USD)"\"Revenue per Member (USD)"\"Net Revenue per Member (USD)"\"Co-op has a Business Plan"\"Planning Time Horizon (Years)"\"Expected Goats Sold"\"Expected Revenue (USD)"\"Planning \& Goals Summmary Index"\"Transparency: Mandate"\"Transparency: Annual Report"\"Transparency: Annual Budget"\"Transparency: Financial Report"\"Transparency: Meeting Minutes"\"Transparency: Election Results"\"Transparency: Sale Records")replace
 




** communication **
gl co_comm comm1 comm2 contact COM3 COM8 index_CO_comm HHcontact
	
** Co-op vars
local listsize : list sizeof global(co_comm)
tokenize $co_comm

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
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("Co-op Level - Communication: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Co-op Contact"\"HH info sales"\"HH info activities"\"co-op level index"\"Total HH Contact") replace
 
 
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
note("Currency measured in USD") addtable replace
	
	
* ------------------------------------------- 


** goat sales **

** Co-op vars
gl co_goatsales goats_sold goats_sold_member goatrev goatrev_member goatrev_sold ///
				col_points index_CO_goatsales

** HH vars
gl hh_goatsales LS8 LS9 co_opgoatno co_opsalevalue ///
				co_opshare visits_sale time_passed transp_cost index_salecost ///
				net_goat_income netincome_goat
	
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
rtitle("Goats Sold"\"Goats Sold per Mem."\"Goat Revenue"\"Goat Rev. per Mem."\"Rev. per Goat Sold"\"Collection Points"\"CO Goat Sales Index") ///
note("Currency measured in USD") addtable replace
 
 
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
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("Co-op Level - HH Goat Sales: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"% Sold through Co-op"\"Trader Visits per Sale"\"Time Passed"\"Transportation Costs"\"Sale Costs Index"\"Net Goat Income"\"Net Income per Goat") addtable replace 
 
* ------------------------------------------- 	

	
** Transparency **

** Co-op vars
gl co_trn CO_TRN1 CO_TRN2 ///
	CO_TRN3 CO_TRN4 CO_TRN5 ///
	CO_TRN6 CO_TRN7 index_CO_TRN
	
** HH vars
gl hh_trn HH_TRN1 HH_TRN2 ///
	HH_TRN3 HH_TRN4 HH_TRN5 ///
	HH_TRN6 HH_TRN7 index_HH_TRN index_dTRN avg_dTRN


** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("Co-op Level - Co-op Transparency: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace
 
 
** HH vars
local listsize : list sizeof global(hh_trn)
tokenize $hh_trn

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
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("Co-op Level - HH Awareness: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Discrepancy Index"\"Avg. Discrepancy") addtable replace
 
* ------------------------------------------- 		
	


** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"


** HH indicators **

gl hh_summ COM3 COM8 index_HH_comm ///
				LS8 LS9 co_opgoatno co_opsalevalue ///
				net_goat_income index_HH_goatsales ///
				visits_sale LS41 LS42 index_salecost ///
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
rtitle("HH info sales"\"HH info activities"\"HH level index"\"Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"Net Goat Income"\"HH Goat Sales Index"\"Trader Visits per Sale"\"Time Passed"\"Transportation Costs"\"Sale Costs Index"\"Transparency Discrepancy Index")replace
 


** communication **
gl hh_comm COM3 COM8 index_HH_comm HHcontact
	
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
rtitle("HH info sales"\"HH info activities"\"HH level index"\"Total HH Contact") addtable replace
 
 
* ------------------------------------------- 

** goat sales **

** Co-op vars
gl co_goatsales goats_sold goats_sold_member goatrev goatrev_member goatrev_sold ///
				col_points index_CO_goatsales

gl hh_goatsales LS8 LS9 co_opgoatno co_opsalevalue ///
				co_opshare visits_sale LS41 LS42 index_salecost ///
				net_goat_income netincome_goat


 
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
rtitle("Goats Sold"\"Goat Revenue"\"# Sold through Co-op"\"Rev. through Co-op"\"% Sold through Co-op"\"Trader Visits per Sale"\"Time Passed"\"Transportation Costs"\"Sale Costs Index"\"Net Goat Income"\"Net Income per Goat") ///
note("Currency measured in USD") addtable replace 
 
* ------------------------------------------- 	

	
** Transparency **

** HH vars
gl hh_trn_d HH_TRN1 HH_TRN2 ///
	HH_TRN3 HH_TRN4 HH_TRN5 ///
	HH_TRN6 HH_TRN7 index_HH_TRN avg_dTRN


** Co-op vars
local listsize : list sizeof global(co_trn)
tokenize $co_trn

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
frmttable using MDE_summary.doc, statmat(A) sdec(2) coljust(l;c;l;l) title("HH Level - Co-op Transparency: Summmary Stats") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"Co-op Index") addtable replace
 
 
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
rtitle("Mandate"\"Annual Report"\"Annual Budget"\"Financial Report"\"Meeting Minutes"\"Election Results"\"Sale Records"\"HH Index"\"Avg. Discrepancy") addtable replace
 
	
