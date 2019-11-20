% nanzscore.m
% calculates zscore, carrying through NaN values

function result = nanzscore(X)
shift2zero = X - nanmean(X,2);
normalized = shift2zero./nanstd(X,0,2);
result = normalized;
end
