%% Calculate the average brightness of an image using luminance channel in Lab colour space

function Y=calc_lab_brightness(I)
% Specify image name
%im = imread(I);

% Convert to double for more precision in calculation 
%im_double = im2double(im);
%im_double = im2double(I);

% Convert to lab colour space using rgb2lab
lab_im = rgb2lab(I);
lum = lab_im(:,:,1);

% Calculate the average brightness of the image
Y = mean(lum(:));

end