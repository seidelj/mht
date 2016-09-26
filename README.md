#Multiple Hypothesis Testing
Stata code for the procedure detailed in List, Shaikh, and Xu (2015)
[link](https://ideas.repec.org/p/feb/artefa/00402.html)

##Stata 14 Users
You can install mhtexp using Stata's ssc command.
```
ssc install mhtexp
```

##Manual Stata Install 
Download or clone this repository and make sure your current directory contains
* mhtexp.ado -- this initializes the stata comand "mhtexp" for usage from the command line or .do file
* lmhtexp.mlib -- the required mata functions that perform the computation
* mhtexp.sthlp -- OPTIONAL but recommended.  Usage: from stata command line
```
help mhtexp
```
If it is your first time running the code, ensure that Stata knows to look in lmhtexp.mlib

From the Stata command line
```
mata: mata mlib index
```
See mhtexp_examples.do for usage example OR from stata terminal type 'help mhtexp'


####Summary of contents

* mhtexp_examples.do do file with examples using the included data set.
* mhtexp.sthlp  Stata14 help file
* mhtexp.ado Contains the Stata command definition of mhtexp
* data.csv contains the data set used in the List, Shaikh, and Xu (2015)
* lmhtexp.mlib contains mata function required for the command; compiled using Stata14
* stata11/lmhtexp11.mlib contains the mata functions required for the command; compiled using Stata11.

####For older versions of Stata (<Stata14 and =>Stata11)
Stata versions that are atleast Stata11 can still use this command.  However, the bootstrap option is currently unavailable for older versions of Stata.  To use this command with an older version of Stata, first replace lmhtexp.mlib with lmhtexp11.mlib and remove or comment out line 2 in mhtexp.ado.

```
### Remove ###
version 14
```

The key difference in these two files (outside of how they are compiled), is the way in which ids are selected for the bootstrap sample.

In both cases the same random number generater is used to select random variates over [a, b].  While Stata14 has a built in method, Stata11 does not.
```
floor( (b-a+1) * runiform() + a)  // in lmhtexp11.mlib (Stata11)
runiformint(r, c, a, b) // in lmhtexp.mlib (Stata14)
```
The two methods both produce the desired result, but the matrix of IDs is slightly different accross these two methods.  Therefore, the bootstrapped statistics used to generate the outputted p-values will not be identical to the results presented in List, Shaikh, Xu 2015.

contact: seidelj@uchicago.edu
