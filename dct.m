%// Load an image
Orig = im2double(imread('flower_CSF.png'));
%// Transfer to greyscale
Orig1 = rgb2gray(Orig);
%// Transform
Orig_T = dct2(Orig1);

[rows columns depth]=size(Orig_T);
%// Split between high- and low-frequency in the spectrum (*)
cutoff = round(0.8 * (columns-1)); %% look at 0.5 and 0.8 for lena, higher cutoff means more high frequency content 
High_T = fliplr(tril(fliplr(Orig_T), cutoff)); % returns elements on and below kth diagonal (top left to bottom right) 
Low_T = Orig_T - High_T;
%// Transform back
High = idct2(High_T);
Low = idct2(Low_T);

%// Plot results
figure, colormap gray
subplot(3,2,1), imagesc(Orig1), title('Original'), axis square, colorbar 
subplot(3,2,2), imagesc(log(abs(Orig_T))), title('log(DCT(Original))'),  axis square, colorbar

subplot(3,2,3), imagesc(log(abs(Low_T))), title('log(DCT(LF))'), axis square, colorbar
subplot(3,2,4), imagesc(log(abs(High_T))), title('log(DCT(HF))'), axis square, colorbar

subplot(3,2,5), imagesc(Low), title('LF'), axis square, colorbar
subplot(3,2,6), imagesc(High), title('HF'), axis square, colorbar