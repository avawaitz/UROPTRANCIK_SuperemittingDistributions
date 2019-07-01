% downloadVehicleData

function dataCellArr = downloadVehicleData(filename,columns)
fullFilename = ['/Users/avawaitz/Dropbox/AvaProject/Data/PersonalVehicles/',filename,'.xlsx'];
dataCellArr={};
for w =1:length(columns)
    tag = columns(w);
    tag = tag{:};
    columnDownload = [tag,':',tag];
[values,title1,~]= xlsread(fullFilename,1,columnDownload);
values = num2cell(values);
values = vertcat(values{:});
dataCellArr(w,1:2)={title1,values};
end

%{
delete rows with NaN
for k = length(datamatrix):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
    nantest = isnan(datamatrix{k,4});
        if sum(nantest) == 1
           datamatrix(k,:) = [];
        end
end
%}
end