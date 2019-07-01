%% HOW TO: Brandt Device Data Processing Steps
%{ 
1. datamatrix = downloadbbrandtdata OR
  load brandtdatamatrix.mat
2. devicearr = devicecat(datamtrix/brandtdatamatrix)
3. devicearrFewZeros = FindDatawithFewZeros(devicearr,maxNumZeros,smallNum)
4. PLOT ALL:

for p = 1: length(devicearrFewZeros)
    category = devicearrFewZeros{p,1};
    catvalues = devicearrFewZeros(p,end);
    catvalues = catvalues{:};
    newPlottingFn(category,catvalues,numberBins,fracContrib)  
end


5. PLOT SINGULAR
    Find index # corresponding to the category you want to plot. Enter is at
    % # sign
plotCategory = devicearr{#,1};
catvalues = devicearr(#,end);
catvalues = catvalues{:};
newPlottingFn(plotCategory,catvalues,numberBins,fracContrib) 

%}    