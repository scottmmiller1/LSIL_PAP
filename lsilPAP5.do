clear all
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5.smcl", replace

cd "$d2"
use "Baseline_Merged_Str_wdistrictnames copy.dta"


***********************************************
** 				co-op indicators			 **
*********************************************** 

encode region, gen(n_region) // create numerical region variable for regression


** Minimum Detectable Effects **

* Communication
reg index_CO_comm treat n_region role_CPMgt_and_membershi1 role_GMrevenuandcostREC2 ///
 Livestock_SalesLS9, cluster(idx_n)

ereturn list
scalar t_a = invttail(`e(N)',0.025) // alpha t-value
scalar t_b = invttail(`e(N)',0.2) // beta t-value
 
scalar mde_comm = (t_a + t_b)*_se[treat]
display mde_comm

* Calculate MDE as % of mean & # of standard deviations
sum index_CO_comm
display mde_comm / r(mean) // % of treatment mean
display mde_comm / r(sd)  // # of treatment sd's

scalar mean_comm = mde_comm / r(mean) // % of treatment mean
scalar sd_comm = mde_comm / r(sd)  // # of treatment sd's

matrix A = (mde_comm, sd_comm)
matrix list A





frmttable using MDE.tex, statmat(A) sdec(4) title("Minimum Detectable Effects") ///
ctitle("","MDE","% of St. Dev.") rtitle("Co-op Communication") tex


