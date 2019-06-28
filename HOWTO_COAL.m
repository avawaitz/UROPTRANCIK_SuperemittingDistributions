%{
HOWTO_COAL

Import Generator and BoilerFuel and BOILER_GENERATOR excel files for each year as Tables
Import UnitConversion as table
Convert Tables to Structs with table2struct
assocStruct = BGaggregate(BOILER_GENERATORStruct)
yearDataStruct = cleanCoalData(generatorStruct,boilerStruct,unitStruct,assocStruct)
HeatRates_Year = calcHeatRates(yearDataStruct)
coalDataPlots(Title,HeatRates_Year,numberBins)



QUANTITY:
Units: thousand tons
BIT 
LIG
SUB
WC
PC

Units:thousand barrels
DFO
JF
KER
RFO
WO

Units: thousand cubic feet
NG

HEAT CONTENT:
solids: Btu/lb
liquids: Btu/gallon
gases: Btu/cubic ft


*need to remove upper outliers
%}