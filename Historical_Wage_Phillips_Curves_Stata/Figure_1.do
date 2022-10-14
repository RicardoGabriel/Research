/*
Figure_1 - Monetary Policy and the Wage-Inflation Unemployment Trade-off

Author: Ricardo Duque Gabriel
First Date: 30/06/2019
Last Update: 04/05/2022

Produce Figure 1
*/

* import data
use "$hp\Data\Data_MScThesis_Analysis.dta", clear
set more off

preserve 
********************************************************************************
* Figure 1 estimation - Rolling Window for mean wage inflation and unemployment rate
********************************************************************************

* set size of rolling window (how many years?)
local window = 10
bysort year (id): gen pick = _n == 1
gen high = cond(pick, year, -99)

* create new program for rolling window estimation
program drop _all
program mypanel
    xtset id year
    gen year1 = r(tmin)
	foreach v in unemp dlwage{
    cap noi sum `v' if noval==0
    gen b_`v' = r(mean)
    }
end

local nwindow = -`window'

* use rangerun command to run rolling window
rangerun mypanel, interval (year `nwindow' high) verbose


********************************************************************************
* Figure 1 - produce graphism
********************************************************************************

* create variables to highlight different historical periods (max and min of previous estimates)
gen t=13
gen tt=-1

* Figure for slides
if ($slides == 1) {
twoway (rarea t tt year if (year>=1870 & year<=1913), color(gs15*0.95)) (rarea t tt year if (year>=1946 & year<=1971), color(gs15*0.95)) ///
	(rarea t tt year if (year>=1995), color(gs15*0.95)) (line b_dlwage year, lcolor(olive) lwidth(thick)) (line b_unemp year, lcolor(gs4) lpa("-") lwidth(thick)), ytitle("Percent (%)") ///
legend( c(1) order(4 "Wage Inflation" 5 "Unemployment") ring(0) position(4) ) ylabel(0(3)12) ///
xlabel(1880(20)2020) xtitle("") xsize(4) ysize(2) scale(1.3) graphregion(fcolor(gs15*0.33333))
graph export "$hp\Output\Figures\Median_dwn_unemp.pdf", replace
}

else if ($slides == 0) {
* Figure for paper
twoway (rarea t tt year if (year>=1870 & year<=1913), color(gs15*0.95)) (rarea t tt year if (year>=1946 & year<=1971), color(gs15*0.95)) ///
	(rarea t tt year if (year>=1995), color(gs15*0.95)) (line b_dlwage year, lcolor(olive) lwidth(thick)) (line b_unemp year, lcolor(gs4) lpa("-") lwidth(thick)), ytitle("Percent (%)") ///
legend( c(1) order(4 "Wage Inflation" 5 "Unemployment") ring(0) position(4) ) ylabel(0(3)12) ///
xlabel(1880(20)2020) xtitle("") xsize(6) ysize(3) scale(1.3)
graph export "$hp\Output\Figures\Median_dwn_unemp_paper.pdf", replace
}

restore

/* Weighted version is too similar

********************************************************************************
* Figure A.1 estimation - Rolling Window for weighted mean wage inflation and unemployment rate
********************************************************************************

* set size of rolling window (how many years?)
local window = 10
bysort year (id): gen pick = _n == 1
gen high = cond(pick, year, -99)

* create new program for rolling window estimation
program drop _all
program mypanel
    xtset id year
    gen year1 = r(tmin)
	foreach v in unemp dlwage{
    cap noi sum `v' [aw=pop] if noval==0
    gen b_`v' = r(mean)
    }
end

local nwindow = -`window'

* use rangerun command to run rolling window
rangerun mypanel, interval (year `nwindow' high) verbose


********************************************************************************
* Figure A.1 - produce graphism
********************************************************************************

* create variables to highlight different historical periods (max and min of previous estimates)
gen t=13
gen tt=-1

* Figure for slides
if ($slides == 1) {
twoway (rarea t tt year if (year>=1870 & year<=1913), color(gs15*0.95)) (rarea t tt year if (year>=1946 & year<=1971), color(gs15*0.95)) ///
	(rarea t tt year if (year>=1995), color(gs15*0.95)) (line b_dlwage year, lcolor(olive) lwidth(thick)) (line b_unemp year, lcolor(gs4) lpa("-") lwidth(thick)), ytitle("Percent (%)") ///
legend( c(1) order(4 "Wage Inflation" 5 "Unemployment") ring(0) position(4) ) ylabel(0(3)12) ///
xlabel(1880(20)2020) xtitle("") xsize(4) ysize(2) scale(1.3) graphregion(fcolor(gs15*0.33333))
graph export "$hp\Output\Figures\Median_dwn_unemp_w.pdf", replace
}

else if ($slides == 0) {
* Figure for paper
twoway (rarea t tt year if (year>=1870 & year<=1913), color(gs15*0.95)) (rarea t tt year if (year>=1946 & year<=1971), color(gs15*0.95)) ///
	(rarea t tt year if (year>=1995), color(gs15*0.95)) (line b_dlwage year, lcolor(olive) lwidth(thick)) (line b_unemp year, lcolor(gs4) lpa("-") lwidth(thick)), ytitle("Percent (%)") ///
legend( c(1) order(4 "Wage Inflation" 5 "Unemployment") ring(0) position(4) ) ylabel(0(3)12) ///
xlabel(1880(20)2020) xtitle("") xsize(6) ysize(3) scale(1.3)
graph export "$hp\Output\Figures\Median_dwn_unemp_paper_w.pdf", replace
}
