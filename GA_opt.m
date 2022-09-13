temp_iter = [];

% Set nondefault solver options
options2 = optimoptions("ga","Display","iter","PlotFcn","gaplotbestindiv", ...
    "MaxGenerations",5,"PopulationSize",5);

% Solve
[solution,objectiveValue] = ga(@objectiveFcnSim_ATJP,nVar,[],[],[],[],...
    zeros(nVar,1),[],[],[],options2);

% Clear variables
clearvars options2