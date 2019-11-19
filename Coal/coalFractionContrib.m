% coalFractionContrib.m
% right now I will have it call the calcHeatRates function...if this takes
% too long maybe later make it so you can also put in the result oif the
% calcHeatRates fn
function [fractionPlants,fractionNameCapacity,fractionGeneration] =coalFractionContrib(yearDataStruct,fraction)
%{
1) x% of plants contribute 50% of emissions: 
Sort by emission intensity, convert to just emissions per year, then find fraction
%}
emissionRatesStruct = calcHeatRates(yearDataStruct);
emissionRates = [emissionRatesStruct.EMISSION_RATE];
generationStruct = [yearDataStruct.Generation];

%find total annual emissions
monthNames = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
annualEmissionsVec = zeros(1,length(yearDataStruct));
for m = 1:length(yearDataStruct)   
    accumulatedValue = 0;
    for b =1:length(monthNames)
        accumulatedValue = accumulatedValue + yearDataStruct(m).Emission.(monthNames{b});
    end
    annualEmissionsVec(m) = accumulatedValue;
end

%sort annual emissions by emissions rate in descending order
[~,sortOrder]=sort(emissionRates,'descend');
sortedAnnualEmiss = annualEmissionsVec(sortOrder);

%Sum them up (whatever fractionPlants is when the loop breaks is the number
%we want to know
totNumElems = length(sortedAnnualEmiss); % make counted number of elements only those with contributing emissions, ** those with emissions but no generation are NaN so dropped to end of emissionr ate list so not counted, but actually these are the most inefficient...
totEmissions = sum(sortedAnnualEmiss);

for k=1:totNumElems
    elemSum = sum(sortedAnnualEmiss(1:k));
    fractionPlants = k/totNumElems;
    if elemSum > totEmissions*fraction
        break
    end
end

%{
2) x% of nameplate capacity (nameplate rating is in megawatts) contribute 50% of emissions:
 Sort by emission intensity, convert to just emissions per year, then find fraction 
(capacity/total capacity)
%}
%Sum them up **ADDING the CAPACITIES** (whatever fractionCap is when the loop breaks is the number
%we want to know

totNCapacity = sum([yearDataStruct.NAMEPLATE_RATING]);
sortedNCapacityStruct = yearDataStruct(sortOrder); %yearDataStruct sorted by emissionRates

for l=1:totNumElems
    elemSum2 = sum(sortedAnnualEmiss(1:l));
    sumNCapacity = sum([sortedNCapacityStruct(1:l).NAMEPLATE_RATING]);
    fractionNameCapacity = sumNCapacity/totNCapacity;
    if elemSum2 > totEmissions*fraction
        break
    end
end

%{
3) x% of total annual generated electricity, contribute 50% of emissions:
 Sort by emission intensity, convert to just emissions per year, then find fraction 
(summed generation/total generation)
%}

sortedGenerationStruct = generationStruct(sortOrder);
totGeneration = sum([sortedGenerationStruct(:).TOTAL_GENERATION]);

for m=1:totNumElems
    disp(m)
    elemSum3 = sum(sortedAnnualEmiss(1:m));
    sumGeneration = sum([sortedGenerationStruct(1:m).TOTAL_GENERATION]);
    fractionGeneration = sumGeneration/totGeneration;
    disp(sumGeneration)
    if elemSum3 > totEmissions*fraction
        break
    end
end

end