libname mydir '/home/u59289493/BUMK742/Project 1';
data Tropic;            
set mydir.tropic;     
run;

/*lq & lp*/
data Tropic;
set tropic;
lq=log(quant);
lp=log(price);
run;

/*season*/
data Tropic;
set tropic;
qrt1=0;
qrt2=0;
qrt3=0;
if (week>=1 and week<=13) or (week>=53 and week<=65) then qrt1=1;
if (week>=14 and week<=26) or (week>=66 and week<=78) then qrt2=1;
if (week>=27 and week<=39) or (week>=79 and week<=91) then qrt3=1;
run;

* Get frequency table of DEAL and STORE */
data Tropic;
set tropic;
proc freq;
table deal store;
run;

/* Get descriptive statistics of sales by deal */
data Tropic;
set tropic;
proc means;
var quant;
class deal;
run;

/* Get average sales volume and price by store */
data Tropic;
set tropic;
proc means;
var quant price;
class store;
run;

/* Get average sales volume and price by quarter */
data Tropic;
set tropic;
if (week>=1 and week<=13) or (week>=53 and week<=65) then quarter=1;
if (week>=14 and week<=26) or (week>=66 and week<=78) then quarter=2;
if (week>=27 and week<=39) or (week>=79 and week<=91) then quarter=3;
if (week>=40 and week<=52) or (week>=92 and week<=104) then quarter=4;
run;

proc means;
var quant price;
class quarter;
run;

/* Get correlation matrix of sales, price, week, and deal */
data Tropic;
set tropic;
proc corr;
var quant price week deal;
run;

/*year*/
data Tropic;
set tropic;
Year09=0;
if (week>=1 and week<=52) then Year09=1;
run;

data Tropic;
set tropic;
if (week>=1 and week<=52) then Year=2009;
 else Year=2010;
proc means;
var quant price deal;
class Year;
run;

/*decimal*/
data Tropic;
set tropic;
end9=0;
if (MOD(price*100,10)=9) then end9=1;
run;

/*store*/
data Tropic;
set tropic;
store2=0;
if (store=2) then store2=1;
store14=0;
if (store=14) then store14=1;
store32=0;
if (store=32) then store32=1;
store52=0;
if (store=52) then store52=1;
store62=0;
if (store=62) then store62=1;
store68=0;
if (store=68) then store68=1;
store71=0;
if (store=71) then store71=1;
store72=0;
if (store=72) then store72=1;
store93=0;
if (store=93) then store93=1;
store95=0;
if (store=95) then store95=1;
store111=0;
if (store=111) then store111=1;
store123=0;
if (store=123) then store123=1;
store124=0;
if (store=124) then store124=1;
store130=0;
if (store=130) then store130=1;
run;

/*Holiday*/
data Tropic;
set tropic;
 if week=1 or week=3 or week=7 or week=22 or week=27 
 or week= 36 or week=41 or week=46 or week=48
 or week=52 or week=53 or week= 55 or week= 59 or week=74
 or week=79 or week=88 or week=92 or week=97 
 or week=99 or week=103 or week=104 then Holiday=1; else Holiday=0;
run;

/*One week before Holiday*/
data Tropic;
set tropic;
 if week=2 or week=6 or week=21 or week=26 
 or week=35 or week=40 or week=45 or week=47
 or week=51 or week=52 or week= 54 or week= 58 or week=73
 or week=78 or week=87 or week=91 or week=96 
 or week=98 or week=102 or week=103 then BeforeHoliday=1; else BeforeHoliday=0;
run;

proc reg;
/*model quant = price deal - linear model */
model quant = price deal week qrt1 qrt2 qrt3 end9 store2 store14 store32 store52 store62 store68 store71 store72 store93 store95 store111 store123 store124 store130 Holiday BeforeHoliday;    
/*model lq = lp deal - log-log model */
model lq = lp deal week qrt1 qrt2 qrt3 end9 store2 store14 store32 store52 store62 store68 store71 store72 store93 store95 store111 store123 store124 store130 Holiday BeforeHoliday;  
/*model lq = price deal - semi-log models */
model lq = price deal week qrt1 qrt2 qrt3 end9 store2 store14 store32 store52 store62 store68 store71 store72 store93 store95 store111 store123 store124 store130 Holiday BeforeHoliday; 
model lq = price deal week qrt1 qrt2 qrt3 end9 store2 store14 store32 store52 store62 store68 store71 store72 store93 store95 store111 store123 store124 store130 BeforeHoliday; 
run; 
