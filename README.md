#Multiple Hypothesis Testing
Stata code for the procedure detailed in List, Shaikh, and Xu (2015)

##In stata 
Make sure your current directory contains
* listetal2015.ado -- this initializes the stata comand "listetal2015" for usage from the command line or .do file
* llistetal2015.mlib -- the required mata functions that perform the computation

If it is your first time running the code, ensure that Stata knows to look in llistetal2015.mlib

From the Stata command line
```
mata: mata mlib index
```
See listetal2015_examples.do for usage example OR from stata terminal type 'help listetal2015'


####Summary of contents

data.csv contains the data set used in the List, Shaikh, and Xu (2015).

