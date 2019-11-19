
%cleanCoalData2
%{
 FASTER than cleanCoalData

Following the steps used by Linn et al 2014 the data will be modified in
 the following ways:
 1. Values of monthly generation nature that are missing, negative, or two
 standard deviations above or below the monthly average across all years
 for the unit
 2. For boilers with multiple generators and/or generators with multiple
 boilers use aggregate heat input and generation output, average or sum
 device characteristics depending on type (done in BGGaggreggate fn)
 3. fuel quantity is converted to CO2 emissions using the emissions factor
 associated with that fuel type.

*** SHOULD I DELETE BEFORE AGGREGATION??
 %}

function [newStruct,excludedCounts,NumberNoCoal] = cleanCoalData2(generatorStruct,boilerStruct,unitStruct,assocStruct,groupOrPlant)
uniqPlants = unique([boilerStruct.PLANT_CODE]); 
allfieldsBoiler = fieldnames(boilerStruct);
monthContentfieldsBoiler = allfieldsBoiler(19:30); 
monthQuantfieldsBoiler=allfieldsBoiler(6:17);
allfieldsGen = fieldnames(generatorStruct);
monthfieldsGen = allfieldsGen(8:19); 
monthNames = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];%field names of monnth heat data is boile Struct
excluded = [];

% calculate CO2 emissions from quantity
%convert to vectors
fuelcodeVec = [boilerStruct.FUEL_CODE];
unitfuelcodeVec = [unitStruct.FUEL_CODE];
unitConversionVec = [unitStruct.CONVERSION];
conversionFactorVec = NaN(1,length(fuelcodeVec));

% cycle through the diff fuel types
for q = 1:length(unitfuelcodeVec) % makes a vector with matching indices of the conversion factor to use for each element in boiler fuel struct vec
    idx = strcmp(unitfuelcodeVec(q),char(fuelcodeVec));
    conversionFactorVec(idx==1)= unitConversionVec(q);
end
% if fuel code doesnt have a conversion factor... it is left as NaN
% multipy element-wise with vectors within each month
for w=1:12
    heatContentsVec = [boilerStruct.(monthContentfieldsBoiler{w})];
    quantVec=[boilerStruct.(monthQuantfieldsBoiler{w})];
    heatInputVec=heatContentsVec.*quantVec.*conversionFactorVec;
    
    %Make NaN <=0 or missing HEATING data (without deleting corresponding place 
    %in generation)
    heatInputVec(heatInputVec<=0)=NaN;
    
    % make NaN <=0 or missing GENERATION data (without deleting corresponding place 
    %in heating)
    generationVec = [generatorStruct.(monthfieldsGen{w})];
    generationVec(generationVec<=0)=NaN;
    
    %put back into struct
    heatInputArr = num2cell(heatInputVec);
    generationArr = num2cell(generationVec);
    [boilerStruct.(monthNames{w})]=heatInputArr{:}; 
    [generatorStruct.(monthfieldsGen{w})]=generationArr{:};
 
end

%{
% Old code: produces same result as above, but take x3 more time
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
        if b ==77
            disp(heatInput)
        end
    end 
end
%}


% If 'g' then do boiler groups...
% Make new struct with aggregates using BGaggregate function
% pre-allocate for speed...
if groupOrPlant == 'g'
    totalNumberGroups = length([assocStruct(:).assocs]);
    newStruct = struct('PLANT_CODE',{},'BOILER_ID',{},'GENERATOR_ID',{},'Emission',{},'Generation',{},'NAMEPLATE_RATING',{});
    newStruct(totalNumberGroups).Emission = [];

    finalStructIdx = 1;
    NumberNoCoal = 0;

    allowedFUELCODES = ["BIT" "LIG" "SC" "SUB" "WC"];

    for j=1:length([assocStruct.PLANT_CODE])
        plantID = assocStruct(j).PLANT_CODE;
        for p=1:length([assocStruct(j).assocs]) % how many groups of boilers at this plant. iterating over each group
            boilerIDs = assocStruct(j).assocs(p).Boils;
            generatorIDs = assocStruct(j).assocs(p).Gens;
            boilerIdxs1 = ([boilerStruct.PLANT_CODE]==plantID);
            actualIdx = find(boilerIdxs1==1);
            for bb =1:length(actualIdx) %for each boiler at the plant...
                if sum(sum(strcmp(char(boilerStruct(actualIdx(bb)).BOILER_ID),char(boilerIDs))))== 0 % if it is not in the list of boiler IDS
                   boilerIdxs1(actualIdx(bb)) =0;
                end
            end
            boilerIdxs=boilerIdxs1;
            
            generatorIdxs1 = ([generatorStruct.PLANT_CODE]==plantID);
            actualGenIdx = find(generatorIdxs1 ==1);
            for gg=1:length(actualGenIdx)
                if sum(sum(strcmp(char(generatorStruct(actualGenIdx(gg)).GENERATOR_ID),char(generatorIDs))))==0
                    generatorIdxs1(actualGenIdx(gg))=0;
                end
            end
            generatorIdxs=generatorIdxs1;
 
            %%HERE: eliminate if not one the boilerIDxs correspond to any of
            %%allowed fuel codes
            
            boilersFuels = fuelcodeVec(actualIdx);%pull out as a vec
            if sum(sum(ismember(categorical(boilersFuels),categorical(allowedFUELCODES)))) >= 1
                newStruct(finalStructIdx).NAMEPLATE_RATING = [generatorStruct(actualGenIdx).NAMEPLATE_RATING];
                newStruct(finalStructIdx).PLANT_CODE = assocStruct(j).PLANT_CODE;
                newStruct(finalStructIdx).BOILER_ID = assocStruct(j).assocs(p).Boils;
                newStruct(finalStructIdx).GENERATOR_ID = assocStruct(j).assocs(p).Gens;
            % loop through month fields to add
                for i = 1:12
                    boilerStructMonthVec = [boilerStruct.(monthNames{i})];
                    generatorStructMonthVec = [generatorStruct.(monthfieldsGen{i})];
                    totalMonthEmission =nansum(boilerStructMonthVec(boilerIdxs==1));
                    totalMonthGen = nansum(generatorStructMonthVec(generatorIdxs==1));
                    newStruct(finalStructIdx).Emission.(monthNames{i})= totalMonthEmission;
                    newStruct(finalStructIdx).Generation.(monthfieldsGen{i})=totalMonthGen;
                end
                finalStructIdx = finalStructIdx+1;
                disp(finalStructIdx)
            else
                NumberNoCoal = NumberNoCoal + 1;
                disp('c')
            end
        
        end

    end
end

if groupOrPlant == 'p'
    totalNumberGroups = length(uniqPlants);
    newStruct = struct('PLANT_CODE',{},'BOILER_ID',{},'GENERATOR_ID',{},'Emission',{},'Generation',{},'NAMEPLATE_RATING',{});
    newStruct(totalNumberGroups).Emission = [];

    finalStructIdx = 1;
    NumberNoCoal = 0;

    allowedFUELCODES = ["BIT" "LIG" "SC" "SUB" "WC"];
    for j=1:length(uniqPlants) % for each plant find monthly aggregate heat input

        boilerIdxs1 = ([boilerStruct.PLANT_CODE]==uniqPlants(j));
        actualIdx = find(boilerIdxs1==1);
        generatorIdxs1 = ([generatorStruct.PLANT_CODE]==uniqPlants(j));
        actualGenIdx = find(generatorIdxs1 ==1);
    
        boilersFuels = fuelcodeVec(actualIdx);%pull out as a vec
        if sum(sum(ismember(categorical(boilersFuels),categorical(allowedFUELCODES)))) >= 1
            newStruct(finalStructIdx).PLANT_CODE = uniqPlants(j); % change so this is just preserved from o.g. struct
            newStruct(finalStructIdx).BOILER_ID = [boilerStruct(actualIdx).BOILER_ID];
            newStruct(finalStructIdx).GENERATOR_ID = [generatorStruct(actualGenIdx).GENERATOR_ID];
            newStruct(finalStructIdx).NAMEPLATE_RATING = [generatorStruct(actualGenIdx).NAMEPLATE_RATING];
    % loop through month fields to add
            for i = 1:12
            totalMonthEmission = nansum([boilerStruct(actualIdx).(monthNames{i})]);
            totalMonthGen =nansum([generatorStruct(actualGenIdx).(monthfieldsGen{i})]);
            newStruct(finalStructIdx).Emission.(monthNames{i})= totalMonthEmission;
            newStruct(finalStructIdx).Generation.(monthfieldsGen{i})=totalMonthGen;
            end
            finalStructIdx = finalStructIdx+1;
            disp(finalStructIdx)
        else
            NumberNoCoal = NumberNoCoal + 1;
            disp('c')
        end
    end
end
%}

% Remove empty rows in struct away that were not filled bc boiler group was
% removed bc contained no coal or petroleum fuel.
%disp(totalNumberGroups);
removeRows = zeros(1,totalNumberGroups-finalStructIdx+1);
for r=1:length(removeRows)
    removeRows(r) = finalStructIdx;
    finalStructIdx =finalStructIdx+1;
end
%disp(removeRows)
newStruct(removeRows)=[];

% Make unique counts table of the fuels that were excluded because I did not
% have the conversion factor... (should I go back and have the
% quantity amount recorded when excluded?, also add number of unique
% plants/ BG groups, and/or plant ID names, also idk if these were eventualy excluded bc not coal or petroleum)

[C,ia,ic]=unique(excluded);
a_counts = accumarray(ic,1);
excludedCounts = [transpose(C),a_counts];
end


