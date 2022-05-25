%% Predicting RUL using LinearDegradationModel
load linTrainTables.mat
mdl = exponentialDegradationModel;
fit(mdl, linTrainTables, 'Time', 'Condition')

%% Predicting RUL
thres = 55;
estRUL = predictRUL(mdl, [10, 6.5], thres)
