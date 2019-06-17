version 15.1
/*******************************************************************************
DO FILE DIRECTORY 

	** Randomizes cooperatives into treatment & control **
	** This section uses the original data that was sent 
		directly after data collection **
	
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
	** This section uses the clean data that was sent 
		after the data collection firm had time to clean the
		datasets used above **
	
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

lsilPAP6: 
	Generates summary statistic tables
	
lsilPAP7: 
	Calculates balance tables

*******************************************************************************/
clear all

*packages
*ssc install outreg
*ssc install ietoolkit

*pathways
gl d0 = "/Users/scottmiller/Dropbox (UFL)/LSIL/Pre-Analysis Plan/PAP Master Replication" // master replication file
*gl d0 = "C:/Users/Conner/Dropbox/LSIL/Pre-Analysis Plan/PAP Master Replication" // master replication file
gl d1 = "$d0/Stata Files" // do files stored here
gl d2 = "$d0/Output" // used to store output
gl d3 = "$d0/Data/Clean Data" // clean data folder
gl d4 = "$d0/Data/Original Data" // original data

/*
* To run all do files
forv i = 0/2 {
	do "$d1/lsilPAP_rand`i'.do"
}

forv i = 0/7 {
	do "$d1/lsilPAP`i'.do"
}
*/
/*
forv i = 0/4 {
	do "$d1/lsilPAP`i'.do"
}
*/

