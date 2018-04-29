%Notes: output will be plot(s)
%inputs into plotting function: source tag,sourceemissions matrix
%upperlimit for x (number or 'none'), upperlimit for y (number or 'none'), type of plot ('lin' 'loglin' loglog'
    %'all', sub folder name (in Brandt_Latex)
    
%Questions/To Dos:  
    % - the lower limit on the xlog scales is still missing the zero value?
    % - should number of bins be a controllable input?

function plotdata(category,catvalues,xuplim,yuplim,scale,folder) 
frequency = length(catvalues); 
label = [num2str(frequency),' observations'];
dim = [.75 .68 .3 .3]; %controls location of txtbox on figure

%x and y limits (setting defaults for if 'none' is entered)
if xuplim == 'none'
   xuplim = max(catvalues); 
end
if yuplim == 'none'
   yuplim = Inf; 
end

% Identify excluded upper outliers (right now just returns idx - don't know
% how to show/what to show on figure
idxexcluded = find(catvalues < xuplim);


% Find data stats
mu = mean(catvalues);
sigma = std(catvalues);
datastats = [mu sigma]; %%% fix so that you can label mu and sigma
    
figure1 = figure('Position',[700,500,900,350]);

if strcmpi('lin',scale) || strcmpi('all',scale)%Plots Linear % Have to use strcmpi for string logic
    subaxis(1,3,1, 'SpacingHoriz',0.05,'Margin',0.05, 'PaddingTop', 0.15, 'PaddingBottom', 0.15)
    hold on
    %figure
    histogram(catvalues,50,'BinLimits',[min(catvalues),xuplim], 'Normalization', 'probability'); %make linear histogram with limits
    title({['Brandt ',category,' Emissions'] ; '(Linear scale)'});
    xlabel('Emissions rate (kgCH4/day)')
    ylabel('Frequency')
    annotation('textbox',dim,'String',label,'FitBoxToText','on'); %creates txtbox on figure
    %saveas(gcf,char([sourcetag,'Lin.png']));
   
    %exponential fit
    muhat = expfit(catvalues);
    Xexp = -0.1:0.1:100;
    Yexp= exppdf(Xexp,muhat);
    plot(Xexp,Yexp,'LineWidth',1.8)

    hold off
end
%%%%Lin/Log 
if strcmpi('linlog',scale) || strcmpi('all',scale) %Plots Log-Linear
    %taking out zero values
    for k = length(catvalues):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
        if catvalues(k) == 0
           catvalues(k) = [];
        end
    end
    
    upperlim2 = ceil(log10(xuplim));
    xlog = logspace(-3,upperlim2,50);%make bin edges
    % ^^ lower limit is changed to zero to catch zero values
    %figure
    subaxis(1,3,2)
    hold on 
    histogram(catvalues, xlog, 'Normalization','pdf'); %make histogram, relative probability
    
    
    %%%% Plotting normal fit
    logvalues = log(catvalues);
    pd = fitdist(catvalues.','lognormal');
    x_values3 = 0:0.01:log10(xuplim);
    %pd.mu = exp(pd.mu);
    %pd.sigma = exp(pd.sigma);
    Y3 = pdf(pd,x_values3);
    plot(x_values3,Y3);
    set(gca,'xscale','log')% scale the x axis
    
    %%% Graph title, labels, etc
    title({['Brandt ',category,' Emissions']; '(Log/lin scale)'});
    xlabel('Emissions rate (kgCH4/day)')
    ylabel('Frequency')
    annotation('textbox',dim,'String',label,'FitBoxToText','on'); %plots txtbox on graph
    annotation('textbox',[.75 .5 .3 .3],'String',datastats,'FitBoxToText','on')
    %saveas(gcf,char([sourcetag,' Loglin']),'png');
    hold off
end

%%%Log/Log
if strcmpi('loglog',scale) || strcmpi('all',scale) %Plots Log-Log
    upperlim3 = ceil(log10(xuplim));
    xlog2 = logspace(-2,upperlim3,50); %make bin edges
   % ^^ lower limit is changed to zero to catch zero values
    % LOWER LIMIT NOT CATCHING ALL VALUES
    %figure
    subaxis(1,3,3)
    hold on
    histogram(catvalues,xlog2) %make histogram
    set(gca,'xscale','log') % scale the x axis
    set(gca, 'yscale','log')% scale the y axis
    ylim([0.8 yuplim]); %lower limit is 0.8 because 1 is the lowest frequency value
    title({['Brandt ',category,' Emissions']; '(Log/log scale)'});
    xlabel('Emissions rate (kgCH4/day)')
    ylabel('Frequency')
    annotation('textbox',dim,'String',label,'FitBoxToText','on'); %creates txtbox on figure
    %saveas(gcf,char([category,' Loglog']),'png');
    hold off
end
filename = category;
filepath = char(['/Users/avawaitz/Dropbox/AvaProject/Brandt_Latex/',folder]);
saveas(gcf,fullfile(filepath,filename),'png');

end


