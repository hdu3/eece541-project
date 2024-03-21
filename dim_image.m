%% Function to reduced the brightness of an image to mimic a dimmed display

function dimmed_im = dim_image(im, dimming_factor)

% im2double rescales the output from integer data types to the range [0, 1]
im_double = im2double(im);

% Multiply by dimming factor to decrease image brightness
dimmed_im = im2uint8(im_double * dimming_factor);

%dimmed_im = max(0, min(1, dimmed_im));

end