version 15.1
/*******************************************************************************
DO FILE DIRECTORY 

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

*pathways
gl d1 = "/Users/scottmiller/Documents/GitHub/LSIL_PAP" // do files stored here
gl d2 = "/Users/scottmiller/Dropbox (UFL)/LSIL/Pre-Analysis Plan/Stata Files/PAP Data" // initial data sets stored here
gl d3 = "$d2/LSIL-DATA_scott/VCC baseline aug 20 2018" // clean data folder - saved separately to preserve original data


	
*gl d1 = "D:\Mullally,Conner\Documents\Dropbox\LSIL\Pre-Analysis Plan\Stata Files" // do files stored here
*gl d2 = "D:\Mullally,Conner\Documents\Dropbox\LSIL\Pre-Analysis Plan\Stata Files/PAP Data" // initial data sets stored here


/* To run all do files

foreach i in 0 1 2 3 4 5 {
	do "$d1/lsilPAP`i'"
}

*/

