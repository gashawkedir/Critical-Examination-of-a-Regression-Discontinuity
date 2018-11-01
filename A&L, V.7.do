/************************************************************************************************************************************
This program replicates some of the results provided in the Angrist and Lavy Paper
Programmed by: Samantha J Hills, Gashaw Kedir, and Storm Lawrence

First created: 3/05/2016
Last modified: 3/17/2016

**************************************************************************************************************************************/

clear
set more off
use "/Users/samanthahills/Desktop/CAUSAL/Empirical Exercises/PSet3/datasets and codebook/angrist_lavy.dta"


*INSTALLING NECCESSARY PROGRAMS
*ssc install cmogram
*ssc install rd
*ssc install rdrobust

rename c_size enrollment


*QUESTION 2.4 CREATE BINS AND CREATE SCATTERPLOT*

egen msize = mean (class_size), by (enrollment)
twoway (scatter msize enrollment), xline(41, lcolor (red)) xline(81, lcolor (red)) ///
xline(121, lcolor (red)) xline(161, lcolor (red)) xscale(r(0 220))  ///
xlabel (0(20)220) yscale(r(5 40)) ylabel(5(5)40)


*QUESTION 2.5 SCATTERPLOT WITH DATA LIMITED TO 80*

qui: cmogram msize enrollment if enrollment<81, cut (40) scatter line(40) graphopts(xscale(r(0 80)) xlabel(0 (20) 80) ///
yscale(r(0 45)) ylabel(0 (5) 45)) qfit


*QUESTION 2.6 SCATTERPLOTTING MATH AND VERBAL SCORES AS A FUNCTION OF ENROLLMENT BINS*

*VERBAL

qui: cmogram avgverb enrollment if enrollment<81, cut(40) scatter line(40) graphopts(xscale(r(0 80)) xlabel(0 (20) 80) ///
yscale(r(50 90)) ylabel(50 (5) 90)) qfit

*MATH

qui: cmogram avgmath enrollment if enrollment<81, cut(40) scatter line(40) graphopts(xscale(r(0 80)) xlabel(0 (20) 80) ///
yscale(r(40 80)) ylabel(40 (5) 80)) qfit
 

*QUESTION 2.7 ESTIMATE OLS OF MATH SCORES**CREATE TABLE**

regress avgmath class_size
outreg2 using table1.xls, append
regress avgmath class_size poor
outreg2 using table2.xls, append
regress avgmath class_size poor enrollment
outreg2 using table3.xls, append


*QUESTION 2.8

*LIMIT THE SAMPLE AND RECENTER*
preserve
gen cenenroll=enrollment-41
replace cenenroll=1 if class_size==40 & cenenroll==0

gen small = enrollment>40
replace small=1 if enrollment>40 & small==0


*CREATE QUADRATIC AND INTERACTION VARIABLES*
gen cenenroll2 = cenenroll^2
gen ixcensmall = cenenroll*small


*QUESTION 2.9 ESTIMATE THE FS OF MRULE**CREATE TABLE***

regress class_size mrule poor cenenroll if enrollment<81
gen fs1 = _b[mrule]

regress class_size mrule cenenroll cenenroll2 ixcensmall if enrollment<81
gen fs2 = _b[mrule]


*QUESTION 2.10 ESTIMATE THE REDUCED FORM OF TWO MODELS **CREATE TABLE***

*ADD DISADVANTAGED STUDENTS*

regress avgmath mrule poor cenenroll if enrollment<81
gen rcmath = _b[mrule]

regress avgverb mrule poor cenenroll if enrollment<81
gen rcverb = _b[mrule]

*ADD QUADRATIC AND INTERACTION VARIABLES*

regress avgmath mrule poor cenenroll cenenroll2 ixcensmall if enrollment<81
gen rc2math = _b[mrule]

regress avgverb mrule poor cenenroll cenenroll2 ixcensmall if enrollment<81
gen rc2verb = _b[mrule]


*QUESTION 2.11 WALD ESTIMATES*

gen waldmath2 = rcmath/fs1
gen waldverb2 = rcverb/fs1
gen waldmath3 = rc2math/fs2
gen waldverb3 = rc2verb/fs2


*QUESTION 2.12 2SLS MODELS*

ivregress 2sls avgmath (class_size=mrule) poor cenenroll if enrollment <81, robust first 
outreg2 using table4.xls, append

ivregress 2sls avgverb (class_size=mrule) poor cenenroll if enrollment <81, robust first 
outreg2 using table5.xls, append

ivregress 2sls avgmath (class_size=mrule) poor cenenroll cenenroll2 ixcensmall if enrollment<81, robust first
outreg2 using table6.xls, append 

ivregress 2sls avgverb (class_size=mrule) poor cenenroll cenenroll2 ixcensmall if enrollment<81, robust first
outreg2 using table7.xls, append 


*QUESTION 2.13 VARY BANDWITH

ivregress 2sls avgmath (class_size=small) poor cenenroll if cenenroll>-20 & cenenroll<20, cluster(cenenroll)
outreg2 using table8.xls, replace
ivregress 2sls avgmath (class_size=small) poor cenenroll if cenenroll>-10 & cenenroll<10, cluster(cenenroll)
outreg2 using table8.xls, append
ivregress 2sls avgmath (class_size=small) poor cenenroll if cenenroll>-5 & cenenroll<5, cluster(cenenroll)
outreg2 using table8.xls, append

ivregress 2sls avgverb (class_size=small) poor cenenroll if cenenroll>-20 & cenenroll<20, cluster(cenenroll)
outreg2 using table9.xls, replace
ivregress 2sls avgverb (class_size=small) poor cenenroll if cenenroll>-10 & cenenroll<10, cluster(cenenroll)
outreg2 using table9.xls, append
ivregress 2sls avgverb (class_size=small) poor cenenroll if cenenroll>-5 & cenenroll<5, cluster(cenenroll)
outreg2 using table9.xls, append


*QUESTION 2.14 STATA RD*

rd avgmath mrule cenenroll if enrollment<81, bw(20) robust
rd avgmath mrule cenenroll if enrollment<81, bw(10) robust
outreg2 using table10.xls, append
rd avgmath mrule cenenroll if enrollment<81, bw(5) robust

rd avgverb mrule cenenroll if enrollment<81, bw(20) robust
rd avgverb mrule cenenroll if enrollment<81, bw(10) robust
outreg2 using table11.xls, append
rd avgverb mrule cenenroll if enrollment<81, bw(5) robust

/*rdrobust avgmath mrule cenenroll if enrollment<81, fuzzy(mrule)
rdrobust avgverb mrule cenenroll if enrollment<81, fuzzy(mrule)*/
*TABLE 12**


*QUESTION 2.15 USING FULL SAMPLE*

*RESTORE TO FULL SAMPLE*
restore
preserve

gen enroll2 = enrollment^2

*MAKE INDICATORS*
gen small1=enrollment>40
replace small1=1 if enrollment>=40 & small1==0
gen small2=enrollment>80
replace small2=1 if enrollment>=80 & small2==0
gen small3=enrollment>120
replace small3=1 if enrollment>=120 & small3==0
gen small4=enrollment>160
replace small4=1 if enrollment>=160 & small4==0
gen small5=enrollment>200
replace small5=1 if enrollment>=200 & small5==0


*CONSTRUCT MODELS*

ivregress 2sls avgmath (class_size=small1 small2 small3 small4 small5) poor enrollment enroll2
outreg2 using table13.xls, replace
ivregress 2sls avgverb (class_size=small1 small2 small3 small4 small5) poor enrollment enroll2 
outreg2 using table14.xls, replace


*FIRST STAGE*

regress class_size small1 small2 small3 small4 small5 poor enrollment enroll2, robust
outreg2 using table15.xls, replace

test small1=small2=small3=small4=small5=0


*QUESTION 2.16 LIMIT THE SAMPLE* 

gen disc= (enrollment>=36 & enrollment<=45)|(enrollment>=76 & enrollment<=85)|(enrollment>=116 & enrollment<=125)
replace disc=1 if enrollment>=36 & enrollment<=45 & enrollment>=76 & enrollment<=85 & enrollment>=116 & enrollment<=125 & disc==0

drop if disc==0

*USING SMALL INDICATOR AS IV*

ivregress 2sls avgmath (class_size=small1 small2 small3 small4 small5) poor enrollment enroll2, robust first
outreg2 using table16.xls, replace
ivregress 2sls avgverb (class_size=small1 small2 small3 small4 small5) poor enrollment enroll2, robust first
outreg2 using table16.xls, append

*FIRST STAGE OF SMALL INDICATOR*

regress class_size small1 small2 small3 small4 small5 poor enrollment enroll2, robust
outreg2 using table17.xls, replace

*USING MRULE AS IV*
ivregress 2sls avgmath (class_size=mrule) poor enrollment enroll2, robust first
outreg2 disc using table18.xls, replace
ivregress 2sls avgverb (class_size=mrule) poor enrollment enroll2, robust first
outreg2 disc using table18.xls, append

*FIRST STAGE OF M RULE*

regress class_size mrule poor enrollment enroll2, robust
outreg2 using table19.xls, replace



