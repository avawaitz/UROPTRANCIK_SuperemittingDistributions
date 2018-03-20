%% Importing compilation of device level emissions data into array
% Need to redo- I think this made a multidimensional array...only takes in numbers, need text also (should have 8
% columns also)
%brandt16comp = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','F:G');
%remember you need to include the whole route to the file
%% Extracting columns
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
%% Linear scale plt

%%% NEED TO GO THROUGH AND DIVIDE BY DEVICE? --> function to return number
%%% in each


upperlim = 25000; %set upper limit of histogram
h_b16_lin = histogram(kgperday,100,'BinLimits',[min_b16,upperlim]); %make linear histogram with limits
title('Brandt Compilation Device Level Emissions (Linear scale)');
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')
%% Log/lin scale plot
upperlim1 = ceil(log10(upperlim));
x = logspace(0,upperlim1,50); %make bin edges
hloglin = histogram(kgperday,x); %make histogram
set(gca,'xscale','log') % scale the x axis
title('Brandt Compilation Device Level Emissions (Log/linkk scale)');
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