% DOWNLOADING ANALYZE BOSTON DATA FROM Analyze Boston-unmodified.xlsx

function [datamatrixAB,ABdataStruct] = downloadAB
[~,propertyName,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/Buildings/AnalyzeBoston-unmodified.xlsx','rawData','B2:B1801');
[~,propertyType,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/Buildings/AnalyzeBoston-unmodified.xlsx','rawData','D2:D1801');
[~,propertyUses,~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/Buildings/AnalyzeBoston-unmodified.xlsx','rawData','K2:K1801');
[~,~,grossAreasqft]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/Buildings/AnalyzeBoston-unmodified.xlsx','rawData','G2:G1801');
[~,~,siteEnergykBtu]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/Buildings/AnalyzeBoston-unmodified.xlsx','rawData','O2:O1801');
[~,~,siteEUI]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/Buildings/AnalyzeBoston-unmodified.xlsx','rawData','H2:H1801');

datamatrixAB = [propertyName propertyType propertyUses grossAreasqft siteEnergykBtu siteEUI]; %concatenates into 26655x4 cell array (source, kgperday)


%delete rows with 'Not Available' (turned into NaN by xlsread) in siteEUI
for k = length(datamatrixAB):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
        if strcmp(datamatrixAB{k,end},'Not Available') ==1
           datamatrixAB(k,:) = [];
        end
end

% for struct take out text (Not Avalaible) entries first first
propertyName = propertyName(~ischar(siteEUI));
propertyType= propertyType(~ischar(siteEUI));
propertyUses=propertyUses(~ischar(siteEUI));
grossAreasqft=grossAreasqft(~ischar(siteEUI));
siteEnergykBtu=(~ischar(siteEUI));
siteEUI=siteEUI(~ischar(siteEUI));
ABdataStruct = struct('propertyName',num2cell(propertyName),'propertyType',num2cell(propertyType),'propertyUses',num2cell(propertyUses),'grossAreasqft', num2cell(grossAreasqft),'siteEnergykBtu', num2cell(siteEnergykBtu),'siteEUI',num2cell(siteEUI));

%save('ABdata','datamatrixAB');
end