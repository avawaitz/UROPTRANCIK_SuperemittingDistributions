% Makes list of boilers to exclude because they are not fired primarily
% with petroleum? coal?

function NonCoalList = excludeNonCoalFC(boilerStatStruct)
% if this plant-boiler primary fuel is not a member of list... then record
% plant and boiler ID

%make empty vectors to start
 excludePlantCode = [];
 excludeBoilerID = [];
% Coal and Syncoal and Petroleum Products (as listed in EIAF767
% instructional form
allowedFUELCODES = ["BIT" "LIG" "SC" "SUB" "WC" "DFO" "JF" "KER" "PC" "RFO" "WO"];

for i = 1:length(boilerStatStruct)
    primaryfuel = boilerStatStruct(i).PRIMARY_FUEL1;
    if ismember(categorical(primaryfuel),categorical(allowedFUELCODES)) == 0
        disp(primaryfuel)
        excludePlantCode = [excludePlantCode boilerStatStruct(i).PLANT_CODE];
        excludeBoilerID = [excludeBoilerID boilerStatStruct(i).BOILER_ID];
    end
end
NonCoalList.PLANT_CODE = excludePlantCode;
NonCoalList.BOILER_ID = excludeBoilerID;
        
end