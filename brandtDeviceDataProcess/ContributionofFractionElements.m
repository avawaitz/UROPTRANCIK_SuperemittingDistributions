% ContributionofFractionElements

function fractionElems = ContributionofFractionElements(datavec,fracContrib)
totNumElems = length(datavec);
totValue = sum(datavec);
datavecSorted = sort(datavec,'descend');

for k=1:totNumElems
    elemSum = sum(datavecSorted(1:k));
    fractionElems = k/totNumElems;
    if elemSum > totValue*fracContrib
        break
    end
end
end
 
        