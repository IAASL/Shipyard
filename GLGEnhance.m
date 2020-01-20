function g = GLGEnhance(f)
%GLGENHANCE(f) Performs GLG algorithm to increase the contrast for the input image f according to the
%description of the paper. The sole input argument is a gray image without any further requirement. This
%is the first version of the implementation of the algorithm

if nargin < 1
    error('Where is the image?')
end

if nargin > 1
    error('Wrong argument number')
end

% acquire the histogram of the input picture
Hn = imhist(f);
MaxL = size(Hn, 1);  % the number of the levels included in this histogram, serve as the M in the paper.
f_backup = f;  % for backup in case during the process the program may lose the original image.
npixel = size(f, 1) * size(f, 2);

% construct the initial batch of the gray bins
idxinibin = find(Hn > 0);
ninibin = size(idxinibin, 1);
Gn = zeros(ninibin, 1);
nitr = ninibin;
itrct = nitr;

% The left and right boundary of each bin
Ln = zeros(ninibin, 1);
Rn = zeros(ninibin, 1);

% a cell to record transformation function(table) and the corresponding measure distance
TD = cell(ninibin-1, 2);
TDct = 0;

for i=1:ninibin
    Gn(i, 1) = Hn(idxinibin(i), 1);
    Ln(i, 1) = idxinibin(i, 1)-1;
    Rn(i, 1) = idxinibin(i, 1)-1;   % idxinibin here serves as the non-zero gray-level values
end

% first occurring Gn(i)
minGi = max(Gn(:));
idxminGi = 0;
for i=1:ninibin
    if (Gn(i, 1) < minGi)
        idxminGi = i;
        minGi = Gn(i, 1);
    end
end

% The first groupping
idxmerging = 0;
if idxminGi == size(Gn, 1)
    Gnb = Gn(idxminGi-1, 1);
    idxmerging = idxminGi - 1;
elseif idxminGi == 1
    Gnb = Gn(idxminGi+1, 1);
    idxmerging = idxminGi;
else
    Gnb = min(Gn(idxminGi-1, 1), Gn(idxminGi+1, 1));
    if Gn(idxminGi-1, 1) <= Gn(idxminGi+1, 1)
        idxmerging = idxminGi - 1;
    else
        idxmerging = idxminGi;
    end
end


% from G[n] to G[n-1]
oldGn = Gn;
newGn = zeros(ninibin-1, 1);
for i=1:(ninibin-1)
    if i < idxmerging
        newGn(i, 1) = oldGn(i, 1);
    elseif i == idxmerging
        newGn(i, 1) = Gnb + minGi;  % a+b in the paper
    else
        newGn(i, 1) = oldGn(i+1, 1);
    end
end
i = 0;  % it is found that all these loops share the value of i, since i is made global
% update the limit of each bin
oldLn = Ln;
oldRn = Rn;
newLn = zeros(ninibin-1, 1);
newRn = zeros(ninibin-1, 1);

for i=1:ninibin-1
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
i = 0;  % it is found that all these loops share the value of i, since i is made global

% calculate the transformation function of this first mapping
Nn = 0;
sigmark = false;
if newLn(1, 1) == newRn(1, 1)
    sigmark = true;
    Nn = (MaxL-1)./(ninibin-1-0.8);  % 0.8 comes from the proposed alpha to counter the effect of the first
                                     % bin which may contain single gray-level
else
    sigmark = false
    Nn = (MaxL-1)./(ninibin-1);
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
% Store the transformation function
TDct = TDct + 1;
TD{TDct, 1} = Tf;

% % Apply the transformation to the original image
% for i=1:size(f, 1)
%     for j=1:size(f, 2)
%         f(i, j) = Tf(f(i, j)+1, 1);
%     end
% end

% calculate the average distance for comparison and store it in the TD cell
oldHn = Hn;
newHn = imhist(f);
Dn = avgdistance(f);
TD{TDct, 2} = Dn; 

% the iteration
oldf = f;
oldGn = newGn;
oldLn = newLn;
oldRn = newRn;
while itrct > 20
    [Tf, newGn, newLn, newRn] = sigiteration(oldGn, oldLn, oldRn, oldf);
    TDct = TDct + 1;
    TD{TDct, 1} = Tf;
    TD{TDct, 2} = Dn;
    oldGn = newGn;
    oldLn = newLn;
    oldRn = newRn;
%     oldf = newf;
    itrct = itrct - 1;
end

% find the largest Dn and its corresponding transformation function
% maxDn = -1;
% idxmaxDn = 0;
% for i=1:(21-1)  %%%
%     if TD{i, 2} > maxDn
%         idxmaxDn = i;
%         maxDn = TD{i, 2};
%     end
% end

% % Apply the optimal transformation function to the original image
% fresult = zeros(size(f));
% for i=1:size(f, 1)
%     for j=1:size(f, 2)
%         fresult(i, j) = TD{idxmaxDn, 1}(f_backup(i, j)+1, 1);
%     end
% end

% Apply the last transformation function to the original image
fresult = zeros(size(f));
finalTf = TD{TDct, 1};

for i=1:size(f, 1)
    for j=1:size(f, 2)
        fresult(i, j) = finalTf(f_backup(i, j)+1, 1);
    end
end

g = fresult;

end