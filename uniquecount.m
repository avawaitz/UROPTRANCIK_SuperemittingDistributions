% uniquecount function returns 
%test creating branch in github
function uniquecount(matrix)
%create vector of unique values
uniq = unique(matrix);
for category = 1:length(uniq)
    for elem = 1:length(matrix)
        if elem == uniq
            
        end