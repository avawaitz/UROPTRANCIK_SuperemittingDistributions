% vehicleDataClean

% eliminating invalid measurements
% maybe write in so that the invalid are counted for each gas type...
% Have to take out repeat cars: Look how they do it (Doesnt really say) probably averaging their results would be best approach
function [newStruct,numberFlagged,repeatsStruct] = vehicleDataClean(rawVehicleStruct,removeRepeats)
newStruct = rawVehicleStruct;
pollutantField = fieldnames(rawVehicleStruct);
%No specific Co/CO2 flags, all gases should be invlaid if these are
%disobeyed, in this dataset doesnt occur - check in other datasets if it
%does occur and if it does are all other gases given X's

%{
 Take out flags with vectors
logInd1 = strcmp({newStruct.HC_FLAGC1},'X');
disp(logInd1)
disp(newStruct(logInd1)).HC_GKGN107

logInd2 = [newStruct.NO_FLAGC1] == "X";
newStruct(logInd2).NO_GKGN107 = NaN;

logInd3 = [newStruct.NH3_FLAGC1] == "X";
newStruct(logInd3).NH3_GKGN107 = NaN;

logInd4 = [newStruct.NO2_FLAGC1] == "X";
newStruct(logInd4).NO2_GKGN107 = NaN;

numberFlagged = sum(logInd1)+sum(logInd2)+sum(logInd3)+sum(logInd4);
%}
%Take out flags with If and Loops
%
numberFlagged = 0;
for n=1:length(newStruct)
   if newStruct(n).HC_FLAGC1 == "X"
       newStruct(n).HC_GKGN107 = NaN;
       numberFlagged = numberFlagged +1;
   end
   if newStruct(n).NO_FLAGC1 == "X"
       newStruct(n).NO_GKGN107 = NaN;
       numberFlagged = numberFlagged +1;
   end
   if newStruct(n).NH3_FLAGC1 == "X"
       newStruct(n).NH3_GKGN107 = NaN;
       numberFlagged = numberFlagged +1;
   end
   if newStruct(n).NO2_FLAGC1 == "X"
       newStruct(n).NO2_GKGN107 = NaN;
       numberFlagged = numberFlagged +1;
   end
end
%}
% Take this out because  I think this is already done/present in the
% dataset - invalid measurements marked with X in flag fields
%{
% Too much error on CO/CO2 slope: error greater than +/-20% for %CO>1.0, and 0.2% for %CO<1.0
% Too much error on HC/CO2 slope....
% Too much...
% Excessive...
% Excessive error...
% %CO <-1% or >21% (all gases invalid)
    if newStruct(i).PERCENT_CON73 < -1 || newStruct(i).PERCENT_CON73 > 21
        newStruct(n).CO_GKGN107 = NaN;
        newStruct(n).HC_GKGN107 = NaN;
        newStruct(n).NO_GKGN107 = NaN;
        newStruct(n).NH3_GKGN107 = NaN;
        newStruct(n).NO2_GKGN107 = NaN;
        newStruct(n).NOX_GKGN107 = NaN;
    else
        % Reported HC <-1000ppm propane or >40000ppm -> HC "invalid"
        HCppm = newStruct(n).PERCENT_HCN74*10000;
        if HCppm <-1000 || HCppm > 40000
            newStruct(n).HC_GKGN107 = NaN;
        end
        % Reported NO<-700ppm or >7000ppm the NO "invalid"
        NOppm = newStruct(n).PERCENT_NON85*10000;
        if NOppm <-700 || NOppm >7000
            newStruct(n).NO_GKGN107 = NaN;
        end
        % Reported NH3 <-80ppm or >7000ppm. NH3 "invalid"
        NH3ppm = newStruct(n).PERCENTNH3N85*10000;
        if NH3ppm <-80 || NH3ppm >7000
            newStruct(n).NH3_GKGN107 = NaN;
        end
        % Reported NO2 <-500ppm or >7000ppm. NO2 "invalid"
        NO2ppm = newStruct(n).PERCENTNO2N85*10000;
        if NO2ppm<-500 || NO2ppm >7000
            newStruct(n).NO2_GKGN107 = NaN;
        end
    end
   %}   

if removeRepeats == 1
    plates = [rawVehicleStruct.(pollutantField{1})];
    [uniquePlates, ~, ind] = unique(plates); %// uniquePlates(ind) equals plates
    repeatedPlates = uniquePlates(histc(ind,1:max(ind))>1); %// result
    repeatsStruct = struct('uniquePlates',num2cell(repeatedPlates),pollutantField{42},[],pollutantField{43},[],pollutantField{44},[], pollutantField{45},[], pollutantField{46},[], pollutantField{47},[]);
    for k=1:length(repeatedPlates)
        structIdxs = find([rawVehicleStruct.(pollutantField{1})] == repeatedPlates(k));
        for m =42:47 % change if you also want to average speed and accel?
            field = pollutantField{m};
            avgEmissions = nanmean([newStruct(structIdxs).(field)]);
            repeatsStruct(k).(field)=[newStruct(structIdxs).(field)]; % add all values for that vehicle to repeat struct
            newStruct(structIdxs(1)).(field)= avgEmissions; % re-assign first of all the duplicates to be the average for that field
            for b=2:length(structIdxs) % make other occurences NaN... easier than deleting bc then indexing shifts
               newStruct(structIdxs(b)).(field) = NaN;
            end
        end
    end
end

end

