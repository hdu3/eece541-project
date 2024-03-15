%% Calculate the average brightness of an image

function Y=calc_brightness(I)
% Specify image name
%im = imread(I);

% Convert to double for more precision in calculation 
%im_double = im2double(im);
im_double = im2double(I);

% Extract the Y (luminance) component of the RGB image
% Y = 0.299R + 0.587G + 0.114B
im_y = 0.299 * im_double(:,:,1) + 0.587 * im_double(:,:,2) + 0.114 * im_double(:,:,3);

% Calculate the average brightness of the image
Y = mean(im_y(:));

end