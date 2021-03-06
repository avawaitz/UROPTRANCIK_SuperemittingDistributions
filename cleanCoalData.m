%cleanCoalData
%{
 Following the steps used by Linn et al 2014 the data will be modified in
 the following ways:
 1. Values of monthly generation nature that are missing, negative, ortwo
 standard deviations above or below the monthly average across all years
 for the unit
 2. For boilers with multiple generators and/or generators with multiple
 boilers use aggregate heat input and generation output, average or sum
 device characteristics depending on type (done in BGGaggreggate fn)
 3. fuel quantity is converted to CO2 emissions using the emissions factor
 associated with that fuel type.

*** SHOULD I DELETE BEFORE AGGREGATION??
 %}

function [newStruct,excludedCounts,NumberNoCoal] = cleanCoalData(generatorStruct,boilerStruct,unitStruct, assocStruct)
uniqPlants = unique([boilerStruct.PLANT_CODE]); 
allfieldsBoiler = fieldnames(boilerStruct);
monthContentfieldsBoiler = allfieldsBoiler(19:30); 
monthQuantfieldsBoiler=allfieldsBoiler(6:17);
allfieldsGen = fieldnames(generatorStruct);
monthfieldsGen = allfieldsGen(8:19); 
monthNames = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];%field names of monnth heat data is boile Struct
excluded = [];
% calculate CO2 emissions from quantity
for b=1:length(boilerStruct)
    fuelcode=boilerStruct(b).FUEL_CODE;
    if isundefined(fuelcode)
        ConversionFactor=NaN;
    else
    fuelcodeIdx=find([unitStruct.FUEL_CODE] == char(fuelcode));
        if sum(fuelcodeIdx) == 0
            ConversionFactor=NaN;
        else
            ConversionFactor = unitStruct(fuelcodeIdx).CONVERSION;
            if isnan(ConversionFactor)
                excluded = [excluded unitStruct(fuelcodeIdx).FUEL_CODE];
            end
        end
    end
    for w=1:12
        heatContent = boilerStruct(b).(monthContentfieldsBoiler{w});
        Quant=boilerStruct(b).(monthQuantfieldsBoiler{w});
        heatInput=heatContent*Quant*ConversionFactor;
        boilerStruct(b).(monthNames{w})=heatInput;
    end 
end

% Make NaN <=0 or missing HEATING data (without deleting corresponding place 
%in generation)
for h = 1:12
    negIdx1 = find([boilerStruct.(monthNames{h})]<=0);
    for m =1:length(negIdx1)
        boilerStruct(negIdx1(m)).(monthNames{h})= NaN;
    end
end
% make NaN <=0 or missing GENERATION data (without deleting corresponding place 
%in heating)
numberNaN =0;
for k = 1:length(monthfieldsGen)
    negIdx2 = find([generatorStruct.(monthfieldsGen{k})]<=0);
    for g =1:length(negIdx2)
        generatorStruct(negIdx2(g)).(monthfieldsGen{k})= NaN;
        numberNaN = numberNaN +1;
    end
end

% Make new struct with aggregates using BGaggregate function
% pre-allocate for speed...

totalNumberGroups = length([assocStruct(:).assocs]);
newStruct = struct('Heat',{},'Generation',{});
newStruct(totalNumberGroups).Heat = [];

finalStructIdx = 1;
NumberNoCoal = 0;

allowedFUELCODES = ["BIT" "LIG" "SC" "SUB" "WC"];

for j=1:length([assocStruct.PLANT_CODE])
    plantID = assocStruct(j).PLANT_CODE;
    for p=1:length([assocStruct(j).assocs]) % how many groups of boilers at this plant. iterating over each group
        boilerIDs = assocStruct(j).assocs(p).Boils;
        generatorIDs = assocStruct(j).assocs(p).Gens;
        boilerIdxs = find([boilerStruct.PLANT_CODE]== plantID & ismember(categorical([boilerStruct.BOILER_ID]),boilerIDs));
        generatorIdxs = find([generatorStruct.PLANT_CODE]== plantID & ismember([generatorStruct.GENERATOR_ID],generatorIDs));
        %%HERE: eliminate if not of the boilerIDxs correspond to ay of
        %%allowed fuel codes
        boilersFuels = [boilerStruct(boilerIdxs).FUEL_CODE];
        if sum(ismember(categorical(boilersFuels),categorical(allowedFUELCODES))) >= 1
            % issue possibly with pre-allocation...?
         % loop through month fields to add
            for i = 1:12
            totalMonthHeat =nansum([boilerStruct(boilerIdxs).(monthNames{i})]);
            totalMonthGen = nansum([generatorStruct(generatorIdxs).(monthfieldsGen{i})]);
            %disp([generatorStruct(generatorIdxs).(monthfieldsGen{i})])
            %disp(size([generatorStruct(generatorIdxs).(monthfieldsGen{i})]))
            newStruct(finalStructIdx).Heat.(monthNames{i})= totalMonthHeat;
            newStruct(finalStructIdx).Generation.(monthNames{i})=totalMonthGen;
            end
            finalStructIdx = finalStructIdx+1;
        else
            NumberNoCoal = NumberNoCoal + 1;
            %disp(boilersFuels)
        end
        
    end

end
%{
for j=1:length(uniqPlants) % for each plant find montlhy aggregate heat input
    boilerplantcodeKeys = find([boilerStruct.PLANT_CODE] ==uniqPlants(j));
    generatorplantcodeKeys =find([generatorStruct.PLANT_CODE]==uniqPlants(j));
    newStruct(j).PlantID = uniqPlants(j);
    % loop through month fields to add
     for i = 1:12
         totalMonthHeat = nansum([boilerStruct(boilerplantcodeKeys).(monthNames{i})]);
         totalMonthGen =nansum([generatorStruct(generatorplantcodeKeys).(monthfieldsGen{i})]);
         newStruct(j).Heat.(monthNames{i})= totalMonthHeat;
         newStruct(j).Generation.(monthNames{i})=totalMonthGen;
     end
end
%}

% Remove empty rows in struct away that were not filled bc boiler group was
% removed bc contained no coal or petroleum fuel.
removeRows = zeros(1,totalNumberGroups-finalStructIdx+1);
for r=1:length(removeRows)
    removeRows(r) = finalStructIdx;
    finalStructIdx =finalStructIdx+1;
end
newStruct(removeRows)=[];

% Make unique counts table of the fuels that were excluded because I did not
% have the conversion factor... (should I go back and have the
% quantity amount recorded when excluded?, also add number of unique
% plants/ BG groups, and/or plant ID names, also idk if these were eventualy excluded bc not coal or petroleum)

[C,ia,ic]=unique(excluded);
a_counts = accumarray(ic,1);
excludedCounts = [transpose(C),a_counts];
end


