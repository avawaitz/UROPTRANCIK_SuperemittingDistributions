%this function downloads the Brandt's tag classification into 25 device
%categories (entered into excel sheet). it then uses these to group
%observations from brandt's data by device category. Returns an array
%{device category, vec: tags in device category, vec: emissions observations}

%NOTE: some of the device categories still don't quite match brandt

function devicearr = devicecat(datamatrix)
%creating device categories outlined by brandt
[~, devices, ~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','A2:A26');
devicearr = num2cell(devices);


% Putting source tags (from S6 in Brandt pdf) in device categories
[~,devicearr{1,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B2');
[~,devicearr{2,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B3:D3');
[~,devicearr{3,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B4:E4');
[~,devicearr{4,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B5:D5');
[~,devicearr{5,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B6');
devicearr{6,2} = [devicearr{3,2}, devicearr{4,2}, devicearr{5,2}];
[~,devicearr{7,2},~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B8:I8');
[~,devicearr{8,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B9');
[~,devicearr{9,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B10:C10');
[~,devicearr{10,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B11:D11');
[~,devicearr{11,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B12:G12');
[~,devicearr{12,2},~]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B13:C13');
[~,devicearr{13,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B14');
[~,devicearr{14,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B15:K15');
[~,devicearr{15,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B16:K16');
[~,devicearr{16,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B17:C17');
devicearr{17,2} = [devicearr{6,2}, devicearr{16,2}];
[~,devicearr{18,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B19:K19');
[~,devicearr{19,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B20:E20');
[~,devicearr{20,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B21:D21');
[~,devicearr{21,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B22:K22');
[~,devicearr{22,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B23:G23');
[~,devicearr{23,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B24:AC24');
devicearr{24,2} = [devicearr{22,2}, devicearr{23,2}];
[~,devicearr{25,2},~] = xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Device Groups','B26:O26');

%deviceemissions = cell(length(devicearr),2,1);
for x = 1:length(devicearr)
    tags = devicearr{x,2}; %returns 1x1 cell containging device category string
    tagidxtotal = [];
    for y = 1:length(tags)
       %finds indices of elements with that sourcetag string in the datamtrix
        idxsource = find(strcmp(datamatrix(:,1),tags{y}));
        idxsource = idxsource.';
        idxsub = find(strcmp(datamatrix(:,2),tags{y}));
        idxsub = idxsub.';
        idxsubsub = find(strcmp(datamatrix(:,3),tags{y}));
        idxsubsub = idxsubsub.';
        idx = [idxsource,idxsub,idxsubsub];
        tagidxtotal = [tagidxtotal idx];
    end
    tagidxtotal = unique(tagidxtotal);
    emissionsvec = datamatrix(tagidxtotal,4);%extracts the emissions of those observations (at those indices)
    emissionsvec = emissionsvec.'; 
    emissionsvec = cell2mat(emissionsvec);%transposes so that it is a row vector
    devicearr{x,3}= emissionsvec;
end
%fixing weird cell structure so it works with plotdata
for j=1:length(devicearr)
    devicearr(j,1) = devicearr{j,1};
end
save('brandtdata','devicearr');
end
















