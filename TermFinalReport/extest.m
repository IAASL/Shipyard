% The test script for my image enhancement experiment
% The whole process is divided into two phases, a high-frequency emphasis filtering and a gray level
% grouping which aims at intensifying the contrast

% read the image 
%im1 = imread('test1.tif');
% stretch the dynamic range of the image, let the image occupies the full range
im1 = imdosth_P('ImgIn/knee.tif');

% high-frequency emphasis filtering
PQ = paddedsize(size(im1));
D0 = 0.05*PQ(1);
HBW = hpfilter('btw', PQ(1), PQ(2), D0, 2);
H = 0.5 + 2*HBW;
% gbw = dftfilt(im1, HBW, 'fltpoint');
% gbw = gscale(gbw);
ghf = dftfilt(im1, H, 'fltpoint');
ghf = gscale(ghf);
gh = GLGEnhance(ghf);
gh = gscale(gh, 'full16');
gh = uint16(gh);
gh = gscale(gh, 'minmax', 0, 0.06202);
imwrite(gh, 'ImgOutput/knee_out.tif');

