function [Tf, newGn, newLn, newRn] = sigiteration(oldGn, oldLn, oldRn, oldf)
nbin = size(oldGn, 1);
MaxL = size(imhist(oldf), 1);
oldHn = imhist(oldf);

% first occurring Gn(i)
minGi = max(oldGn(:));
idxminGi = 0;
for i=1:nbin
    if (oldGn(i, 1) < minGi)
        idxminGi = i;
        minGi = oldGn(i, 1);
    end
end


%  groupping
% oldGnb = min(oldGn(idxminGi-1, 1), oldGn(idxminGi+1, 1));
% idxmerging = 0;
% if oldGn(idxminGi-1, 1) <= oldGn(idxminGi+1, 1)
%     idxmerging = idxminGi - 1;
% else
%     idxmerging = idxminGi;
% end

idxmerging = 0;
if idxminGi == size(oldGn, 1)
    oldGnb = oldGn(idxminGi-1, 1);
    idxmerging = idxminGi - 1;
elseif idxminGi == 1
    oldGnb = oldGn(idxminGi+1, 1);
    idxmerging = idxminGi;
else
    oldGnb = min(oldGn(idxminGi-1, 1), oldGn(idxminGi+1, 1));
    if oldGn(idxminGi-1, 1) <= oldGn(idxminGi+1, 1)
        idxmerging = idxminGi - 1;
    else
        idxmerging = idxminGi;
    end
end

% from old G[n] to new G[n-1]
newGn = zeros(nbin-1, 1);
i = 0;  % it is found that all these loops share the value of i, since i is made global
for i=1:(nbin-1)
    if i < idxmerging
        newGn(i, 1) = oldGn(i, 1);
    elseif i == idxmerging
        newGn(i, 1) = oldGnb + minGi;  % a+b in the paper
    else
        newGn(i, 1) = oldGn(i+1, 1);
    end
end

% update the limit of each bin
newLn = zeros(nbin-1, 1);
newRn = zeros(nbin-1, 1);

i = 0;  % it is found that all these loops share the value of i, since i is made global
for i=1:nbin-1
    if i <= idxmerging-1
        newLn(i, 1) = oldLn(i, 1);
        newRn(i, 1) = oldRn(i, 1);
    end
    
    if i == idxmerging
        newLn(i, 1) = oldLn(i, 1);
        newRn(i, 1) = oldRn(i+1, 1);
    end
    
    if i > idxmerging
        newLn(i, 1) = oldLn(i+1, 1);
        newRn(i, 1) = oldRn(i+1, 1);
    end
end

% calculate the transformation function of mapping in this turn
Nn = 0;
sigmark = false;
if newLn(1, 1) == newRn(1, 1)
    sigmark = true;
    Nn = (MaxL-1)./(nbin-1-0.8);  % 0.8 comes from the proposed alpha to counter the effect of the first
                                     % bin which may contain single gray-level
else
    sigmark = false;
    Nn = (MaxL-1)./(nbin-1);
end

Tf = zeros(MaxL, 1);  % the function look up table
for k = 0:(MaxL-1)
    [kclass, idxpros] = judgeGrayLevel(newLn, newRn, k);
    switch kclass
        case 'hit'
            if sigmark
                Tf(k+1, 1) = (idxpros - 0.8 - (newRn(idxpros, 1)-k)./(newRn(idxpros, 1)-newLn(idxpros, 1))) * Nn + 1;
            else
                Tf(k+1, 1) = (idxpros - (newRn(idxpros, 1)-k)./(newRn(idxpros, 1)-newLn(idxpros, 1))) * Nn + 1;
            end
            
        case 'between'
            if sigmark
                Tf(k+1, 1) = (idxpros - 0.8) * Nn;
            else
                Tf(k+1, 1) = (idxpros) * Nn;
            end
            
        case 'toosmall'
            Tf(k+1, 1) = 0;
            
        case 'toolarge'
            Tf(k+1, 1) = MaxL - 1;
    end
end
Tf = floor(Tf);

% % Apply the transformation to the original image
% i = 0;  % it is found that all these loops share the value of i, since i is made global
% for i=1:size(oldf, 1)
%     for j=1:size(oldf, 2)
%         newf(i, j) = Tf(oldf(i, j)+1, 1);
%     end
% end

% calculate the average distance for comparison and store it in the TD cell
% Dn = avgdistance(newf);

end