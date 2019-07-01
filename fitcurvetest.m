% downloading data to test with (don't do this every time)
datamtrix = downloaddata;
devicearr = devicecat;
devicearr = cell2mat(devicearr);
%% Run this section separately to test
category =  'Compressor-seals-All';   % enter string name of category to test with (same as graph

% names in devicecatgraphs folder. NOTE: these graphs will look different
% because pdf was not used to generate those histographs

tgidx = find(strcmp(devicearr(:,1),category)); %enter in category
catvalues = devicearr(tgidx,end);
catvalues = catvalues{:};


% IN THE CODE BELOW, I switched btwn r = lognrnd generated data and r = the actual data
% (catvalues). With the fake data the fit works well. With the actual data
% it doesn't. Since these are running in the same function. And the fake
% data has the same mean and variance as the real data, I am not sure what
% the problem/difference is. THe only thing I can think of is that the real
% data is not close enough to lognormally distributed to get a good enough
% fit.


 %ANOTHER ISSUE is applying PDF normalization to the histogram seems to
 %distort the histogram so that it no longer appears normally distributed
 
%generate random data to mimic real data
m =  mean(catvalues);
v = var(catvalues);
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));%
%r = lognrnd(mu,sigma,1,10000); %should be normallydistributed when log
r = catvalues;

%take out zero values
for k = length(r):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
        if r(k) <= 0
           r(k) = [];
        end
end


logr = log(r);
maxlogr = max(logr);
minlogr = min(logr);
maxval = max(r);
upperlim = log10(maxval);
xlin = linspace(minlogr,maxlogr,50);
xlog = logspace(-5,upperlim,50);

% log of data on linear scale
figure
histogram(logr,xlin,'Normalization','pdf')
hold on

%fit distribution on lin scale
pd = fitdist(logr.','Normal');
x_values = minlogr:0.01:maxlogr;
y_values = pdf(pd,x_values);
plot(x_values,y_values);
set(gca,'xscale','lin')
hold off

% data on log scale
figure
h = histogram(r,xlog,'Normalization','pdf');
set(gca,'xscale','log')
hold on

%fit distribution on log scale
pd = fitdist(r.','lognormal');
x_values = 0.00001:0.0001:maxval;
y_values = pdf(pd,x_values);
plot(x_values,y_values);


