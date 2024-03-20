%% Script to get reduced brightness image using JND_pixel.m using lab colour space

% Specify image name
I = imread("ubc_CSF.png");

% Convert to lab colour space using rgb2lab
lab_im = rgb2lab(I);
lab_y_im = lab_im(:,:,1);

%imshow(lab_y_im);

% Calculate DCT for image in 8x8 blocks 
%Lum = double(lab_y_im);
%k = 1;M =256;
%[row,col] = size(lab_y_im);
%Lum=Lum(1:row/8*8,1:col/8*8);
% JND adjustment factor
%tfac=0.3;

% Assume maximum luminance and minimum luminance values
%Lmax = 130;
%Lmin = 0;

%DCT Transform
%Tr = dctmtx(8);
%C = blkproc(Lum,[8 8],'P1*x*P2',Tr,Tr');

% 8x8 block size
blockSize = [8 8];

% Function handle to apply 2D DCT
dctFunc = @(block_struct) dct2(block_struct.data);

% Apply DCT to each 8x8 block
dctBlocks = blockproc(lab_y_im, blockSize, dctFunc);

%imshow(dctBlocks);

% Run JND_dct
JND_im = JND_dct(lab_y_im);

%%% temp save idct2 of JND_im
%idct_JND_im = blockproc(JND_im, blockSize, idctFunc);

% Reduce brightness of DCT coefficients using JND values 
new_im = dctBlocks - JND_im;

% Convert modified DCT coefficients back to image space using idct2 in 8x8
% blocks
idctFunc = @(block_struct) idct2(block_struct.data);
idctBlocks = blockproc(new_im, blockSize, idctFunc);

% Update modified L channel
lab_im(:,:,1) = idctBlocks;

% Convert back to rgb 
rgb_im = lab2rgb(lab_im, 'OutputType', 'uint8');

% Calculate brightness change
orig_y = calc_lab_brightness(I);
new_y = calc_lab_brightness(rgb_im);

% Display images
subplot(3, 3, 1);
imshow(I);
title("Original Image: Lum " + num2str(orig_y) + "");

subplot(3, 3, 2);
imshow(rgb_im);
title("Reduced Brightness Image with JND: Lum " + num2str(new_y) + "");

subplot(3, 3, 3);
imshow(JND_im);
title("JND DCT Coefficients")

subplot(3, 3, 4);
imshow(dctBlocks);
title("Original Image DCT")

subplot(3,3,5);
imshow(new_im);
title("New DCT Image")

subplot(3,3,6);
imshow(uint8(rescale(lab_im(:,:,1), 0, 255)));
title("Modified L Channel")

subplot(3,3,7);
imshow(lab_im(:,:,2));
title("A Channel")

subplot(3,3,8);
imshow(lab_im(:,:,3));
title("B Channel")

subplot(3,3,9);
diff_L = lab_y_im - lab_im(:,:,1);
imshow(uint8(rescale(diff_L, 0, 255)));
title("L Channel Difference");
%imshow(lab_y_im);
%title("Original L Channel")