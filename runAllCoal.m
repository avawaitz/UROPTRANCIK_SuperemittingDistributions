%runAllCoal
%{
Import Generator and BoilerFuel and BOILER_GENERATOR excel files for each year as Tables
Import UnitConversion as table
Convert Tables to Structs with table2struct
assocStruct = BGaggregate(BOILER_GENERATORStruct)
yearDataStruct = cleanCoalData(generatorStruct,boilerStruct,unitStruct,assocStruct)
HeatRates_Year = calcHeatRates(yearDataStruct)
coalDataPlots(Title,HeatRates_Year,numberBins)
%}
function [excludedCounts,NumberNoCoal] = runAllCoal(BGstruct,generatorStruct,boilerStruct,ConvStruct,yearString)
assocStruct = BGaggregate(BGstruct);
[yearDataStruct,excludedCounts,NumberNoCoal] = cleanCoalData(generatorStruct,boilerStruct,ConvStruct,assocStruct);
emissionRatesYear = calcHeatRates(yearDataStruct);
coalDataPlots(yearString,emissionRatesYear,100,50,0.5)
save(yearString,'assocStruct','yearDataStruct','excludedCounts','emissionRatesYear')
end
