%{
HOWTO_COAL

Import Generator and BoilerFuel and BOILER_GENERATOR excel files for each year as Tables
Import EmissionsUnitConversion excel file as table
Convert Tables to Structs with table2struct
assocStruct = BGaggregate(BOILER_GENERATORStruct)
yearDataStruct = cleanCoalData(generatorStruct,boilerStruct,unitStruct,assocStruct)
EmissionRatesStruct = calcHeatRates(yearDataStruct)
coalDataPlots(Title,[EmissionRatesStruct.EMISSION_RATE],numberBins)

*need to remove upper outliers
%}