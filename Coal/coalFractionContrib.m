% coalFractionContrib.m
% right now I will have it call the calcHeatRates function...if this takes
% too long maybe later make it so you can also put in the result oif the
% calcHeatRates fn
function [fractionPlants,fractionCapacity] =coalFractionContrib(yearDataStruct,fraction)
%{
1) x% of plants contribute 50% of emissions: 
Sort by emission intensity, convert to just emissions per year, then find fraction
%}
emissionRatesStruct = calcHeatRates(yearDataStruct);
emissionRates = [emissionRatesStruct.EMISSION_RATE];

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

totCapacity = sum([yearDataStruct.NAMEPLATE_RATING]);
sortedCapacityStruct = yearDataStruct(sortOrder); %yearDataStruct sorted by emissionRates

%**NOTE: THOSE WITH BOILERS BUT NO ASSOCIATED GENERATORS HAVE HIGHEST
%EMISSIO INEFFICIENCY SO COUNTED FIRST BUT ALSO NO LISTED NAMEPLATE
%CAPACITY --> WHAT TO DO ABOUT THESE? WHAT ARE THEY??

for l=1:totNumElems
    elemSum2 = sum(sortedAnnualEmiss(1:l));
    sumCapacity = sum([sortedCapacityStruct(1:l).NAMEPLATE_RATING]);
    fractionCapacity = sumCapacity/totCapacity;
    if elemSum2 > totEmissions*fraction
        break
    end
end

end