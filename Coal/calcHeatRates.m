% calcHeatRates
% calculates monthly emission rates (emissions per energgy output) for each BG group in each plant then
% averages to find average emission rates for each BG group in each plant,
% returning a struct: PLANT_CODE BOILER_ID GENERATOR_ID NAMEPLATE_RATING emission rate

function emissionRateStruct = calcHeatRates(yearDataStruct)
monthNames = fieldnames([yearDataStruct.Emission]);
monthNamesGen = fieldnames([yearDataStruct.Generation]);
emissionRateStruct = rmfield(yearDataStruct,{'Emission','Generation'});
for i=1:length(yearDataStruct)
    monthlyEmissionRates = zeros(1,12);
    for j= 1:12
        monthEmissions = yearDataStruct(i).Emission.(monthNames{j});
        monthGen = yearDataStruct(i).Generation.(monthNamesGen{j});
        emissionrate = monthEmissions/monthGen;
        monthlyEmissionRates(j)=emissionrate;
    end
    annualEmissionRate = nanmean(nonzeros(monthlyEmissionRates(~isinf(monthlyEmissionRates))));
    emissionRateStruct(i).EMISSION_RATE=annualEmissionRate;
end
end

        