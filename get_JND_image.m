%% Script to get JND image

% Specify image name
I = imread("lena_CSF.png");

% Scale image down using imresize
%I2 = imresize(I, 1/2);

% Convert to grayscale using rgb2gray
gray_im = rgb2gray(I);

% Run JND_pixel 
JND_im = JND_pixel(gray_im, "Yang");

% JND_dct?
%JND_dct_im = JND_dct(gray_im);

% Scale values to [0, 255]
rescale_im = rescale(JND_im, 0, 255);

% Convert to uint8
int_im = uint8(rescale_im);

% Display images
subplot(1, 2, 1);
imshow(I);
title("Original Image");

subplot(1, 2, 2);
imshow(int_im);
title("JND Image");