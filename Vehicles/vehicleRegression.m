%vehicleRegression.m
% regress.datasetname.gasname
function regressionOutput = vehicleRegression(cleanedStruct,gasNames,DataSetName)
% If 'all' do all gases
if strcmp(gasNames,'all')
    gasNames = {'CO_GKGN107','HC_GKGN107','NO_GKGN107','NH3_GKGN107','NO2_GKGN107','NOX_GKGN107'};
end

%If certain gases specified just do it for those.

% Make matrix of outputs for the different gas types
Y = zeros(length(cleanedStruct),length(gasNames));
for b = 1:length(gasNames)
    Y(:,b) = [cleanedStruct.(gasNames{b})];
end
% Make matrix of variables
modelYear = [cleanedStruct.YEARN40].';
speed = [cleanedStruct.SPEEDN51].';
accel = [cleanedStruct.ACCELN63].';
X = [modelYear speed accel];
varNames = {'modelYear' 'speed' 'accel'};

% Regression and table formatting
regressResult = mvregress(X,Y);
regressionOutput = array2table(regressResult);
regressionOutput.Properties.VariableNames = gasNames;
regressionOutput.Properties.RowNames = varNames;

writetable(regressionOutput,'/Users/avawaitz/Dropbox/AvaProject/Data/PersonalVehicles/Regressions/PersonalVehicleRegressions.xlsx','Sheet',DataSetName,'WriteVariableNames',true,'WriteRowNames',true)
% returns table

end
