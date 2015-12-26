
function [output] = listetal2015(Y,sub,D,combo,select)

% LISTETAL2015 considers the multiple hypothesis testing problem in
% experimental economics described in List, Shaikh, and Xu (2015).
%
%   Denote by n the number of units, by numoc the number of outcomes, by
%   numsub the number of subgroups, and by numpc the number of pairs of
%   treatment (control) groups of interest.
%
%   Among the input arguments of listetal2015: 
%   Y is an n by numoc matrix with the ijth element being the jth outcome 
%   of the ith unit;
%   sub is an n by 1 matrix with the ith element being the subgroup ID 
%   of the ith unit, where a subgroup ID is coded as an integer in [1,numsub];
%   D is an n by 1 matrix in which the ith element is the treatment status
%   of the ith unit (the control group is coded as 0);
%   combo is a numpc by 2 matrix, each row of which indicates a pairwise
%   comparison of interest;
%   select is a numoc by numsub by numpc matrix, where the ijkth element 
%   is equal to 1 if we are interested in the hypothesis for the ith outcome, 
%   the jth subgroup, and the kth pairwise comparison, and the ijkth element is 
%   equal to 0 otherwise.
%
%   The output argument "output" is a matrix with 10 columns:
%   columns 1-4 present the id's of the corresponding outcomes, subgroups, 
%   and treatment (control) groups;
%   the 5th column presents the absolute values of difference in sample means;
%   the 6th column presents the p-values based on the single testing procedure 
%   described in Remark 3.1 of List, Shaikh, and Xu (2015);
%   the 7th column presents the p-values based on the multiple testing procedure
%   described in Theorem 3.1 of List, Shaikh, and Xu (2015);
%   the 8th column presents the p-values based on the multiple testing procedure
%   described in Remark 3.7 of List, Shaikh, and Xu (2015);
%   the 9th column presents the p-values based on the Bonferroni method;
%   the 10th column presents the p-values based on the Holm's method.
%   
%   Please refer to List, Shaikh, and Xu (2015) for examples.

n = size(Y,1); % the number of units
B = 3000;        % the number of simulated samples
numoc = size(Y,2); % the number of outcomes
numsub = size(unique(sub),1)-(sum(sub==0)>0); % the number of subgroups
numg = size(unique(D),1)-1;  % the number of treatment groups (not including the control group)
numpc = size(combo,1); % the number of pairs of treatment (control) groups of interest

% compute the studentized differences in means for all the hypotheses based on the actual data

meanact = zeros(numoc,numsub,numg+1); % a matrix of sample means of the actual data for all the hypotheses
varact = zeros(numoc,numsub,numg+1); % a matrix of sample variances of the actual data for all the hypotheses
Nact = zeros(numoc,numsub,numg+1); % a matrix of sample sizes of the actual data for all the hypotheses

for i = 1:numoc
    for j = 1:numsub
        for k = 0:numg
    meanact(i,j,k+1) = mean(Y(sub==j & D==k,i));
    varact(i,j,k+1) = var(Y(sub==j & D==k,i));
    Nact(i,j,k+1) = size(Y(sub==j & D==k,i),1);
        end
    end
end
diffact = meanact(:,:,combo(:,1)+ones(numpc,1))-meanact(:,:,combo(:,2)+ones(numpc,1)); % a matrix of differences in sample means for all outcomes, subgroups, and pairwise comparisons based on actual data
abdiffact = abs(diffact); % a matrix of absolute differences in sample means for all outcomes, subgroups, and pairwise comparisons based on actual data
statsact = abdiffact./sqrt(varact(:,:,combo(:,1)+ones(numpc,1))./Nact(:,:,combo(:,1)+ones(numpc,1))...
    +varact(:,:,combo(:,2)+ones(numpc,1))./Nact(:,:,combo(:,2)+ones(numpc,1))); % a matrix of studentized absolute differences in sample means for all outcomes, subgroups, and pairwise comparisons based on actual data

% Construct bootstrap samples and compute the test statistics and the corresponding 1-p values for each simulated sample

rng default;
idboot = randi(n,n,B); % an n by B matrix of simulated samples of all the units with replacement
statsboot = zeros(B,numoc,numsub,numpc); % a matrix of the test statistics for all the simulated samples
meanboot = zeros(numoc,numsub,numg+1); % a matrix of sample means of a simulated sample for all the hypotheses
varboot = zeros(numoc,numsub,numg+1); % a matrix of sample variances of a simulated sample for all the hypotheses
Nboot = zeros(numoc,numsub,numg+1); % a matrix of sample sizes of a simulated sample for all the hypotheses

for i = 1:B
    Yboot = Y(idboot(:,i),:); % a matrix of all the outcomes for the ith simulated sample
    subboot = sub(idboot(:,i),:); % a matrix of all the subgroup id's for the ith simulated sample
    Dboot = D(idboot(:,i),:); % a matrix of all the treatment (control) status for the ith simulated sample
    for j = 1:numoc
        for k = 1:numsub
            for l = 0:numg
    meanboot(j,k,l+1) = mean(Yboot(subboot==k & Dboot==l,j));
    varboot(j,k,l+1) = var(Yboot(subboot==k & Dboot==l,j));
    Nboot(j,k,l+1) = size(Yboot(subboot==k & Dboot==l,j),1);
            end
        end
    end
    statsboot(i,:,:,:) = abs(meanboot(:,:,combo(:,1)+ones(numpc,1))-meanboot(:,:,combo(:,2)+ones(numpc,1))-diffact)./...
        sqrt(varboot(:,:,combo(:,1)+ones(numpc,1))./Nboot(:,:,combo(:,1)+ones(numpc,1))...
    +varboot(:,:,combo(:,2)+ones(numpc,1))./Nboot(:,:,combo(:,2)+ones(numpc,1)));
end

pact = zeros(numoc,numsub,numpc); % a matrix of 1-p values of the actual data
pboot = zeros(B,numoc,numsub,numpc); % a matrix of 1-p values of all the simulated data

for i = 1:numoc
    for j = 1:numsub
        for k = 1:numpc
            pact(i,j,k) = 1-(sum((statsboot(:,i,j,k)>=statsact(i,j,k)*ones(B,1))))/B;
            for l=1:B
                pboot(l,i,j,k) = 1-(sum((statsboot(:,i,j,k)>=statsboot(l,i,j,k)*ones(B,1))))/B;
            end
        end
    end
end

% calculate p-values based on single hypothesis testing

alphasin = zeros(numoc,numsub,numpc); % the smallest alpha's that reject the hypotheses based on the single testing procedure described in Remark 3.1

for i=1:numoc
    for j=1:numsub
        for k=1:numpc
            ptemp = pboot(:,i,j,k);
            sortp = sort(ptemp,'descend');
            q = find(pact(i,j,k)*ones(B,1)>=sortp,1)/B;
            if isempty(q)==0
            alphasin(i,j,k) = q;
            else
            alphasin(i,j,k) = 1;
            end
        end
    end
end

psin = alphasin; % p-values based on the single testing procedure described in Remark 3.1 of List, Shaikh, and Xu (2015)

% calculate p-values based on multiple hypothesis testing

nh = sum(sum(sum(select)));   % the number of hypotheses of interest
statsall = zeros(nh,8+B);     % columns 1-5 present the id's of the hypotheses, outcomes, subgroups, and treatment (control) groups;
                              % the 6th column shows the studentized differences in means for all the hypotheses based on the actual data
                              % the 7th column presents the p-values based on the single testing procedure described in Remark 3.1 of List, Shaikh, and Xu (2015);
                              % the 8th column presents the 1-p values based on the actual data;
                              % the subsequent columns present the corresponding 1-p values based on the simulated samples
counter = 1;                  % the loop counter

for i=1:numoc
    for j=1:numsub
        for k=1:numpc
            if select(i,j,k)==1;
            statsall(counter,:) = [counter i j combo(k,:) abdiffact(i,j,k) psin(i,j,k) pact(i,j,k) pboot(:,i,j,k)'];
            counter = counter+1;
            end
        end
    end
end

statsrank = sortrows(statsall,7); % rank the rows according to the p-values based on single hypothesis testing
alphamul = zeros(nh,1); % the smallest alpha's that reject the hypotheses based on Theorem 3.1
alphamulm = zeros(nh,1); % the smallest alpha's that reject the hypotheses based on Remark 3.7

for i=1:nh
    maxstats = max(statsrank(i:end,9:end),[],1); % the maximums of the 1-p values among all the remaning hypotheses for all the simulated samples
    sortmaxstats = sort(maxstats,2,'descend'); % sort "maxstats" in a descending order 
    q = find(statsrank(i,8)>=sortmaxstats,1)/B;
    if isempty(q)==0
        alphamul(i) = q;
    else    
        alphamul(i) = 1;
    end
    if i==1
        alphamulm(i) = alphamul(i);
    else
        sortmaxstatsm = zeros(1,B); % compute at each quantile the maximum of the critical values of all the "true" subsets of hypotheses
    for j=nh-i+1:-1:1
        subset = combntns(statsrank(i:end,1),j); % all the subsets of hypotheses with j elements
        sumcont = 0; % the total number of subsets of hypotheses with j elements that contradict any of the previously rejected hypotheses
        for k=1:size(subset,1)
            cont = 0; % cont=1 if any of the previously rejected hypotheses contradicts the current subset of hypotheses
        for l=1:i-1
            sameocsub = subset(k,ismember(statsall(subset(k,:),2:3),statsrank(l,2:3),'rows')==1); % the hypotheses in "subset(k,:)" with the same outcome and subgroup as the lth hypothesis
            tran = mat2cell(statsall(sameocsub,4:5),ones(1,size(sameocsub,2)),2); % this cell array presents all the sets of "connected" treatment (control) groups implied by "transitivity" under the null hypotheses in "sameocsub" 
            trantemp = tran;
            if size(sameocsub,2)<=1
                cont = 0;
                maxstatsm = max(statsall(subset(k,:),9:end),[],1); % the maximums of the 1-p values within the subset of hypotheses for all the simulated samples
                sortmaxstatsm = max(sortmaxstatsm,sort(maxstatsm,'descend'));
                break;
            else
                counter = 1;
                while size(tran,1)>size(trantemp,1) || counter==1
                tran = trantemp;
                trantemp = tran(1);
                counter = counter+1;
                for m=2:size(tran,1)
                    belong = 0; % the total number of rows of "transtemp" that "tran{m}" can be connected to by "transitivity"
                    for N=1:size(trantemp,1)
                    if unique([trantemp{N} tran{m}])<size(trantemp{N},2)+size(tran{m},2)
               trantemp{N} = unique([trantemp{N} tran{m}]);
               belong = belong+1;
               if N==size(trantemp,1) && belong==0
               trantemp = [trantemp;tran{m}];
               end
                    end
                    end
                end
                end
                for p=1:size(tran,1)
                    if sum(ismember(statsrank(l,4:5),tran{p,:}))==2 % the lth previously rejected hypotheses contract the current subset of hypotheses
                        cont = 1;
                        break;
                    end
                end
            end
            if cont==1
                break;
            end
        end
        sumcont = sumcont+cont;
        if cont==0
            maxstatsm = max(statsall(subset(k,:),9:end),[],1); 
            sortmaxstatsm = max(sortmaxstatsm,sort(maxstatsm,'descend'));
        end
        end
        if sumcont==0
            break; % If all the subsets of hypotheses with j elements do not contradict any of the previously rejected hypotheses, smaller subsets do not either.
        end
    end
    qm=find(statsrank(i,8)>=sortmaxstatsm,1)/B;
    if isempty(qm)==0
        alphamulm(i) = qm;
    else    
        alphamulm(i) = 1;
    end
    end
end
    
bon = min(statsrank(:,7)*nh,ones(nh,1)); % p-values based on the Bonferroni method
holm = min(statsrank(:,7).*(nh:-1:1)',ones(nh,1)); % p-values based on the Holm's method

output = sortrows([statsrank(:,1:7) alphamul alphamulm bon holm],1); % restore the order
output = output(:,2:end);
check = output(:,6)<=output(:,7) & output(:,7)>=output(:,8) & output(:,7)<=output(:,9) & output(:,7)<=output(:,10); % check if the results are what we should expect
output = dataset({output,'outcome','subgroup','treatment1','treatment2','diff_in_means','Remark3_1','Thm3_1','Remark3_7','Bonf','Holm'});


end