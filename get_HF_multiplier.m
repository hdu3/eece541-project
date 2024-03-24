%[minA, maxA] = bounds(idctBlocks,"all")

function Y = get_HF_multiplier(I, max)

%// Load an image
%Orig = im2double(imread('ubc_CSF.png'));

%Orig = imresize(Orig, 1/2);

%// Convert to lab colour space to filter on luminance channel
%Orig1 = rgb2gray(I);
OrigLab1 = rgb2lab(I);
OrigLum = OrigLab1(:,:,1); 

% 8x8 block size
blockSize = [8 8];

% Function handle to apply 2D DCT
dctFunc = @(block_struct) dct2(block_struct.data);

% Apply DCT to each 8x8 block
dctBlocks = blockproc(OrigLum, blockSize, dctFunc);

% Function handle to apply high pass filter
highPassFunc = @(block) highPassFilter(block.data);

% Apply HPF to each 8x8 block
hpfBlocks = blockproc(dctBlocks, blockSize, highPassFunc);

% Scale values to [0, 255]
%rescale_im = rescale(hpfBlocks, 0, 255);

% Convert to uint8
%int_im = uint8(rescale_im);

% Generate multiplier matrix
%Y = rescale(int_im, 1, max);
Y = rescale(hpfBlocks, 1, max);

%%% LPF to each 8x8 block
%lowPassFunc = @(block) lowPassFilter(block.data);
%lpfBlocks = blockproc(dctBlocks, blockSize, lowPassFunc);

% Display images
%{
subplot(2, 2, 1);
imshow(Orig);
title("Original Image");

subplot(2, 2, 2);
imshow(hpfBlocks); % plot hpfBlocks or int_im
title("High Frequency Image - idct2 double");

subplot(2, 2, 4);
imshow(int_im);
title("High Frequency Image - uint8 rescaled")

subplot(2, 2, 3);
imshow(uint8(rescale(lpfBlocks,0,255)));
title("Low Frequency Image - uint8 rescaled")
%}

% Get min and max dct coefficients
%[minA, maxA] = bounds(hpfBlocks,"all");

end

function filteredBlock = highPassFilter(dctBlock)
    %// Split between high- and low-frequency in the spectrum (*)
    cutoff = round(0.8 * 8); %% look at 0.5 and 0.8 for lena, higher cutoff means more high frequency content 

    High_T = fliplr(tril(fliplr(dctBlock), cutoff)); % returns elements on and below kth diagonal (top left to bottom right) 

    %// Transform back
    filteredBlock = idct2(High_T);

end


function filteredBlock = lowPassFilter(dctBlock)
    %// Split between high- and low-frequency in the spectrum (*)
    cutoff = round(0.8 * 8); %% look at 0.5 and 0.8 for lena, higher cutoff means more high frequency content 

    High_T = fliplr(tril(fliplr(dctBlock), cutoff)); % returns elements on and below kth diagonal (top left to bottom right) 

    Low_T = dctBlock - High_T;

        %// Transform back
    filteredBlock = idct2(Low_T);


end


