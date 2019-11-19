%vehicleCorrCoef.m
% returns matrix of the corr coefs and saves it as independent sheet in
% excel file
function corrCoefOutput = vehicleCorrCoef(cleanedStruct,varNames,DataSetName)
% If 'all' do all variables
if strcmp(varNames,'all')
    varNames = {'YEARN40','SPEEDN51','ACCELN63','CO_GKGN107','HC_GKGN107','NO_GKGN107','NH3_GKGN107','NO2_GKGN107','NOX_GKGN107'};
end

%If certain variables specified just do it for those.

 % Make matrix of of all variables
A = zeros(length(cleanedStruct),length(varNames));
for b = 1:length(varNames)
    A(:,b) = [cleanedStruct.(varNames{b})];
end

%{
Make matrix of all variables
modelYear = [cleanedStruct.YEARN40].';
speed = [cleanedStruct.SPEEDN51].';
accel = [cleanedStruct.ACCELN63].';
CO = [cleanedStruct.CO_GKGN107].';
HC = [cleanedStruct.HC_GKGN107].';
NO = [cleanedStruct.NO_GKGN107].';
NH3 = [cleanedStruct.NH3_GKGN107].';
NO2 = [cleanedStruct.NO2_GKGN107].';
NOX = [cleanedStruct.NOX_GKGN107].';

A = [modelYear speed accel CO HC NO NH3 NO2 NOX];
%}

% Correlation Coefficients and table formatting
corrCoefResult = corrcoef(A,'Rows','complete');
corrCoefOutput = array2table(corrCoefResult);
corrCoefOutput.Properties.VariableNames = varNames;
corrCoefOutput.Properties.RowNames = varNames;

writetable(corrCoefOutput,'/Users/avawaitz/Dropbox/AvaProject/Data/PersonalVehicles/CorrCoefs/PersonalVehicleCorrCoefs.xlsx','Sheet',DataSetName,'WriteVariableNames',true,'WriteRowNames',true)
% returns table

end
