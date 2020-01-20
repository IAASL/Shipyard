% Image Preprocessing, in order to acquire visualization appealing to the normal human vision. Simply to
% obtain the images suitable for direct observation.

imginFileInfo1 = dir('ImgIn/');
imginFileInfo2 = dir('ImgOut/');

% Processing the input Image
nentry = max(size(imginFileInfo1));
for i=1:nentry
    if(imginFileInfo1(i).isdir == 0)
        imgName = strcat('ImgIn/', imginFileInfo1(i).name);
        imtemp = imdosth_P(imgName);
        imgTargetName = strcat('ImgInItn/', imginFileInfo1(i).name, '_it.tif');
        imwrite(imtemp, imgTargetName);
    end
end


% Processing the output image
nentry = max(size(imginFileInfo2));
for i=1:nentry
    if(imginFileInfo2(i).isdir == 0)
        imgName = strcat('ImgOut/', imginFileInfo2(i).name);
        imtemp = imdosth_P(imgName);
        imgTargetName = strcat('ImgOutItn/', imginFileInfo2(i).name, '_it.tif');
        imwrite(imtemp, imgTargetName);
    end
end

