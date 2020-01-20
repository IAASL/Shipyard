% Function to acquire an image according to the filename string and process it with the imtrans_P
% function to acquire the stretched version of that image.
function [strtimg] = imdosth_P(filename)
    im_temp = imread(filename);
    strtimg = imtrans_P(im_temp);
end