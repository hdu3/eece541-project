%% Script to get reduced brightness image using JND_pixel.m using lab colour space
clear; 
% PARAMETERS TO SPECIFY
IM_NAME = "fruit_enhanced.jpg";
HF_MULTIPLIER = 2;
LF_MULTIPLIER = 1;

% Specify image name
I = imread(IM_NAME);

% Scale image down using imresize to be compatible with JND_pixel.m if
% needed
%{
[numRows, numCols] = size(I);
if numRows > 383
    % Determine scaling factor needed and round to 1 decimal place
    scaling_factor = floor(10*383/numRows)/10;
else
    scaling_factor = 1;
end
I2 = imresize(I, scaling_factor);
%}

% Get high frequency multiplier matrix
y = get_HF_multiplier(I, HF_MULTIPLIER);
x = get_LF_multiplier(I, LF_MULTIPLIER);

% Convert to lab colour space using rgb2lab
lab_im = rgb2lab(I);
lab_y_im = lab_im(:,:,1);

% Reduce JND
% Run JND_pixel 
JND_im = JND_pixel(lab_y_im, "Yang");
mean_JND_im = mean(JND_im(:));

% Multiply by HF matrix
mult_JND_im = times(JND_im, y);
mean_HF_JND_im = mean(mult_JND_im(:));

% Multiply by LF matrix
mult_JND_im = times(mult_JND_im, x);
mean_LF_JND_im = mean(mult_JND_im(:));

% Reduce brightness of luminance image by JND values
%new_im = lab_y_im - JND_im;
new_im = lab_y_im - mult_JND_im;

% Update modified L channel
lab_im(:,:,1) = new_im;

% Convert back to rgb 
rgb_im = lab2rgb(lab_im, 'OutputType', 'uint8');

% Calculate brightness change
orig_y = calc_lab_brightness(I);
new_y = calc_lab_brightness(rgb_im);

% Display images
subplot(3, 2, 1);
imshow(I);
title("Original Image: Lum " + num2str(orig_y) + "");

subplot(3, 2, 2);
imshow(rgb_im);
title("Reduced Brightness Image with JND: Lum " + num2str(new_y) + "");

subplot(3, 2, 3);
diff_lum = lab_y_im - lab_im(:,:,1);
imshow(uint8(rescale(diff_lum, 0, 255)));
title("Luminance Channel Difference");

subplot(3, 2, 4);
diff_im = I - rgb_im;
imshow(uint8(rescale(diff_im, 0, 255)));
title("RGB Image Difference");

subplot(3, 2, 5);
hf_im = uint8(rescale(y, 0, 255));
imshow(hf_im);
title("High Frequency Multiplier Matrix");

subplot(3, 2, 6);
lf_im = uint8(rescale(x, 0, 255));
imshow(lf_im);
title("Low Frequency Multiplier Matrix");