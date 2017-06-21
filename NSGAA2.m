clc;
clear;
close all;

%% Problem Definition

CostFunction=@(x) MOP4(x);      % Cost Function

nVar=3;             % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin=-5;          % Lower Bound of Variables
VarMax= 5;          % Upper Bound of Variables

% Number of Objective Functions
nObj=numel(CostFunction(unifrnd(VarMin,VarMax,VarSize)));


%% NSGA-II Parameters

MaxIt=100;      % Maximum Number of Iterations

nPop=50;        % Population Size

pCrossover=0.7;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation=0.4;                          % Mutation Percentage
nMutation=round(pMutation*nPop);        % Number of Mutants

mu=0.02;                    % Mutation Rate

sigma=0.1*(VarMax-VarMin);  % Mutation Step Size


%% Initialization
people=struct('Index',0,'Position',[],'Cost',[],'CrowdingDistance',[],'Rank',[],'DominationSet',[],'DominatedCount',[]); 
pop=repmat(people,nPop,1);
popm=repmat(people,nMutation,1);


for i=1:nPop   
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);  
    pop(i).Cost=CostFunction(pop(i).Position); 
end

% Non-Dominated Sorting
[pop,F]=NonDominatedSorting2(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop,F]=SortPopulation(pop);


%% NSGA-II Main Loop

for it=1:MaxIt
    
    % Crossover
    popc=repmat(people,nCrossover,1);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        i2=randi([1 nPop]);
        [popc(2*k-1,1).Position ,popc(2*k).Position]=Crossover(pop(i1).Position,pop(i2).Position);
        % Evaluate Offsprings
        popc(2*k-1).Cost=CostFunction(popc(2*k-1).Position);
        popc(2*k).Cost=CostFunction(popc(2*k).Position);

    
    end
    
    % Mutation
    for k=1:nMutation     
        i=randi([1 nPop]);
        p=pop(i);   
        popm(k).Position=Mutate(p.Position,mu,sigma);    
        popm(k).Cost=CostFunction(popm(k).Position);
        
    end
    
    % Merge
    pop=[pop;popc;popm];%#ok
     
    % Non-Dominated Sorting
    [pop,F]=NonDominatedSorting2(pop);
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
    % Sort Population
    [pop,F]=SortPopulation(pop); %#ok
    % Truncate
    pop=pop(1:nPop);
    % Non-Dominated Sorting
    [pop,F]=NonDominatedSorting2(pop);
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
    % Sort Population
    [pop,F]=SortPopulation(pop);
    % Store F1
    F1=pop(F{1});
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    % Plot F1 Costs
    figure(1);
    PlotCosts(F1);
    
end

%% Results

