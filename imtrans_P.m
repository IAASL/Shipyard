% Auxiliary Function
% Image Transformation
% Due to the fact that the original image only use the lower 12bits(which is 4096 gray levels) to
% represent the DR images, for direct observation in the early stage of the project.
% Input: Image in format of uint16
% Output: Image in format of uint16 with the dynamic scale stretched to the full range.
function [outputImg] = imtrans_P(inputImg)
    outputImg = imadjust(inputImg, stretchlim(inputImg, [0.05, 0.95]), [0, 1]);
end