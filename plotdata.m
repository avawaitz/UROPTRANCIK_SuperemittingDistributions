%Notes: output will be plot(s)
%inputs into plotting function: source tag,sourceemissions matrix
%upperlimit for x (number of 'none'), upperlimit for y (number of 'none'), type of plot ('lin' 'loglin' loglog'
    %'all'
    
%Questions/To Dos:  
    % - the lower limit on the xlog scales is still missing the zero values
    % - still need to have function save the plot, ideal is to save as
    %   vector-based image, png best
    % - what should ylim be on default? 
    % - change sourcevalues so not cellarray?
    % - should number of bins be a controllable input?
    

function plotdata(sourcetag,sourceemissions,xuplim,yuplim,scale) 
tgidx = find(strcmp(sourceemissions(:,1),sourcetag)); %finds idx of the source tag
sourcevalues = sourceemissions(tgidx,2); %uses it to get the emissions values for that tag
frequency = length(sourcevalues{1,1}); %still wrong # bc dataprepare not deleting NaN

label = [num2str(frequency),' observations'];
dim = [.75 .68 .3 .3]; %controls location of txtbox on figure

%x and y limits (setting defaults for if 'none' is entered)
if xuplim == 'none'
   xuplim = ceil(max(sourcevalues{:})); %should I do cieling? or no...
   %have to do sourcevalues{:} bc sourcvalues is a single cell array with a
   %vector as an entry, maybe go back and change this earlier
end
if yuplim == 'none'
   yuplim = 6; %WHAT SHOULD YLIM BE?
end

if strcmpi('lin',scale) || strcmpi('all',scale)%Plots Linear % Have to use strcmpi for string logic
figure
histogram(sourcevalues{:},100,'BinLimits',[min(sourcevalues{:}),xuplim]); %make linear histogram with limits
title(['Brandt ',sourcetag,' Device Emissions (Linear scale)']);
xlabel('Methane Emissions rate (kgCH4/day)')
ylabel('Frequency')
annotation('textbox',dim,'String',label,'FitBoxToText','on'); %creates txtbox on figure
end

if strcmpi('loglin',scale) || strcmpi('all',scale) %Plots Log-Linear
    upperlim2 = ceil(log10(xuplim));
    xlog = logspace(-2,upperlim2,50); %make bin edges
    % ^^ lower limit is -2 bc most tags have 0 values, so 10^-2 catched
    % those 10^0s STILL MISSING ZERO VALUES
    figure
    histogram(sourcevalues{:},xlog); %make histogram
    set(gca,'xscale','log') % scale the x axis
    title(['Brandt ',sourcetag,' Device Emissions (Log/lin scale)']);
    xlabel('Methane Emissions rate (kgCH4/day)')
    ylabel('Frequency')
    annotation('textbox',dim,'String',label,'FitBoxToText','on'); %plots txtbox on graph
end

if strcmpi('loglog',scale) || strcmpi('all',scale) %Plots Log-Log
    upperlim3 = ceil(log10(xuplim));
    xlog2 = logspace(-2,upperlim3,50); %make bin edges
    % LOWER LIMIT NOT CATCHING ALL VALUES
    figure
    histogram(sourcevalues{:},xlog2) %make histogram
    set(gca,'xscale','log') % scale the x axis
    set(gca, 'yscale','log')% scale the y axis
    ylim([0.8 yuplim]); %lower limit is 0.8 because 1 is the lowest frequency value
    title(['Brandt ',sourcetag,' Device Emissions (Log/log scale)']);
    xlabel('Methane Emissions rate (kgCH4/day)')
    ylabel('Frequency')
    annotation('textbox',dim,'String',label,'FitBoxToText','on'); %creates txtbox on figure
end
end


