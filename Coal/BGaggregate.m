%BGaggregate.m
% Testing find and calculate boiler and gen aggregates
function result = BGaggregate(assocStruct)
uniqPlants = unique([assocStruct.PLANT_CODE]); 
% attempting to pre-allocate result struct for speed:
result = struct('PLANT_CODE',{},'assocs',{});
result(length(uniqPlants)).PLANT_CODE = [];

for j=1:length(uniqPlants)
plantCodeKeys = find([assocStruct.PLANT_CODE] ==uniqPlants(j));
boilerList = [assocStruct(plantCodeKeys).BOILER_ID];

uniqBoilers = unique(boilerList);
combined(1).Boils = categorical(uniqBoilers(1));
uniqBoilerKeys1 = find([assocStruct.PLANT_CODE] ==uniqPlants(j) & [assocStruct.BOILER_ID]== uniqBoilers(1)); %%**
combined(1).Gens = unique([assocStruct(uniqBoilerKeys1).GENERATOR_ID]);
    for i =2:length(uniqBoilers)
        boiler =uniqBoilers(i); % maybe do at end of loop once all conglomerated
        %disp(uniqPlants(j))
        %disp(boiler)
        uniqBoilerKeys = find([assocStruct.PLANT_CODE] ==uniqPlants(j) & [assocStruct.BOILER_ID]== boiler);
        assocGens = unique([assocStruct(uniqBoilerKeys).GENERATOR_ID]);
        %disp(assocGens)
        %disp(uniqBoilerKeys)
        
        % Rather than adding on boilers: find assoc Gens for each unique
        % boiler then combine if they have assoc Gen in common
      b=0;
        % Q: Is there a function that does this?: out of group of vectors
        % combine all that overlapp...couldnt find one
        %Does keeping this inside of the uniqboilers loop so that only
        %comparing to those previously generated make it faster?
        for k=1:length(combined) % checking with all made previously (should check with combined not the independent
            if isempty(intersect(combined(k).Gens,assocGens))
                %nothing, just go to next k value
            else
                b=1;
                combined(k).Boils= union(categorical(boiler),combined(k).Boils);
                combined(k).Gens=union(assocGens,combined(k).Gens);
                %end for k loop, because if intersect with one wont with any
                %others bc we are making it incrementally
                break
            end
        end
        %if, after comparing with all k values and no intersection (so b
        %still equals zero, add to combine list as its own list
        if b==0
            %add to list anyways
            combined(k+1).Boils = categorical(boiler);
            combined(k+1).Gens=assocGens;
        end
    end
      % After running through all uniq boilers at plant we have the struct 
  % combined which has list of boiler and generator groups associated at a plant
  % idk what the best output format it, but rn im gonna try a nested struct
  % So it will be fields for all plant codes, within each plant code field
  % boiler groups and gen groups. Ex:
  % result.plantcode.Boils = ... 
  % result.plantcode.Boils = ...
  %So I have to add combined struct into result larger one with plant codes
  result(j).PLANT_CODE = uniqPlants(j);
  result(j).assocs = combined;
  % empty out combined so it can be re-used on next plant (just making into
  % empty cell array
  combined = {};
end
% returning also some stats on the amount of aggregation
% number of plants with boilers aggregated
% number of plants with gens aggregated
% number of plants with both
% average number of boilers in a group
% average number of generators in a group
end 
 
 