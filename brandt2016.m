%% Importing compilation of device level emissions data into array
% Need to redo- I think this made a multidimensional array...only takes in numbers, need text also (should have 8
% columns also)
%brandt16comp = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','F:G');
%remember you need to include the whole route to the file
%% Extracting columnsç
% columns:
    % 1: study (ex: Allen2013)
[num1,study,raw1]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','A2:A26656');
    % 2: observation (integer #)
 [observation,text2,raw2]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','B2:B26656');
    % 3: idnew (Allen2013-1-PC-LOW-NA)
[num3,idnew,raw3]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','C2:C26656');
    % 4: source (PC, L, etc)
[num4,source,raw4]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','D2:D26656');
    % 5: sub-source (Low,INT, etc)
[num5,sub_source,raw5]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','E2:E26656');
    % 6: sub-sub-source (SEP, WH, etc)
[num6,sub_sub_source,raw6]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','F2:F26656');
    % 7: kgperday (#)
[kgperday,txt7,raw7]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','G2:G26656');
    % 8: type (CH4RATE for all)
[num8,type,raw8]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','F2:F26656');
%% Descriptive Stats
min_b16 = min(kgperday);
max_b16 = max(kgperday);
%% Linear scale plot

upperlim = max_b16; %set upper limit of histogram
h_b16_lin = histogram(kgperday,100,'BinLimits',[min_b16,upperlim]); %make linear histogram with limits
title('Brandt Compilation Device Level Emissions (Linear scale)');
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')
%% Log/lin scale plot
upperlim1 = ceil(log10(upperlim));
x = logspace(0,upperlim1,50); %make bin edges
hloglin = histogram(kgperday,x); %make histogram
set(gca,'xscale','log') % scale the x axis
title('Brandt Compilation Device Level Emissions (Log/lin scale)');
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')
%% Log/log scale plot
upperlim1 = ceil(log10(upperlim));
x = logspace(0,upperlim1,50); %make bin edges
hloglin = histogram(kgperday,x) %make histogram
set(gca,'xscale','log') % scale the x axis
set (gca, 'yscale','log') %scale the y axis
title('Brandt Compilation Device Level Emissions (Log/log scale)');
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')

%% Sorts the different source categories to see which have
%observations n > ##
uniqarr = uniquecount(source);
uniqarrN = uniqarr; %will be changed to only include source tags with n> # observations
for x = length(uniqarrN):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
    if uniqarrN{2,x} < 30 %##
        uniqarrN(:,x) = [];
    end
end
%this is an array of the unique sources and their frequency, if their
%frequency is greater than ##
disp(uniqarrN)


%% Bar graphs for individual sources
%First make vectors of all the source tags to be plotted
%inputs into plotting function: vector of values (source_val), source tag,
%upperlimit for x and y, type of x and y axes scale

%Source type being examined:
sourcetag = 'CV';  
idx = find(strcmp([source(:)],sourcetag)); %finds indices of elements with that source string in source arr
source_val = kgperday(idx); %extracts the emissions of those observations (at those indices)
idxuniqarr = find(ismember(uniqarr(1,:),sourcetag)); % index of that source in source array

% Linear scale plot
upperlim = max(source_val);%set upper limit of histogram
figure(1)
histogram(source_val, 100,'BinLimits',[min(source_val),max(source_val)]); %make linear histogram with limits
title(['Brandt ',sourcetag,' Device Emissions (Linear scale)']);
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')
label = [num2str(uniqarr{2,idxuniqarr}),' observations']; % prints number of observations for that source tag in text box
dim1 = [.75 .6 .3 .3]; %controls location of txtbox on figure
annotation('textbox',dim1,'String',label,'FitBoxToText','on'); %creates txtbox on figure

% Log/lin scale plot
upperlim2 = ceil(log10(max(source_val)));
lowerlim2 = ceil(log10(min(source_val)));
x = logspace(-2,upperlim2,50); %make bin edges
figure(2)
histogram(source_val,x); %make histogram
set(gca,'xscale','log') % scale the x axis
title(['Brandt ',sourcetag,' Device Emissions (Log/lin scale)']);
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')
dim2 = [.2 .6 .3 .3]; %controls location of txtbox on figure
annotation('textbox',dim2,'String',label,'FitBoxToText','on'); %creates txtbox on figure

% Log/log scale plot
upperlim3 = ceil(log10(max(source_val)));
lowerlim3 = floor(log10(min(source_val)));
x = logspace(-2,upperlim3,50); %make bin edges
figure(3)
histogram(source_val,x) %make histogram
set(gca,'xscale','log') % scale the x axis
set(gca, 'yscale','log')%scale the y axis
ylim([0.01 6]);
title(['Brandt ',sourcetag,' Device Emissions (Log/log scale)']);
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')
dim3 = [.2 .6 .3 .3]; %controls location of txtbox on figure
annotation('textbox',dim3,'String',label,'FitBoxToText','on'); %creates txtbox on figure
