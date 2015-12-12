clear all
insheet using data.csv, comma names
//Creating outcome variable
gen amountmat = amount * ratio
gen groupid = (redcty==1 & red0 == 1) + (redcty==0 & red0 == 1)*2 + (redcty==0 & red0 == 0)*3 + (redcty==1 & red0 == 0)*4
replace groupid = . if groupid == 0

// help listetal2015

// example 1
listetal2015 gave amount amountmat amountchange, treatment(treatment)

//example 2
listetal2015 gave, treatment(treatment) subgroup(groupid)

//example 3
listetal2015 amount, treatment(ratio)

//example 4
listetal2015 amount, treatment(ratio) combo("pairwise")

//example 5
listetal2015 gave amount amountmat amountchange, subgroup(groupid) treatment(ratio)
