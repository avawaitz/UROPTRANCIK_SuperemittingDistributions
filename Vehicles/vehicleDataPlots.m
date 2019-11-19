% vehicleDataPlots

function vehicleDataPlots(Title,datavalues,numberBinsLin,numberBinsLog,fracContrib) 
datavalues = datavalues(~isnan(datavalues));
%Shift datavalues for use in Log-lin plot
datavaluesShifted = datavalues + abs(min(datavalues)); %this makes the minimum zero

% Convert lognormal values to normal
disp(length(datavaluesShifted(datavaluesShifted<=0)))
normalizedDataVals = log(datavaluesShifted(datavaluesShifted>0)); % SHOULD BE DROPPING JUST ONE DATA POINT...

% Lognormal dist params
range_Lognormal = max(datavalues)- min(datavalues);
lognormalMean = mean(datavalues);
lognormalStd = std(datavalues);

% Normal dist params
lognormalMeanShift = mean(datavaluesShifted);
lognormalStdShift = std(datavaluesShifted);
mu = log(lognormalMeanShift^2/sqrt((lognormalStdShift^2)+lognormalMeanShift^2));
sigma = sqrt(log((lognormalStdShift^2/lognormalMeanShift^2)+1));
range_normal = max(normalizedDataVals)-min(normalizedDataVals);

%Making pdfs
xValsLognormal = (min(datavalues):0.1:max(datavalues)); %adjust step-size??
logNormalpdf = lognpdf(xValsLognormal,mu,sigma);
xValsNorm = (mu - 3*sigma:0.1:mu + 3*sigma); %adjust step-size??
normal_pdf = normpdf(xValsNorm,mu,sigma);

%Plot label with number of observations
frequency = length(datavalues); 
addpath /Users/avawaitz/Documents/MATLAB/MATLAB_UROPTRANCIK/brandtDeviceDataProcess
percentElems = ContributionofFractionElements(datavalues,fracContrib)*100;
rmpath /Users/avawaitz/Documents/MATLAB/MATLAB_UROPTRANCIK/brandtDeviceDataProcess
label = [num2str(frequency),' observations. About ',num2str(round(percentElems,1)),'% of vehicles contribute over ',num2str(100*fracContrib),'% of emissions.'];
dim = [.2 .6 .3 .35];

% Making grid of the two figures
figure1 = figure('Position',[700,500,900,350]);

% Lin Plot
addpath /Users/avawaitz/Documents/MATLAB/MATLAB_UROPTRANCIK/Coal
subaxis(1,2,1,'SpacingHoriz',0.05,'Margin',0.05, 'PaddingTop', 0.15, 'PaddingBottom', 0.15)
rmpath /Users/avawaitz/Documents/MATLAB/MATLAB_UROPTRANCIK/Coal
hold on
bin_width = range_Lognormal/numberBinsLin;
plot(xValsLognormal,logNormalpdf*bin_width)
histogram(datavalues,numberBinsLin,'Normalization','Probability')
xlim([min(datavalues),max(datavalues)]); %lognormalMean+3*lognormalStd
ylim([0 1]);
% plot formating
title([Title,' (Linear scale)']);
xlabel('Vehicle Tail Pipe Emissions (grams pollutant per Kg of fuel)')
ylabel('Frequency')


% Log lin plot
addpath /Users/avawaitz/Documents/MATLAB/MATLAB_UROPTRANCIK/Coal
subaxis(1,2,2)
rmpath /Users/avawaitz/Documents/MATLAB/MATLAB_UROPTRANCIK/Coal
hold on
bin_widthNorm = range_normal/numberBinsLog;
plot(xValsNorm,normal_pdf*bin_widthNorm)
histogram(normalizedDataVals,numberBinsLog,'Normalization','Probability')
% plot formating
title([Title,' (Log Linear scale)']);
xlabel('Vehicle Tail Pipe Emissions (grams pollutant per Kg of fuel)')
ylabel('Frequency')

annotation('textbox',dim,'String',label,'FitBoxToText','on')
hold off
%{
filename = Title;
filepath = char('/Users/avawaitz/Dropbox/AvaProject/Data/PersonalVehicles/Figures');
saveas(gcf,fullfile(filepath,filename),'png')
%}
end
