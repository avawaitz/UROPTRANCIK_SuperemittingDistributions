%% Importing Site EUI data into array
ab_siteeui = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/AnalyzeBoston-unmodified.xlsx','rawData','H2:H1801');

%% Descriptive Statistics
min_ab = min(ab_siteeui);
max_ab = max(ab_siteeui);
%% Linear Plot
upperlim = 1000; %set upper limit of histogram
h = histogram(ab_siteeui,100,'BinLimits',[min_ab,upperlim]); %make linear histogram with limits
%[freq, EDGES] = histcounts(ab_siteeui,'BinLimits',[min_ab,400]);
%figure, bar()
title('Analyze Boston Building Energy Intensity (linear scale)');
xlabel('Site EUI (kBtu/sf)')
ylabel('Frequency')
%% Log/lin scale
upperlim1 = ceil(log10(upperlim));
x = logspace(0,upperlim1,50); %make bin edges
hloglin = histogram(ab_siteeui,x); %make histogram
set(gca,'xscale','log') % scale the x axis
title('Analyze Boston Building Energy Intensity (Log/linear scale)');
xlabel('Site EUI (kBtu/sf)')
ylabel('Frequency')
%% Log/log scale
upperlim2 = log10(upperlim);
x = logspace(0,upperlim2,50); %make bin edges
hloglin = histogram(ab_siteeui,x); %make histogram
set(gca,'xscale','log'); % scale the x axis
set(gca,'yscale','log') % scale the y axis
title('Analyze Boston Building Energy Intensity (Log/log scale)');
xlabel('Site EUI (kBtu/sf)')
ylabel('Frequency')