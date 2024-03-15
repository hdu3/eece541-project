%% Script to dim image 

% Specify image name 
im = imread("flower.jpeg");

% im = imresize(im, 1/7);

% im2double rescales the output from integer data types to the range [0, 1]
im_double = im2double(im);

% Select dimming factor between 0 and 1
dimming_factor = 0.6;

% Multiply by dimming factor to decrease image brightness
dimmed_im = im_double * dimming_factor;

%dimmed_im = max(0, min(1, dimmed_im));

% Convert to uint8
dimmed_im_uint8 = im2uint8(dimmed_im);

% opt: save image
imwrite(dimmed_im_uint8, "flower_60_dim.jpg")

subplot(1, 2, 1);
imshow(im);
title("Original Image");

subplot(1, 2, 2);
imshow(dimmed_im_uint8);
title("Dimmed Image");