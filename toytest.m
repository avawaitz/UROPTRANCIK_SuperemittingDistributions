% This script tests issues with generating a plotting skewed distributions
% using a toy example.

clear
close all

% Step 1: Generate dateset drawn from a normal distribution:
number_of_draws = 10000;
normal_mean = 1;
normal_sigma = 0.5;
normal_data = normrnd(normal_mean,normal_sigma,[1,number_of_draws]);
range_normal = max(normal_data)-min(normal_data);
[lognormal_mean,lognormal_variance] = lognstat(normal_mean,normal_sigma);
lognormal_sigma = sqrt(lognormal_variance);

% Step 2: Generate PDF for normal random data:
normal_x = (normal_mean - 3*normal_sigma:0.1:normal_mean + 3*normal_sigma);
normal_pdf = normpdf(normal_x,normal_mean,normal_sigma);

% Step 3: Transform dataset into lognormal distribution:
lognormal_data = exp(normal_data);
range_lognormal = max(lognormal_data) - min(lognormal_data);

% Step 4: Generate PDF for lognormal data:
lognormal_pdf = lognpdf(exp(normal_x),normal_mean,normal_sigma);

% Step 5: Plot normal data example:
number_of_bins = 50;
bin_width = range_normal/number_of_bins;
figure
hold on
plot(normal_x,normal_pdf*bin_width)
histogram(normal_data,number_of_bins,'Normalization','Probability')
hold off

% Step 6: Plot lognormal data example:
figure
hold on
bin_width = range_lognormal/number_of_bins;
plot(exp(normal_x),lognormal_pdf*bin_width)
histogram(lognormal_data,number_of_bins,'Normalization','Probability')
xlim([0,lognormal_mean+6*lognormal_sigma]);
hold off



%% Test Morgan's method with catvalues
normal_mean = mean(log(catvalues));
normal_sigma = std(log(catvalues));
normal_data = log(catvalues);
range_normal = max(normal_data)-min(normal_data);
[lognormal_mean,lognormal_variance] = lognstat(normal_mean,normal_sigma);
lognormal_sigma = sqrt(lognormal_variance);

% Step 2: Generate PDF for normal random data:
normal_x = (normal_mean - 3*normal_sigma:0.1:normal_mean + 3*normal_sigma);
normal_pdf = normpdf(normal_x,normal_mean,normal_sigma);
number_of_bins = 50;
bin_width = range_normal/number_of_bins;
figure
hold on
plot(normal_x,normal_pdf*bin_width)
histogram(normal_data,number_of_bins,'Normalization','Probability')
hold off