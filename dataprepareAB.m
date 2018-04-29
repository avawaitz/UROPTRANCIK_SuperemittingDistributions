function [siteeui,outliers,xuplim,yuplim] = dataprepareAB(datamatrixAB,xuplimspec)
% extract site eui, format to be put into plot function
siteeui = datamatrixAB(:,end);
siteeui = cell2mat(siteeui);
siteeui = siteeui.';


%%%%Maybe move to plot??
% limits - don't need if statements for if 'none' entered bc will be dealt
% with in plot function
xuplim = xuplimspec;
yuplim = 'none';

% finding upper limit outliers (only if none not entered)
if strcmp(xuplimspec,'none') == 0
    outlieridx = find(siteeui > xuplimspec);
    outliers = datamatrixAB(outlieridx,:);
end
% save( ??
end




