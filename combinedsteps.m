%general notes: 
% - make it so figures don't print out and just save while running so you don't have to go back and delete them all.
% - consider the zero values with Morgan
% - the source tags with just zero
% - Go back and edit/adjust individual graphs by calling them
% - how to insert them into latex in an efficient manner
% - check that there are 279 (93*3)


% For sourcetag distributions
datamtrix = downloaddata; %OR
%load('brandtdata','datamatrix');
sourceemissions = dataprepare(datamatrix);
sourceemissions = cell2mat(sourceemissions); %% OR
%load('brandtdata','sourceemissions');
  %uses it to get the emissions values for that tag
for p = 1:length(sourceemissions)
    tgidx = find(strcmp(sourceemissions(:,1),sourcetag)); %finds idx of the category tag
    catvalues = sourceemissions(tgidx,end);
    catvalues = catvalues{:};
    sourcetag = sourceemissions{p,1};
    plotdata(sourcetag,catvalues, 'none','none','all','SourcetagGraphs')
end

%For device category distributions
datamatrix = downloaddata; 
%load('brandtdata','datamatrix');
devicearr = devicecat;
devicearr = cell2mat(devicearr); %% OR
%load('brandtdata','devicearr');
for p = 1: length(devicearr)
    category = devicearr{p,1};
    tgidx = find(strcmp(devicearr(:,1),category)); %enter in category
    catvalues = devicearr(tgidx,end);
    catvalues = catvalues{:};
    plotdata(category,catvalues,'none','none','all','DevicecatGraphs')
end

%for Analyze Boston
datamatrixAB = downloadAB;
%OR load('ABdata','datamatrixAB');
[siteeui,outliers,xuplim,yuplim] = dataprepareAB(datamatrixAB,xuplimspec);
plotdata('Analyze Boston Site EUI (kBtu/sf)',siteeui,'none','none','all','AnalyzeBostonGraphs');
