function Dn = avgdistance(f)
    npixel = size(f, 1)*size(f, 2);
    H = imhist(f);
    M = size(H, 1);
    sumtemp = 0;
    for i=0:(M-2)
        for j=(i+1):(M-1)
            sumtemp = sumtemp + H(i+1)*H(j+1)*(j-i);
        end
    end
    Dn = (1/((npixel)*(npixel-1))) * sumtemp;
end