#Multiple Hypothesis Testing
Stata code for procedure detailed in List, Shaikh, Xu 2015

##In stata 
Make sure your current directory contains
* listetal.ado -- this initializes the stata comand "listetal" for usage from the command line or do file
* llistetal.mlib -- the required mata functions that perform the computation

If it is your first time running the code, ensure that mata knows to look in llisetetal.mlib

From the stata command line
```
mata: mata mlist index
```
See listetal_examples.do for usage example OR from stata terminal type 'help listetal'


####Summary of contents

data.csv contains the data set used in the List et al 2015 paper.

