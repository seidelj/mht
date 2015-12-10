#Multiple Hypothesis Testing
Stata code for procedure detailed in List, Shaikh, Xu 2015

##In stata 
Make sure your current directory contains
* listetal2015.ado -- this initializes the stata comand "listetal2015" for usage from the command line or .do file
* llistetal2015.mlib -- the required mata functions that perform the computation

If it is your first time running the code, ensure that Stata knows to look in llisetetal.mlib

From the stata command line
```
mata: mata mlist index
```
See listetal_examples.do for usage example OR from stata terminal type 'help listetal'


####Summary of contents

data.csv contains the data set used in the List et al 2015 paper.

