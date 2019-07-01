% Downloads source tags and emissions from excel file from brandt 2016
function datamatrix = downloadbrandtdata
[~,source,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','D2:D26656');
[~,subsource,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','E2:E26656');
[~,subsubsource,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','F2:F26656');
[kgperday,~,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','G2:G26656');

kgperday = num2cell(kgperday); %makes double array into cell array s.t. can concatenate
datamatrix = [source subsource subsubsource kgperday]; %concatenates into 26655x4 cell array (source, kgperday)
%delete rows with NaN
for k = length(datamatrix):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
    nantest = isnan(datamatrix{k,4});
        if sum(nantest) == 1
           datamatrix(k,:) = [];
        end
end
save('brandtdatamatrix');
end
