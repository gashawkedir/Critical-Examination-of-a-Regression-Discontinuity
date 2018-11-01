/************************************************************************************************************************************
This program replicate some of the results provided in the Dee(2008) paper
Programmed by: Samantha J Hills, Gashaw Kedir, and Storm Lawrence

First created: 3/4/2016
Last modified: 3/19/2016

**************************************************************************************************************************************/
/*
clear
set more off


*use  "C:\Users\gashaw\Desktop\Causal Evaluation\Lee V1.dta"

use "P:\Causal Evaluation\Stata data\electoral1.dta"

*INSTALL CMOGRAM AND RD AT THE BEGINNING 
ssc install cmogram
ssc install rd
ssc install outreg2
net install rdrobust, from(http://www-personal.umich.edu/~cattaneo/software/rdrobust/stata) replace

*QUESTION 1.4

replace win =1 if mov>0
replace win =0 if mov<=0

qui: cmogram win mov, cut(0) scatter line(0)

qui: cmogram win mov, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(0 1)) ylabel(0(.1)1))


*QUESTION 1.5
*2a
qui: cmogram myoutcomenext mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(0 1)) ylabel(0(.1)1)) qfit 

*saving(figure2a.png)

*2b
qui: cmogram mofficeexp mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(0.0 5.0)) ylabel(0.0(.50)5.0)) qfit

*2c
qui: cmogram mrunagain mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(0.0 1.0)) ylabel(0.0(.10)1.0)) qfit

*2d
qui: cmogram melectexp mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(0 5)) ylabel(0(.5)5)) qfit

*QUESTON 1.6 GENERATING POLYNOMIAL AND INTERACTIONS
gen mov1 = mov^2
gen mov2 = mov^3
gen mov3 = mov^4

gen mov_win = mov*win
gen mov1_win =mov1*win
gen mov2_win = mov2*win
gen mov3_win = mov3*win

*QUESTION 1.7 RUN REGRESSIONS
reg demsharenext win mov, cluster(mov)
outreg2 using table1.7.xls, replace
reg demsharenext win mov mov1, cluster(mov)
outreg2 using table1.7.xls, append
reg demsharenext win mov mov1 mov2 , cluster(mov)
outreg2 using table1.7.xls, append
reg demsharenext win mov mov1 mov2 mov3, cluster(mov)
outreg2 using table1.7.xls, append
reg demsharenext win mov mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, cluster(mov)
outreg2 using table1.7.xls, append

*QUESTION 1.8 REGRESSION WITH VARIED BANDWIDTHS
reg demsharenext win mov2 if mov > -0.2 & mov < 0.2, cluster(mov)
outreg2 using table1.8xls, replace
reg demsharenext win mov2 if mov > -0.1 & mov < 0.1, cluster(mov)
outreg2 using table1.8.xls, append
reg demsharenext win mov2 if mov > -0.05 & mov < 0.05, cluster(mov)
outreg2 using table1.8.xls, append
reg demsharenext win mov2 if mov > -0.02 & mov < 0.02, cluster(mov)
outreg2 using table1.8.xls, append

*QUESTION 1.9
rd demsharenext mov, z0(0)  bwidth(.05)
rdrobust demsharenext mov, c(0)

*/




clear
*use  "C:\Users\gashaw\Desktop\Causal Evaluation\electoral2.dta"

use "P:\Causal Evaluation\Stata data\electoral2.dta"

*INSTALL CMOGRAM AND RD AT THE BEGGINNING 
ssc install cmogram
ssc install rd
ssc install outreg2
net install rdrobust, from(http://www-personal.umich.edu/~cattaneo/software/rdrobust/stata) replace

*QUESTION 1.11
*4a
qui: cmogram demsharenext mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(.3 .7)) ylabel(0(.1).7)) qfit 

*4b
qui: cmogram demshareprev mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(.3 .7)) ylabel(0(.1).7)) qfit

*5a
qui: cmogram demwinnext mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(0 1)) ylabel(0(.1)1)) qfit

*6b
qui: cmogram demwinprev mov if mov >=-0.25 & mov <=.25, cut(0) scatter line(0) graphopts(xscale(r(-0.25 .25)) ///
xlabel(-.25(.05).25) yscale(r(0 1)) ylabel(0(.1)1)) qfit

*QUESTION 12  
gen win=.
replace win=1 if mov>0
replace win=0 if mov<=0
*drop if mov == 0
*replace win=. if mov==0
*drop if win==.

gen mov1 = mov^2
gen mov2 = mov^3
gen mov3 = mov^4

gen mov_win = mov*win
gen mov1_win =mov1*win
gen mov2_win = mov2*win
gen mov3_win = mov3*win


*Table 2
*column 1
reg demsharenext win mov mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, robust
outreg2 using table1.12.xls, replace

*column 2
reg demsharenext win demshareprev demwinprev mov mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, robust
outreg2 using table1.12.xls, append

*column 3
reg demsharenext win demofficeexp othofficeexp mov mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, robust
outreg2 using table1.12.xls, append

*column 4
reg demsharenext win demelectexp othelectexp mov mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, robust
outreg2 using table1.12.xls, append

*column 5
reg demsharenext win demshareprev demwinprev demofficeexp othofficeexp demelectexp othelectexp mov  mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, robust

outreg2 using table1.12.xls, append

*column 6
reg demsharenext demshareprev demwinprev demofficeexp othofficeexp demelectexp othelectexp, robust
predict resvoteshare, residuals
reg resvoteshare win, robust
outreg2 using table1.12.xls, append

*column 7
gen diffvoteshare = demsharenext - demshareprev
reg diffvoteshare win demwinprev  demofficeexp othofficeexp demelectexp othelectexp mov  mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, robust
outreg2 using table1.12.xls, append

*column 8
reg demshareprev win demwinprev  demofficeexp othofficeexp demelectexp othelectexp mov mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win, robust
outreg2 using table1.12.xls, append

*QUESTION 13

local variables demshareprev demwinprev demofficeexp othofficeexp demelectexp othelectexp
foreach x in `variables' {
rdrobust `x' mov, c(0)
outreg2 using table13final.xls
}


stop
local variables demsharenext demwinnext demshareprev demwinprev demofficeexp othofficeexp demelectexp othelectexp
foreach x in `variables' {
reg `x' win 
outreg2 win using table13, excel
}


foreach x in `variables' {
reg `x' win if mov < .5 & mov > -.5
outreg2 win using table14, excel
}


foreach x in `variables' {
reg `x' win if mov < .05 & mov > -.05
outreg2 win using table15, excel
}

foreach x in `variables' {
reg `x' win mov mov1 mov2 mov3 mov_win mov1_win mov2_win mov3_win 
outreg2 win using table15, excel
}


STOP












