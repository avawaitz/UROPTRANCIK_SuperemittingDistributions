% calcHeatRates
% cacluates monthly heat rates for each BG group in each plant then
% averages to find average heat rates for each BG group in each plant,
% returning just a total list of heat rates
% ** If we are converting to CO2 emissions need to maintain the fuel code
% of the dominant fuel source in the yearDataStruct
function annualAvgHeatRates1 = calcHeatRates(yearDataStruct)
monthNames = fieldnames([yearDataStruct.Heat]);
annualAvgHeatRates = zeros(1,length(yearDataStruct));
for i=1:length(yearDataStruct)
    monthlyHeatRates = zeros(1,12);
    for j= 1:12
        monthHeat = yearDataStruct(i).Heat.(monthNames{j});
        monthGen = yearDataStruct(i).Generation.(monthNames{j});
        heatrate = monthHeat/monthGen;
        monthlyHeatRates(j)=heatrate;
    end
    annualHeatRate = nanmean(nonzeros(monthlyHeatRates(~isinf(monthlyHeatRates))));
    annualAvgHeatRates(i)=annualHeatRate;
end
annualAvgHeatRates1=annualAvgHeatRates(~isnan(annualAvgHeatRates));
end

        