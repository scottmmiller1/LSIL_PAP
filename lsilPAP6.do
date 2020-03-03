
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


** Co-op variables **

gl co_summ MAN3 revenue costs net_rev rev_member net_rev_member CO_SER15 goatrev ///
		PNG2 PNG3_w expected_rev_w ICTassets Otherassets mobile_network

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
frmttable using CO_summary.tex, tex statmat(A) sdec(2) coljust(l;c;l;l) ///
title("Cooperative Indicators - Summmary Statistics") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Members (count)"\"Revenue (USD)"\"Costs (USD)"\"Net revenue (USD)"\ ///
		"Revenue per member (USD)"\"Net revenue per member (USD)"\ ///
		"Coordinates goat sales (0/1)"\"Goat revenue (USD)"\ ///
		"Planning time horizon (years)"\"Expected goats sold (count)"\ ///
		"Expected revenue (USD)"\"Number of ICT assets (count)"\ ///
		"Number of non-ICT assets (count)"\"Mobile network seriously limits communication (0/1)")replace
 


** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"


** HH indicators **

gl hh_summ dirt_floor nfloors HHR4 HHR14 MEM11 ///
			travel_time_ln sales_awareness bCOM3 co_opgoatno_w LS8_w ///
			rev_goat_w rev_co_opgoat_w ///
			index_dTRN index_dSER ///
	

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
frmttable using HH_summary.tex, tex statmat(A) sdec(2) coljust(l;c;l;l) ///
title("Household Indicators - Summmary Statistics") ///
ctitle("","N","Mean","sd","Min","Max") ///
rtitle("Household has dirt floors (0/1)"\"Household has more than one floor (0/1)"\ ///
		"Age (years)"\"Literacy (0/1)"\"Number of SHG meetings attended (count)"\ ///
		"Log travel time to cooperative (minutes)"\ ///
		"Aware of cooperative goat sales (0/1)"\"Received Sale Information (0/1)"\ ///
		"Goats sold through cooperative (count)"\"Total goats sold (count)"\ ///
		"Revenue per goat (USD)"\"Revenue per goat through cooperative (USD)"\ ///
		"Administrative transparency index"\"Economic services transparency index") replace
 

