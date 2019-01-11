version 15.1
/*******************************************************************************
DO FILE DIRECTORY 

	** Using original (pre-cleaned) datasets **
	
lsilPAP_rand0:  	(Coding / data error happens here)
	Collapses livestock sales data for hh into one row per hh
	
	Merges household and cooperative data. Top codes total goats sold and total
	livestock revenue at hh level. 

lsilPAP_rand1:	
	Stratifies co-ops by region, hh livestock revenue (split 
	at 33rd amd 66th percentiles), number of co-op members (at median), total co-op
	revenue (at median). 
	
	Randomizes co-ops into treatment control
	
lsilPAP_rand2:	
	Runs a random permutation of treatment status to be used for 
	minimum detectable effect calculations
	
	
-----------------------------------------------
	** Using cleaned datasets **
	
lsilPAP0:
	creates collapsed co-op and HH datasets

lsilPAP1: 
	Runs a random permutation of treatment status

lsilPAP2: 
	Generates a merged dataset at the HH level
	Collapses HH data from ind. level to HH level
	Saves respective datasets as r_CO_Merged_PAP.dta
	and r_HH_Merged_PAP.dta
	
lsilPAP3:
	Creates command for ICW Summary Indices
	(published by Cyrus Samii, NYU, December 2017) 
	
lsilPAP4: 
	Creates indicator variables & ICW Summary Indices from
	r_CO_Merged_PAP.dta (co-op level dataset)
	and r_HH_Merged_PAP.dta (HH level dataset)
	Saves new datasets respectively as: 
	r_CO_Merged_Ind.dta
	r_HH_Merged_Ind.dta

lsilPAP5: 
	Calculates MDEs for each indicator
	
lsilPAP6: 
	Calculates balance tables

*******************************************************************************/
clear all

*packages
*ssc install outreg
*ssc install ietoolkit

*pathways
** original datasets **
gl d2_rand = "/Users/scottmiller/Dropbox (UFL)/LSIL/Data/Previous Versions/Baseline" // initial data sets stored here

** clean datasets **
gl d1 = "/Users/scottmiller/Documents/GitHub/LSIL_PAP" // do files stored here
gl d2 = "/Users/scottmiller/Dropbox (UFL)/LSIL/Pre-Analysis Plan/Stata Files/PAP Data" // used to store output
gl d3 = "$d2/LSIL-DATA_scott/VCC baseline clean" // clean data folder - saved separately to preserve original data
gl d4 = "$d2/LSIL_DATA_scott/baseline original" // original data

/* To run all do files

foreach i in 0 1 2 {
	do "$d1/lsilPAP_rand`i'"
}

foreach i in 0 1 2 3 4 5 {
	do "$d1/lsilPAP`i'"
}

*/

