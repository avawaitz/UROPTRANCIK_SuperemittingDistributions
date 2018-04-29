% downloading data to test with (don't do this every time)
datamtrix = downloaddata;
devicearr = devicecat;
devicearr = cell2mat(devicearr);
%% Run this section separately to test
category =  'Tanks-and-hatches-Unspecified';   % enter string name of category to test with (same as graph

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

logr = log(r);
maxlogr = max(logr);
maxval = max(r);
upperlim = ceil(log10(maxval));
xlin = linspace(0,maxlogr,50);
xlog = logspace(-3,upperlim,50);

% log of data on linear scale
figure
histogram(logr,xlin,'Normalization','pdf')
set(gca,'xscale','lin')

%take out zero values
for k = length(r):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
        if r(k) <= 0
           r(k) = [];
        end
end

% data on log scale
figure
h = histogram(r,xlog,'Normalization','pdf');
set(gca,'xscale','log')
hold on

%fit distribution
pd = fitdist(r.','lognormal');
x_values = 0.001:0.01:maxval;
y_values = pdf(pd,x_values);
plot(x_values,y_values);

