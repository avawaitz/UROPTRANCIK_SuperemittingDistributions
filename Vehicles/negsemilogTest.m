%% negsemilogTest
%Make some fake data
n = 1:20;
y = factorial(n);
y(2:2:end) = -y(2:2:end);
% Bad plot
plot(n,y,'o')
% Transform
ylog = sign(y).*log10(abs(y));
figure
plot(n,ylog,'o')
% Do nothing else to get just exponents.  Otherwise:
yt = get(gca,'YTick')';
set(gca,'YTickLabel',num2str(sign(yt).*10.^abs(yt)))
% Or, for scientific notation
set(gca,'YTickLabel',strcat('10^',cellstr(num2str(abs(yt)))))
%% other try 
% Do log10 but keep sign
xlog = sign(x).*log10(abs(x));
% Just to get axis limits
plot(xlog,y,'o')
% Get limits
lims = xlim;
wdth = diff(lims);
% Wrap negative data around to positive side
xlog(xlog<0) = xlog(xlog<0) + wdth;
% Plot
plot(xlog,y,'o')
% Mess with ticks
tck = get(gca,'XTick')';
% Shift those that were wrapped from negative to positive (above) back 
% to their original values
tck(tck>lims(2)) = tck(tck>lims(2)) - wdth;
% Convert to string, then remove any midpoint
tcklbl = num2str(tck);
tcklbl(tck==lims(2),:) = ' ';
% Update tick labels
set(gca,'XTickLabel',tcklbl)
%%
% make fake data
n = 1:20;
datavalues = factorial(n);
datavalues(2:2:end) = -datavalues(2:2:end);

% Convert lognormal values to normal
normalizedDataVals = sign(datavalues).*log(abs(datavalues));

% Lognormal dist params
range_Lognormal = max(datavalues)- min(datavalues);
lognormalMean = mean(datavalues);
lognormalStd = std(datavalues);

% Normal dist params
mu = log(lognormalMean^2/sqrt((lognormalStd^2)+lognormalMean^2));
sigma = sqrt(log((lognormalStd^2/lognormalMean^2)+1));
range_normal = max(normalizedDataVals)-min(normalizedDataVals);

%{
Making pdfs
xValsLognormal = (min(datavalues):0.1:max(datavalues));
logNormalpdf = lognpdf(xValsLognormal,mu,sigma);
xValsNorm = (mu - 3*sigma:0.1:mu + 3*sigma);
normal_pdf = normpdf(xValsNorm,mu,sigma);
%}
% Log lin plot
numberBinsLog = 30;
subaxis(1,2,2)
hold on
bin_widthNorm = range_normal/numberBinsLog;
%plot(xValsNorm,normal_pdf*bin_widthNorm)
histogram(normalizedDataVals,numberBinsLog,'Normalization','Probability')

