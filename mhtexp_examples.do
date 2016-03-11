clear all
insheet using data.csv, comma names
//Creating outcome variable
gen amountmat = amount * ratio
gen groupid = (redcty==1 & red0 == 1) + (redcty==0 & red0 == 1)*2 + (redcty==0 & red0 == 0)*3 + (redcty==1 & red0 == 0)*4
replace groupid = . if groupid == 0

mata: mata mlib index

// help mhtexp

//Example 1: Hypothesis testing with multiple outcomes: 
//  We consider four outcome variables: response rate, dollars given not including
//  match, dollars given including match, and amount change.
mhtexp gave amount amountmat amountchange, treatment(treatment)

//Example 2: Hypothesis testing with multiple subgroups: 
//  We consider four subgroups: red county in a red state, blue county in a red state,
//  red county in a blue state, and blue county in a blue state. We focus on
//  the outcome response rate.
mhtexp gave, treatment(treatment) subgroup(groupid)

//Example 3: Hypothesis testing with multiple treatments: 
//  We consider the three treatments for match ratio: 1:1, 2:1, and 3:1. We focus on the
//  outcome dollars given not including match.
//  Here we compare each treatment group to the control
mhtexp amount, treatment(ratio)

//Example 4: Hypothesis testing with multiple treatments (continued)
//  All pairwise comparisons among the treatment and control groups
mhtexp amount, treatment(ratio) combo("pairwise")

//Example 5: Hypothesis testing with multiple outcomes, subgroups, treatments: 
//  We consider four outcome variables: response rate, dollars given not including
//  match, dollars given including match, and amount change. We also consider
//  four subgroups: red county in a red state, blue county in a red state,
//  red county in a blue state, and blue county in a blue state. Lastly, 
//  we compare the control to the three treatments for matching ratio: 1:1, 2:1, and 3:1. 
mhtexp gave amount amountmat amountchange, subgroup(groupid) treatment(ratio)
