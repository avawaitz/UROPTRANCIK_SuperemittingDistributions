
% Questions: 
%- should input be the whole data matrix or the two vectors? 
%- should this function pull out the two vectors or will another function used upstream
%   do that?
%- Should I not include the loading of the data from excel in this function?
%- Deleting NaN not working


function sourceemissions = dataprepare
% Downloads source tags and emissions from excel file
[ndata1,source,alldata]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','D2:D26656');
[kgperday,text2,alldata]= xlsread('/Users/avawaitz/Dropbox/AvaProject/Data/es6b04303_si_002.xlsx','Compilation for export','G2:G26656');

kgperday = num2cell(kgperday); %makes double array into cell array s.t. can concatenate
datamatrix = [source kgperday]; %concatenates into 2x26655 cell array (source, kgperday)

%delete rows with NA and NaN:I think fixed, test again...
deleteidx = find(strcmp(datamatrix(:,1),'NA'));
datamatrix(deleteidx,:)=[];
for k = length(datamatrix):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
    nantest = isnan(datamatrix{k,2});
        if sum(nantest) == 1
           datamatrix(k,:) = [];
        end
end

%find frequencies of source tags 
uniqarr = uniquecount(datamatrix(:,1)); %cell array w/ unique source tags and corresponding frequencies

%Will be changed to only include source tags with n> # observations
uniqarrN = uniqarr; 
for x = length(uniqarrN):-1:1 % bc columns being deleted as loop runs need to go from end to beginning so indexes not changed
    if uniqarrN{2,x} < 0 % ##
        uniqarrN(:,x) = [];
    end
end %this is an array of the unique sources and their frequency, if their
%frequency is greater than ##

%generate emission distribution vectors for each source tag. 
%Makes a cell array with first column source tags, second column of cells
%contains vector of emissions for each
sourceemissions = cell(length(uniqarrN),2,1);
for y = 1:length(uniqarrN)
    sourcetag = uniqarrN{1,y};  
    idx = find(strcmp(datamatrix(:,1),sourcetag)); %finds indices of elements with that source string in source arr
    emissionsvec = datamatrix(idx,2);%extracts the emissions of those observations (at those indices)
    emissionsvec = cell2mat(emissionsvec); %makes cell array into vector
    emissionsvec = emissionsvec.'; %transposes so that it is a row vector
    sourceemissions{y,1}= sourcetag;
    sourceemissions{y,2}= emissionsvec; 
end    
end
