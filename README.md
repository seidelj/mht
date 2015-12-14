#Multiple Hypothesis Testing
Stata code for the procedure detailed in List, Shaikh, and Xu (2015)

##In stata 
Make sure your current directory contains
* listetal2015.ado -- this initializes the stata comand "listetal2015" for usage from the command line or .do file
* llistetal2015.mlib -- the required mata functions that perform the computation
* listetal2015.sthlp -- OPTIONAL but recommended.  Usage: from stata command line
```
help listetal2015
```
If it is your first time running the code, ensure that Stata knows to look in llistetal2015.mlib

From the Stata command line
```
mata: mata mlib index
```
See listetal2015_examples.do for usage example OR from stata terminal type 'help listetal2015'


####Summary of contents

* listetal2015_examples.do do file with examples using the included data set.
* listetal2015.sthlp  Stata14 help file
* listetal2015.ado Contains the Stata command definition of listetl2015
* data.csv contains the data set used in the List, Shaikh, and Xu (2015)
* llistetal2015.mlib contains mata function required for the command; compiled using Stata14
* stata11/llistetal2015_v11.mlib contains the mata functions required for the command; compiled using Stata11.

####For older versions of Stata (<Stata14 and =>Stata11)
Stata versions that are atleast Stata11 can still use this command.  Simply replace llistetal2015.mlib with llistetal2015_v11.mlib.

The key difference in these two files (outside of how they are compiled), is the way in which ids are selected for the bootstrap sample.

In both cases the same random number generater is used to select random variates over [a, b].  While Stata14 has a built in method, Stata11 does not.
```
floor( (b-a+1) * runiform() + a)  // in llistetelal2015_v11.mlib (Stata11)
runiformint(r, c, a, b) // in listetal2015.mlib (Stata14)
```
The two methods both produce the desired result, but the matrix of IDs is slightly different accross these two methods.  Therefore, the bootstrapped statistics used to generate the outputted p-values will not be identical to the results presented in List, Shaikh, Xu 2015.
