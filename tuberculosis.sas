%let tbpath=/home/u61896790/tuberculosis;
libname tb "&tbpath";

options validvarname=v7;
proc import datafile="&tbpath/DOHMH_Tuberculosis_Surveillance__Data_from_the_Tuberculosis_Control_Annual_Summary (1).xlsx"
dbms=xlsx out=tb.input_tb replace;
	getnames=yes;
run;

data tb.tb (keep= Year Number_of_TB_cases  Multidrug_resistance_cases Percent_Multidrug_Resistant);
	set tb.input_tb;
	where Year ge 1991;
	Percent_Multidrug_Resistant=round(((Multidrug_resistance_cases/Number_of_TB_cases)*100),0.01);
run;

ods pdf file="&tbpath/tb.pdf" pdftoc=1 startpage=no;
title "Tuberculosis (TB) Cases in New York City from 1991 to 2016";
proc print data=tb.tb label noobs;
	label Percent_Multidrug_Resistant="Percent of TB cases that were Multidrug Resistant";
	label Number_of_TB_cases="Total Number of TB cases";
	label Multidrug_resistance_cases="Number of TB cases that were multidrug resistant";
run;
title;
ods pdf close;

proc export data=tb.tb outfile="&tbpath/tb.xlsx"
dbms=xlsx replace;
run;