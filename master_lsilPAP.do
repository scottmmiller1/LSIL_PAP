version 15.1
/*******************************************************************************
DO FILE DIRECTORY 

	** Randomized cooperatives into treatment & control **
	
lsilPAP_rand0:  															   *
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
	
	
-------------------------------------------------------------------------
	** Cleans data, creates indicator variables, summary statistics, 
		power calulations, and balance tables **
	
lsilPAP0:
	creates collapsed co-op and HH datasets

lsilPAP1: 
	Merges true and randomized treatment status from lsilPAP_rand1/2
	into clean datasets to be used for power calculations
	
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

lsilPAP7: 
	Generates summary statistic tables
	
lsilPAP7: 
	Calculates balance tables

*******************************************************************************/
clear all

*packages
*ssc install outreg
*ssc install ietoolkit

*pathways

** clean datasets **
gl d1 = "/Users/scottmiller/GitHub/LSIL_PAP" // do files stored here
gl d2 = "/Users/scottmiller/Dropbox (UFL)/LSIL/Pre-Analysis Plan/Stata Files/PAP Data" // used to store output
gl d3 = "$d2/LSIL-DATA_scott/VCC baseline clean" // clean data folder - saved separately to preserve original data
gl d4 = "$d2/LSIL-DATA_scott/baseline original" // original data

/* To run all do files

forv i in 0/2 {
	do "$d1/lsilPAP_rand`i'"
}

forv i in 0/5 {
	do "$d1/lsilPAP`i'"
}

*/

