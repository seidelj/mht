data = importdata('data.csv');
data = data.data; % read the dataset

%% Hypothesis testing with multiple outcomes: 

% We consider four outcome variables: response rate, dollars given not including
% match, dollars given including match, and amount change.
amountmat = data(:,1).*data(:,10);             % dollars raised per letter including match
Y = [data(:,[12,1]) amountmat data(:,35)];     % the matrix of outcomes
D = data(:,8);                                 % the vector of treatment statuses
sub = ones(size(D,1),1);                       % the subgroup ID's
numoc = size(Y,2);                             % the number of outcomes
numsub = size(unique(sub),1);                  % the number of subgroups
numg = size(unique(D),1)-1;                    % the number of treatment groups (not including the control group)
combo = [zeros(numg,1) (1:numg)'];             % We compare each treatment to the control.
numpc =size(combo,1);                          % the number of pairs of treatment (control) groups of interest
select = ones(numoc,numsub,numpc);             % We are interested in all the numoc*numsub*numpc hypotheses.
[example1] = listetal2015(Y,sub,D,combo,select)
%% Hypothesis testing with multiple subgroups: 

% We consider four subgroups: red county in a red state, blue county in a red state,
% red county in a blue state, and blue county in a blue state. We focus on
% the outcome response rate.
Y = data(:,12);    % the vector of outcomes
D = data(:,8);    % the vector of treatment status
sub = (data(:,17)==1 & data(:,32)==1)+(data(:,17)==0 & data(:,32)==1)*2....
    +(data(:,17)==0 & data(:,32)==0)*3+(data(:,17)==1 & data(:,32)==0)*4; % subgroup id's, where sub=0 indicates missing subgroup information
numoc = size(Y,2);                             % the number of outcomes
numsub = size(unique(sub),1)-(sum(sub==0)>0);  % the number of subgroups
numg = size(unique(D),1)-1;                    % the number of treatment groups (not including the control group)
combo = [zeros(numg,1) (1:numg)'];             % We compare each treatment to the control.
numpc = size(combo,1);                         % the number of pairs of treatment (control) groups of interest
select = ones(numoc,numsub,numpc);             % We are interested in all the numoc*numsub*numpc hypotheses.
[example2] = listetal2015(Y,sub,D,combo,select)
%% Hypothesis testing with multiple treatments: 

% We consider the three treatments for match ratio: 1:1, 2:1, and 3:1. We focus on the
% outcome dollars given not including match.
Y = data(:,1);    % the vector of outcomes
D = data(:,10);   % Treatment (control) status
sub = ones(size(D,1),1);   % the subgroup ID's
numoc = size(Y,2);                             % the number of outcomes
numsub = size(unique(sub),1);                  % the number of subgroups
numg = size(unique(D),1)-1;                    % the number of treatment groups (not including the control group)

% compare each treatment group to the control
combo = [zeros(numg,1) (1:numg)'];             % We compare each treatment to the control.
numpc = size(combo,1);                         % the number of pairs of treatment (control) groups of interest
select = ones(numoc,numsub,numpc);             % We are interested in all the numoc*numsub*numpc hypotheses.
[example3] = listetal2015(Y,sub,D,combo,select)

% all pairwise comparisons among the treatment and control groups
combo = combntns(0:numg,2);                    % We consider all the pairwise comparisons across the treatment and control groups.
numpc = size(combo,1);                         % the number of pairs of treatment (control) groups of interest
select = ones(numoc,numsub,numpc);             % We are interested in all the numoc*numsub*numpc hypotheses.
[example4] = listetal2015(Y,sub,D,combo,select)
%% Hypothesis testing with multiple outcomes, subgroups, treatments: 

% We consider four outcome variables: response rate, dollars given not including
% match, dollars given including match, and amount change. We also consider
% four subgroups: red county in a red state, blue county in a red state,
% red county in a blue state, and blue county in a blue state. Lastly, 
% we compare the control to the three treatments for matching ratio: 1:1, 2:1, and 3:1. 
amountmat = data(:,1).*data(:,10);             % dollars raised per letter including match
Y = [data(:,[12,1]) amountmat data(:,35)];     % the matrix of outcomes
D = data(:,10);                                % treatment (control) status
sub = (data(:,17)==1 & data(:,32)==1)+(data(:,17)==0 & data(:,32)==1)*2....
    +(data(:,17)==0 & data(:,32)==0)*3+(data(:,17)==1 & data(:,32)==0)*4; % subgroup id's, where sub=0 indicates missing subgroup information
numoc = size(Y,2);                             % the number of outcomes
numsub = size(unique(sub),1)-(sum(sub==0)>0);  % the number of subgroups
numg = size(unique(D),1)-1;                    % the number of treatment groups (not including the control group)
combo = [zeros(numg,1) (1:numg)'];             % We compare each treatment to the control.
numpc = size(combo,1);                         % the number of pairs of treatment (control) groups of interest
select = ones(numoc,numsub,numpc);             % We are interested in all the numoc*numsub*numpc hypotheses.
[example5] = listetal2015(Y,sub,D,combo,select)
