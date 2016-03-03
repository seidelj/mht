program mhtexp
    version 14
    syntax varlist [if] [in], treatment(varlist) [ subgroup(varname) combo(string) exclude(name) only(name) bootstrap(integer 3000)]
    //args outcomes subgroupid treatment combo select

    if ("`combo'" != "" & "`combo'" != "pairwise" & "`combo'" != "treatmentcontrol"){
        display "INVALID combo choose either pairwise or treatmentcontrol"
        error
    }


    if ("`exclude'" == "") mata: excludemat = (.,.,.)
    else mata: excludemat = `exclude'
    if ("`only'" == "") mata: onlymat = (.,.,.)
    else mata: onlymat = `only'

    mata: Y = buildY("`varlist'")
    mata: D = buildD("`treatment'")
    mata: sub = buildsub("`subgroup'", D)
    mata: sizes = buildsizes(Y, D, sub)
    mata: combo = buildcombo("`combo'", sizes[3])
    mata: numpc = buildnumpc(combo)
    mata: select = buildselect(onlymat, excludemat, sizes[1], sizes[2], numpc)
    mata: results = seidelxu(Y, sub, D, combo, select, `bootstrap')
    mata: buildoutput("results", results)

    matlist results
end

mata:

    function buildY(string scalar outcomes){
        Y = st_data(., tokens(outcomes))
        return(Y)
    }
    function buildD(string scalar treatment){
        D = st_data(., tokens(treatment))
        return(D)
    }
    function buildsub(string scalar subgroup, real matrix D){
        if (subgroup == ""){
            sub = J(rows(D), 1,1)
        }else{
            sub = st_data(., (subgroup))
        }
        return(sub)
    }
    function buildsizes(real matrix Y, real matrix D, real matrix sub){
        numoc = cols(Y)
        numsub = colnonmissing(uniqrows(sub))
        numg = rows(uniqrows(D)) - 1

        return((numoc, numsub, numg))
    }
    function buildcombo(string scalar strcombo, real scalar numg){
        if (strcombo == "pairwise"){
    		combo = nchoosek((0::numg), 2)
    	}else{
    		combo = (J(numg,1,0), (1::numg))
    	}
        return(combo)
    }
    function buildnumpc(real matrix combo){
        return(rows(combo))
    }
    function buildselect(real matrix only, real matrix exclude, real scalar numoc, real scalar numsub, real scalar numpc){
        if (rownonmissing(only) != 0){
            select = mdarray((numoc, numsub, numpc),0)
            for (r = 1; r <= rows(only); r++){
                i = only[r, 1]
                j = only[r, 2]
                k = only[r, 3]
                put(1, select, (i,j,k))
            }
        }else{
            select = mdarray((numoc, numsub, numpc), 1)
        }
        if (rownonmissing(exclude) !=0){
            for (r=1; r <= rows(exclude); r++){
                i = exclude[r, 1]
                j = exclude[r, 2]
                k = exclude[r, 3]
                put(0, select, (i,j,k))
            }
        }
        return(select)
    }

end
