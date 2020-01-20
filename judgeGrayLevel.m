function [kclass, hitbtwidx] = judgeGrayLevel(Ln, Rn, k)
%JUDGEGRAYLEVEL gives the description of a gray level value for the GLG algorithm to calculate the
%transformation function
%   Ln is the left limit of each gray bin
%   Rn is the right limit of each gray bin
%   k is the tested gray level value
%   kclass is the output which is a label confined to the following options
%   'hit'       this case corresponds to the circumstance where k is within some certain gray bin and that 
%               gray bin has a length larger than 1.
%               The index of the gray bin is given to HITBTWIDX.
%
%   'between'   this case corresponds to the circumstance where k is between two gray bins or k is directly
%               hit but the gray bin has a lenght equal to 1.
%               The index of the gray bin among the smaller one is given to HITBTWINDEX.
%
%   'toosmall'  this case corresponds to the circumstance where k is too small for each bins, i.e., k
%               falls into neither of the gray bins.
%               HITBTWINDEX will return -1 as a symbol to remind the calling function.
%
%   'toolarge'  this case corresponds to the circumstance where k is too large for any of he gray bins,
%               similar to the previous case, rather in a reversed direction along the gray value axis.
%               HITBTWINDEX will return -2 as a symbol to remind the calling function.
%

nbin = size(Rn, 1);
hitmark = 0;  % 0 for not hit, 1 for directly hit, 2 for hit but the bin has a lenght of one. 
idxtemp = 0;

if k <= Ln(1, 1)
    kclass = 'toosmall';
    hitbtwidx = -1;
    return;
end

if k >= Rn(nbin, 1);
    kclass = 'toolarge';
    hitbtwidx = -2;
    return;
end

for i=1:nbin
    if k <= Rn(i) && k >= Ln(i)  % gray level k falls into some certain bin
        if Ln(i) ~= Rn(i)
            hitmark = 1;
            idxtemp = i;
            break;
        else
            hitmark = 2;
            idxtemp = i;
        end
    end
end

if hitmark == 1
    hitbtwidx = idxtemp;
    kclass = 'hit';
elseif hitmark == 2
    hitbtwidx = idxtemp;
    kclass = 'between';
else
    for i=1:nbin
        if k >= Rn(i) && k <= Ln(i+1)  
            kclass = 'between';
            hitbtwidx = i;
        end
    end  
end

end