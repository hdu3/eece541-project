%// Load an image
Orig = im2double(imread('fruit_CSF.png'));

%// Convert to greyscale
Orig1 = rgb2gray(Orig);

% 8x8 block size
blockSize = [8 8];

% Function handle to apply 2D DCT
dctFunc = @(block_struct) dct2(block_struct.data);

% Apply DCT to each 8x8 block
dctBlocks = blockproc(Orig1, blockSize, dctFunc);

% Function handle to apply high pass filter
highPassFunc = @(block) highPassFilter(block.data);

% Apply HPF to each 8x8 block
hpfBlocks = blockproc(dctBlocks, blockSize, highPassFunc);

% Scale values to [0, 255]
rescale_im = rescale(hpfBlocks, 0, 255);

% Convert to uint8
int_im = uint8(rescale_im);



%%% LPF to each 8x8 block
lowPassFunc = @(block) lowPassFilter(block.data);
lpfBlocks = blockproc(dctBlocks, blockSize, lowPassFunc);

% Display images
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

% sliding 8x8 windows? 


% Get min and max dct coefficients
[minA, maxA] = bounds(hpfBlocks,"all");

% Function to categorize frequencies within each block
% You may adjust the thresholds according to your definition of low, mid, and high frequencies
%freqCategorizeFunc = @(block) categorizeFrequencies(block.data);

% Apply frequency categorization to each block
%freqCategories = blockproc(dctBlocks, blockSize, freqCategorizeFunc);


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


% Function to categorize frequencies (example implementation)
function categories = categorizeFrequencies(dctBlock)
    % Define thresholds (these are just examples, you should adjust them based on your needs)
    lowFreqThreshold = 2; % Example threshold for low frequencies
    highFreqThreshold = 5; % Example threshold for high frequencies
    
    % Initialize the categories matrix
    categories = zeros(size(dctBlock));
    
    % Categorize each coefficient in the DCT block
    for i = 1:size(dctBlock, 1)
        for j = 1:size(dctBlock, 2)
            if abs(dctBlock(i,j)) < lowFreqThreshold
                categories(i,j) = 1; % Low frequency
            elseif abs(dctBlock(i,j)) > highFreqThreshold
                categories(i,j) = 3; % High frequency
            else
                categories(i,j) = 2; % Mid frequency
            end
        end
    end
end