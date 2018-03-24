% uniquecount returns a cell array with row 1 containing the
% unique values of the input matrix (this function only works for strings).
% Row 2 contains the corresponding frequencies of each unique string. 
function [uc_cellarr] = uniquecount(matrix)
uniq = unique(matrix); %create vector of unique values
uc_cellarr = cell(2,length(uniq)); %creates cell array with dimensions matching number of uniq categories in matrix
for x = 1:length(uniq) %for each unique value
    string = uniq{x}; % the category we are counting the frequency for is the string at that index
    match_arr = strcmp(string,matrix); %creates an array of logic values 1 if that elemtn matches the string, zero if no
    freq_string = sum(match_arr); %sums the 1's to get number of matching in original matrix
    uc_cellarr{1,x}=string; %string goes into row 1, x column
    uc_cellarr{2,x} = freq_string; %frequency goes into row 2, x column
end


