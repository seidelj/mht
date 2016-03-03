clear all
insheet using data.csv, comma names
//Creating outcome variable
gen amountmat = amount * ratio
gen groupid = (redcty==1 & red0 == 1) + (redcty==0 & red0 == 1)*2 + (redcty==0 & red0 == 0)*3 + (redcty==1 & red0 == 0)*4
replace groupid = . if groupid == 0

// help mhtexp

// example 1
mhtexp gave amount amountmat amountchange, treatment(treatment)

//example 2
mhtexp gave, treatment(treatment) subgroup(groupid)

//example 3
mhtexp amount, treatment(ratio)

//example 4
mhtexp amount, treatment(ratio) combo("pairwise")

//example 5
mhtexp gave amount amountmat amountchange, subgroup(groupid) treatment(ratio)
