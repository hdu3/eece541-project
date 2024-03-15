%% Script to get reduced brightness image using JND_pixel.m using YCbCr colour space

% Specify image name
I = imread("ubc_CSF.png");

% Scale image down using imresize to be compatible with JND_pixel.m if
% needed
I2 = imresize(I, 1/2);

% Convert to YCbCr colour space using rgb2lab
ycbcr_im = rgb2ycbcr(I2);
ycbcr_y_im = ycbcr_im(:,:,1);

% Run JND_pixel 
JND_im = JND_pixel(ycbcr_y_im, "Yang");

% Reduce brightness of grayscale image by JND values
new_im = double(ycbcr_y_im) - JND_im;

% Update modified L channel
ycbcr_im(:,:,1) = uint8(new_im);

% Convert back to rgb 
rgb_im = ycbcr2rgb(ycbcr_im);

% Calculate brightness change
orig_y = calc_brightness(I2);
new_y = calc_brightness(rgb_im);

% Display images
subplot(1, 2, 1);
imshow(I2);
title("Original Image");

subplot(1, 2, 2);
imshow(rgb_im);
title("Reduced Brightness Image with JND");