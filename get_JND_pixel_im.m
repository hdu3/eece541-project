%% Script to get reduced brightness image using JND_pixel.m using lab colour space

% Specify image name
I = imread("ubc_CSF.png");

% Scale image down using imresize to be compatible with JND_pixel.m if
% needed
I2 = imresize(I, 1/2);

% Convert to lab colour space using rgb2lab
lab_im = rgb2lab(I2);
lab_y_im = lab_im(:,:,1);

% Run JND_pixel 
JND_im = JND_pixel(lab_y_im, "Yang");

% Reduce brightness of grayscale image by JND values
new_im = lab_y_im - JND_im;

% Update modified L channel
lab_im(:,:,1) = new_im;

% Convert back to rgb 
rgb_im = lab2rgb(lab_im, 'OutputType', 'uint8');

% Calculate brightness change
orig_y = calc_lab_brightness(I2);
new_y = calc_lab_brightness(rgb_im);

% Display images
subplot(1, 2, 1);
imshow(I2);
title("Original Image");

subplot(1, 2, 2);
imshow(rgb_im);
title("Reduced Brightness Image with JND");