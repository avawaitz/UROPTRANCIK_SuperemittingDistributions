% DOWNLOADING ANALYZE BOSTON DATA FROM Analyze Boston-unmodified.xlsx

function datamatrixAB = downloadAB
[~,propertyName,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/AnalyzeBoston-unmodified.xlsx','rawData','B2:B1801');
[~,propertyType,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/AnalyzeBoston-unmodified.xlsx','rawData','D2:D1801');
[~,propertyUses,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/AnalyzeBoston-unmodified.xlsx','rawData','K2:K1801');
[~,~,grossAreasqft]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/AnalyzeBoston-unmodified.xlsx','rawData','O2:O1801');
[~,~,siteEnergykBtu]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/AnalyzeBoston-unmodified.xlsx','rawData','G2:G1801');
[~,~,siteEUI]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/AnalyzeBoston-unmodified.xlsx','rawData','H2:H1801');

datamatrixAB = [propertyName propertyType propertyUses grossAreasqft siteEnergykBtu siteEUI]; %concatenates into 26655x4 cell array (source, kgperday)

%delete rows with 'Not Available in siteEUI
for k = length(datamatrixAB):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
        if strcmp(datamatrixAB{k,end},'Not Available') == 1
           datamatrixAB(k,:) = [];
        end
end
save('ABdata','datamatrixAB');
end