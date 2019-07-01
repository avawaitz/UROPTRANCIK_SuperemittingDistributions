%%FindDatawithFewZeros
%returns in same structure as devicearr: the device category and emissions
%data values for those which hace <=n 0's data values. These zero data
%values are additionnally redefined to be very low positive numbers
%set by function parameter
function deviceArrFewZeros = FindDatawithFewZeros(devicearr,maxNumZeros,smallNum)
fewZeroDists = [];
for j=1:length(devicearr)
    device = devicearr{j,end};
    idx = device==0;
    if numZeros <= maxNumZeros
        fewZeroDists = [fewZeroDists,j];
    end 
end
deviceArrFewZeros = devicearr(fewZeroDists,:);
for k = 1:length(deviceArrFewZeros)
    deviceVals = deviceArrFewZeros{k,end};
    deviceVals(deviceVals==0)= smallNum;
    deviceArrFewZeros{k,end} = deviceVals;
end

% Count how many zeros re-defined?