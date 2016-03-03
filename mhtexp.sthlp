{smcl}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "mhtexp##syntax"}{...}
{viewerjumpto "Description" "mhtexp##description"}{...}
{viewerjumpto "Options" "mhtexp##options"}{...}
{viewerjumpto "Remarks" "listetlal##remarks"}{...}
{viewerjumpto "Examples" "mhtexp##examples"}{...}
{title:Title}

{phang}
{bf:mhtexp} {hline 2} Stata command for the procedure detailed in List, Shaikh, and Xu (2015)


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:mhtexp}
{varlist}
{cmd:, } {it:treatment} [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth treatment(varlist)}}treatment status variables {it:varlist}{p_end}
{synopt:{opth subgroup(varname)}}group identifier variable {it:varname}{p_end}
{synopt:{opth combo(string)}}compare "treatmentcontrol" or "pairwise"; default is
    {cmd:combo("treatmentcontrol")}{p_end}
{synopt:{opth only(name)}} the numoc*numsub*numpc hypotheses to be tested{p_end}
{synopt:{opth exclude(name)}} the numoc*numsub*numpc hypotheses not to be tested{p_end}
{synopt:{opth boostrap(integer)}} the number of simulated samples to use{p_end}
{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mhtexp} testing procedure for multiple hypothesis testing that asymptotically controls
familywise error rate and is asymptotically balanced for outcomes specified via {varlist}{p_end}

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt treatment(varlist)} user provided variable containing treatment status of the observations; required.{p_end}

{phang}
{opt subgroup(varname)} user provided variable containing subgroup ids; optional.{p_end}

{phang}
{opt combo(string)} user provided string to specify the comparison between treatment and control.
{cmd:combo("pairwise")} will compare all pairwise comparisons across treatment and control.
The default is {cmd:combo("treatmentcontrol")}, compares each treatment to the control; optional
{p_end}

{phang}
{opt only(name)} N by 3 matrix specifying which hypothesis to be tested; optional.{p_end}

{phang}
{opt exclude(name)} N by 3 matrix specifying which hypothesis not to be tested; optional.{p_end}
{phang}
The matrix in either case should be defined where in each row, column 1 is the outcome, column 2 is the
subgroup and column 3 is the treatment-control comparison. Where...{p_end}
{phang3} 1 <= column 1 <= number of outcomes{p_end}
{phang3} 1 <= column 2 <= number of subgroups{p_end}
{phang3} 1 <= column 3 <= number of treatment-control comparisons{p_end}

{phang}
By default {cmd:mhtexp} will calculate all hypothesis based on the number of outcomes, subgroups and treatments provided by the user
in {it:varlist} {it:group(varname)} and {it:treatment(varname)}, respectively. In section 4.4 of List, Shaikh and Xu (2015) simultaniously consider
4 outcome variables, 4 subgroups and 3 treatment conditions, producting a table of 48 hypothesis test. However, there are cases in which you
may only be interested in certain outcome by subgroup by treatment hypothesis. use {opt only} or {opt exclude}.{p_end}


{phang}
{opt bootstrap(integer)} the number of simulated samples. the default is 3000,  but a larger number is recommended when there are a large number of hypotheses; optional.{p_end}

{marker remarks}{...}
{title:Remarks}

{pstd}
For detailed information on the procedure, see URL Multiple Hypothesis Testing in Experimental Economics.{p_end}

{pstd}
If you are running the command for the first time and receive an error message claiming certain functions are not found,
ie nchoosek(), make sure that lmhtexp.mlib exists in your current dir and enter the command{p_end}
{phang2}
{cmd:. mata: mata mlib index}{p_end}
{pstd}
Which tells Stata to look in lmhtexp.mlib for mata functions that are required to run the command{p_end}

{marker examples}{...}
{title:Examples}
{pstd}
Suppose a data set containing. You can access this dataset at github.com/seidelj/mht "data/data.csv"{p_end}

{phang} outcome variables {it:gave amount  amountchange}{p_end}
{phang} treatment variables {it: treatment ratio}{p_end}

{pstd}
Setup{p_end}
{phang} {cmd:. gen amountmat = amount * ratio }{p_end}
{phang} {cmd:. gen groupid = (redcty==1 & red0 == 1) + (redcty==0 & red0 == 1)*2 + (redcty==0 & red0 == 0)*3 + (redcty==1 & red0 == 0)*4}{p_end}
{phang} {cmd:. replace groupid = . if groupid == 0 }{p_end}

{pstd}
Example 1: Hypothesis testing with multiple outcomes{p_end}
{phang}{cmd:. mhtexp gave amount amountmat amountchange, treatment(treatment) }{p_end}

{pstd}
example 2: Hypothesis testing with multiple subgroups{p_end}
{phang}{cmd:. mhtexp gave, treatment(treatment) subgroup(groupid) }{p_end}

{pstd}
example 3: Hypothesis testing with multiple treatments{p_end}
{phang}{cmd:. mhtexp amount, treatment(ratio) }

{pstd}
Example 4: Hypothesis testing for all pairwise comparisons among the treatment and control groups{p_end}
{phang}{cmd:. mhtexp amount, treatment(ratio) combo("pairwise") }

{pstd}
Example 5: Hypothesis testing with multiple outcomes, subgroups and treatments{p_end}
{phang}{cmd:. mhtexp gave amount amountmat amountchange, subgroup(groupid) treatment(ratio) }{p_end}

{pstd}
Example 6: Now let's consider example 5, however we are only interested in the first outcome, subgroup and treatment-control comparison
hypothesis{p_end}
{pstd}
First an N by 3 matrix must be defined. For more on basic mata and matrices see {m1_first} {p_end}
{phang}{cmd:. mata: onlyHyp = (1,1,1) }{p_end}
{pstd}
Now we have a 1 by 3 matrix named onlyHyp to be passed to {opt only}{p_end}
{phang}{cmd:. mhtexp gave amount amountmat amountchange, subgroup(groupid) treatment(ratio) only(onlyHyp)}{p_end}

{pstd}
Example 7: Lets consider example 5 once more, but this time we are interested in all
but the last outcome, subgroup and treatment hypothesis.{p_end}
{pstd}
Create another N by 3 matrix. Recall, we have 4 outcomes, 4 subgroups and 3 treatment control comparisons.{p_end}
{phang}{cmd:. mata: excludeHyp = (4,4,3)}{p_end}
{phang}{cmd:. mhtexp gave amount amountmat amountchange, subgroup(groupid) treatment(ratio) exclude(excludeHyp)}{p_end}
