
clear
set more off, perm

*log
cap log close
log using "$d1/lsilPAP5_test_comm.smcl", replace

cd "$d2"

** Minimum Detectable Effects **


** Co-op level dataset
********************************************* 
clear
use "$d3/r_CO_Merged_Ind.dta"
encode idx, gen(idx_n)

* Communication

*** Strata dummies - No interaction
local varlist comm1 comm2 contact COM3 COM8 index_CO_comm
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_CO_comm, ., sd_index_CO_comm)
	}

* Strata table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("Co-op Level Communication: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"co-op level index") replace

*** Strata dummies - Interaction
local varlist comm1 comm2 contact COM3 COM8 index_CO_comm
foreach v in `varlist' {
	
	reg `v' r_treat i.strata r_treat#i.strata, cluster(idx_n)
	
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_CO_comm, ., sd_index_CO_comm)
	}

* Strata table

frmttable using MDE_comm.doc, statmat(A) sdec(4) title("Co-op Level Communication: Strata - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"co-op level index") addtable replace


*** Variables - No interaction
local varlist comm1 comm2 contact COM3 COM8 index_CO_comm
foreach v in `varlist' {
	
	reg `v' r_treat n_region MAN3 REC2 ///
	LS9, cluster(idx_n)
	
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_CO_comm, ., sd_index_CO_comm)
	}

* Variables table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("Co-op Level Communication: Variables - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"co-op level index") addtable replace


*** Variables - Interaction
local varlist comm1 comm2 contact COM3 COM8 index_CO_comm
foreach v in `varlist' {
	
	reg `v' r_treat n_region MAN3 REC2 ///
	LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
	c.LS9#r_treat, cluster(idx_n)
	
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_CO_comm, ., sd_index_CO_comm)
	}

* Variables table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("Co-op Level Communication: Variables - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"co-op level index") addtable replace



************************
* factors that limit comminication

** Strata - No interaction
* no control
reg contact r_treat i.strata, cluster(idx_n)

quietly scalar r2_n = e(r2)
* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	destring COMM8`v', replace
	reg contact COMM8`v' r_treat i.strata, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}
* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat i.strata, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Strata - No interaction") addtable replace

** Strata - Interaction
* no control
reg contact r_treat i.strata r_treat#i.strata, cluster(idx_n)

quietly scalar r2_n = e(r2)

* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	reg contact COMM8`v' r_treat r_treat#i.strata, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}

* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat r_treat#i.strata, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Strata - Interaction") addtable replace



** Variables - No interaction
* no control
reg contact r_treat n_region MAN3 REC2 ///
LS9, cluster(idx_n)

quietly scalar r2_n = e(r2)
* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	reg contact COMM8`v' r_treat n_region MAN3 ///
	REC2 LS9, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}
* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat n_region MAN3 REC2 ///
LS9, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Variables - No interaction") addtable replace


** Variables - Interaction
* no control
reg contact r_treat n_region MAN3 REC2 ///
	LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
	c.LS9#r_treat, cluster(idx_n)

quietly scalar r2_n = e(r2)
* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	reg contact COMM8`v' r_treat n_region MAN3 REC2 ///
LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
c.LS9#r_treat, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}
* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat n_region MAN3 REC2 ///
LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
c.LS9#r_treat, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Variables - Interaction") addtable replace



** HH level dataset
********************************************* 
clear
use "$d3/r_HH_Merged_Ind.dta"
encode idx, gen(idx_n)

* Communication

*** Strata dummies - No interaction
local varlist comm1 comm2 contact COM3 COM8 index_HH_comm index_HH_comm_full
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_HH_comm, ., sd_index_HH_comm\ ///
			mde_index_HH_comm_full, ., sd_index_HH_comm_full)
	}

* Strata table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("HH Level Communication: Strata - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"HH level index"\"HH index full") addtable replace


*** Strata dummies - Interaction
local varlist comm1 comm2 contact COM3 COM8 index_HH_comm index_HH_comm_full
foreach v in `varlist' {
	
	reg `v' r_treat i.strata r_treat#i.strata, cluster(idx_n)
	
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_HH_comm, ., sd_index_HH_comm\ ///
			mde_index_HH_comm_full, ., sd_index_HH_comm_full)
	}

* Strata table

frmttable using MDE_comm.doc, statmat(A) sdec(4) title("HH Level Communication: Strata - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"HH level index"\"HH index full") addtable replace



*** Variables - No interaction
local varlist comm1 comm2 contact COM3 COM8 index_HH_comm index_HH_comm_full
foreach v in `varlist' {
	
	reg `v' r_treat n_region MAN3 REC2 ///
	LS9, cluster(idx_n)
	
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_HH_comm, ., sd_index_HH_comm\ ///
			mde_index_HH_comm_full, ., sd_index_HH_comm_full)
	}

* Variables table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("HH Level Communication: Variables - No Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"HH level index"\"HH index full") addtable replace


*** Variables - Interaction
local varlist comm1 comm2 contact COM3 COM8 index_HH_comm index_HH_comm_full
foreach v in `varlist' {
	
	reg `v' r_treat n_region MAN3 REC2 ///
	LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
	c.LS9#r_treat, cluster(idx_n)
	
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
	matrix A = (mde_comm1, mean_comm1, sd_comm1\ ///
			mde_comm2, mean_comm2, sd_comm2\ ///
			mde_contact, mean_contact, sd_contact\ ///
			mde_COM3, mean_COM3, sd_COM3\ ///
			mde_COM8, mean_COM8, sd_COM8\ ///
			mde_index_HH_comm, ., sd_index_HH_comm\ ///
			mde_index_HH_comm_full, ., sd_index_HH_comm_full)
	}

* Variables table
frmttable using MDE_comm.doc, statmat(A) sdec(4) title("HH Level Communication: Variables - Interaction") ///
ctitle("","MDE","% of mean","# of sd's.") ///
rtitle("Contacted SHG"\"Contacted by SHG"\"Total Contact"\"HH info sales"\"HH info activities"\"HH level index"\"HH index full") addtable replace



************************
* factors that limit comminication

** Strata - No interaction
* no control
reg contact r_treat i.strata, cluster(idx_n)

quietly scalar r2_n = e(r2)
* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	destring COMM8`v', replace
	reg contact COMM8`v' r_treat i.strata, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}
* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat i.strata, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Strata - No interaction") addtable replace

** Strata - Interaction
* no control
reg contact r_treat i.strata r_treat#i.strata, cluster(idx_n)

quietly scalar r2_n = e(r2)

* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	reg contact COMM8`v' r_treat r_treat#i.strata, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}

* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat r_treat#i.strata, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Strata - Interaction") addtable replace



** Variables - No interaction
* no control
reg contact r_treat n_region MAN3 REC2 ///
LS9, cluster(idx_n)

quietly scalar r2_n = e(r2)
* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	reg contact COMM8`v' r_treat n_region MAN3 ///
	REC2 LS9, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}
* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat n_region MAN3 REC2 ///
LS9, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Variables - No Interaction") addtable replace


** Variables - Interaction
* no control
reg contact r_treat n_region MAN3 REC2 ///
LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
c.LS9#r_treat, cluster(idx_n)

quietly scalar r2_n = e(r2)
* individual controls
local vlist a b c d e f
foreach v in `vlist' {
	reg contact COMM8`v' r_treat n_region MAN3 REC2 ///
	LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
	c.LS9#r_treat, cluster(idx_n)
	
	quietly {
		scalar r2_`v' = e(r2)
	}
}
* all controls
reg contact COMM8a COMM8b COMM8c ///
COMM8d COMM8e COMM8f ///
r_treat n_region MAN3 REC2 ///
LS9 n_region#r_treat c.MAN3#r_treat c.REC2#r_treat ///
c.LS9#r_treat, cluster(idx_n)

quietly scalar r2_all = e(r2)

quietly {
	matrix R = (r2_n\r2_a\r2_b\r2_c\r2_d\r2_e\r2_f\r2_all)
	matrix rownames R = . Internet Mobile-Network SMS-Cost Distance Roads Transportation All
	matrix colnames R = r2
}	

matrix list R

frmttable using MDE_comm.doc, statmat(R) sdec(4) title("Factors that Limit Communication: Variables - Interaction") addtable replace



***********************************************






