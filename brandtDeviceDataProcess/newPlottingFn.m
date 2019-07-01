%newPlottingFn

function newPlottingFn(category,datavalues,numberBins,fracContrib) 

% Convert lognormal values to normal
normalizedDataVals = log(datavalues);

% Lognormal dist params
range_Lognormal = max(datavalues)- min(datavalues);
lognormalMean = mean(datavalues);
lognormalStd = std(datavalues);

% Normal dist params
mu = log(lognormalMean^2/sqrt((lognormalStd^2)+lognormalMean^2));
sigma = sqrt(log((lognormalStd^2/lognormalMean^2)+1));
range_normal = max(normalizedDataVals)-min(normalizedDataVals);

%Making pdfs
xValsLognormal = (min(datavalues):0.1:max(datavalues));
logNormalpdf = lognpdf(xValsLognormal,mu,sigma);
xValsNorm = (mu - 3*sigma:0.1:mu + 3*sigma);
normal_pdf = normpdf(xValsNorm,mu,sigma);

%Plot label with number of observations
frequency = length(datavalues); 
percentElems = ContributionofFractionElements(datavalues,fracContrib)*100;
label = [num2str(frequency),' observations. About ',num2str(round(percentElems,1)),'% of devices contribute over ',num2str(100*fracContrib),'% of emissions.'];
dim = [.5 .6 .3 .35];

% Making grid of the two figures
figure1 = figure('Position',[700,500,900,350]);

% Lin Plot
subaxis(1,2,1, 'SpacingHoriz',0.05,'Margin',0.05, 'PaddingTop', 0.15, 'PaddingBottom', 0.15)
hold on
bin_width = range_Lognormal/numberBins;
plot(xValsLognormal,logNormalpdf*bin_width)
histogram(datavalues,numberBins,'Normalization','Probability')
xlim([0,lognormalMean+6*lognormalStd]);
% plot formating
title(['Brandt ',category,' Emissions']);
xlabel('Emissions rate (kgCH4/day)')
ylabel('Frequency')

% "Normalized" plot
subaxis(1,2,2)
hold on
bin_widthNorm = range_normal/numberBins;
plot(xValsNorm,normal_pdf*bin_widthNorm)
histogram(normalizedDataVals,numberBins,'Normalization','Probability')
% plot formating
title(['Brandt ',category,' Log(Emissions)']);
xlabel('Log(Emissions rate) (kgCH4/day)')
ylabel('Frequency')
annotation('textbox',dim,'String',label,'FitBoxToText','on')
hold off

filename = category;
filepath = char('/Users/avawaitz/Dropbox/AvaProject/Brandt_Latex/DeviceCatGraphs2');
saveas(gcf,fullfile(filepath,filename),'png')
end


