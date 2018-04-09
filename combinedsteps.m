function combinedsteps
sourceemissions = dataprepare;
for p = 1:3
    sourcetag = sourceemissions{p,1};
    plotdata(sourcetag,sourceemissions, 'none','none','all')
end
end