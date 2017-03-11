%Compe565 Project 2
%Feb. 18th, 2017
%Emanouil Gelyana
%Red ID #815126579
%Branden Vara
%Red ID #817207775
%E-mail:  MGELYANA7@GMAIL.COM
%        BRVARA17@GMAIL.COM
%=====================================================================%
%                                                                     %
%                        READ ME                                      %
%Project 2 COMPE 565                                                  %
%Branden Vara (817207775),Manny Gelyana (815126579) 
%
%                       Execute This File                             %
%                                                                     %
%What to Expect: After running this file, all images will appear in   %
%seperate plots for each section of the project. All images have labels
%that describe what they are representing.                            %
%                                                                     %
%Answered Questions: All the questions are labeled throughout the     %
%code, there are comments at each part in the project and if it can't %
%be answered in this file it will be included in the Project Report   %
%word document.                                                       %
%=====================================================================%

%Include Clear all and clc to clear everything matlab has open before 
%running this file. 
clear all
clc

%Project 2 COMPE 565 
%Branden Vara 817207775
%Emanouil Gelyana 815126579

clear all
clc

%Encoder:(Use 4:2:0 YCbCr component image)
%----------------------------------------------------%
%Read image into 3 dimensional arrray rgbImageSunView
rgbImageSunView = imread('SunView.jpg','jpg');
figure(1),imshow(rgbImageSunView);
title('Original Image:');

%Convert the image into YCbCr color space
%----------------------------------------------------%
SunViewYCbCr = rgb2ycbcr(rgbImageSunView);

%(a)Compute the 8x8   block DCT   transform   coefficients   of   
%the luminance and chrominance components of the image.
%----------------------------------------------------%

%Store Y Band of Image File
SunViewY = SunViewYCbCr(:,:,1);

%Store Cb Band of Image File
SunViewCb = SunViewYCbCr(:,:,2);

%Store Cr Band of Image File
SunViewCr = SunViewYCbCr(:,:,3);

%Subsample Cb and Cr bands using 4:2:0
%----------------------------------------------------%

%Subsampling Cb using 4:2:0
CbSubSample420=SunViewCb(1:2:end, 1:2:end);

%Subsampling Cr using 4:2:0
CrSubSample420=SunViewCr(1:2:end, 1:2:end);

%DCT Transform of Y, Cb, and Cr Components
Y_DCT = blockproc(SunViewY, [8 8], @(block_struct) dct2(block_struct.data)); %@dct2 is the function handled for dct
Cb_DCT = blockproc(CbSubSample420, [8 8], @(block_struct) dct2(block_struct.data), 'PadPartialBlocks' , true); %@dct2 is the function handled for dct
Cr_DCT = blockproc(CrSubSample420, [8 8], @(block_struct) dct2(block_struct.data), 'PadPartialBlocks', true); %@dct2 is the function handled for dct

%8x8 Blocks 1&2 for 5th row
DCT_Block1 = Y_DCT(33:40, 1:8); %First Block
DCT_Block2 = Y_DCT(33:40, 9:16); %Second Block

figure(2);
subplot(1,2,1),imshow(DCT_Block1, 'XData', [1 8], 'YData', [1 8]);
title('DCT Block 1:')

subplot(1,2,2),imshow(DCT_Block2, 'XData', [1 8], 'YData', [1 8]);
title('DCT Block 2:')

%(b)
%Quantize  the  DCT  image by  using  the  JPEG  luminance  
%and  chrominance  quantizer matrix from the lecture notes.
%----------------------------------------------------%

%(i) DC DCT Coefficient

%Quantitization Matrices for Luminance an Chrominance
Luminance_QM =[
16 11 10 16 24 40 51 61;
12 12 14 19 26 58 60 55;
14 13 16 24 40 57 69 56;
14 17 22 29 51 87 80 62;
18 22 37 56 68 109 103 77;
24 35 55 64 81 104 113 92;
49 64 78 87 103 121 120 101;
72 92 95 98 112 100 103 99;];

Chrominance_QM = [
    17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;];

%Quantize Y, Cb, and Cr DCT transformed components
QuantizedY = blockproc(Y_DCT, [8 8], @(block_struct) round(block_struct.data./Luminance_QM));
QuantizedCb = blockproc(Cb_DCT, [8 8], @(block_struct) round(block_struct.data./Chrominance_QM));
QuantizedCr = blockproc(Cr_DCT, [8 8], @(block_struct) round(block_struct.data./Chrominance_QM));

QuantizedBlock1 = QuantizedY(33:40, 1:8);  %First Block in row 5
QuantizedBlock2 = QuantizedY(33:40, 9:16); %Second Block in row 5

%Display the first two Quantized Blocks from the 
%Fifth Row of the Luminance Component
figure(3);
subplot(1,2,1),imshow(QuantizedBlock1, 'XData', [1 8], 'YData', [1 8]);
title('Quantized DCT Block 1:')

subplot(1,2,2),imshow(QuantizedBlock2, 'XData', [1 8], 'YData', [1 8]);
title('Quantized DCT Block 2:')

%(ii)
%ZigZag scanned AC DCT coefficients
QZigZagY = zigzag(QuantizedY);
QZigZagCb = zigzag(QuantizedCb);
QZigZagCr = zigzag(QuantizedCr);
%Zig Zag scan on the Quantized Blocks
QB1ZigZag=zigzag(QuantizedBlock1);
QB2ZigZag=zigzag(QuantizedBlock2);

%Display the Scan Results
figure(4);
subplot(2,1,1),imshow(QB1ZigZag);
title('Zig Zag Scanned Quantized DCT Block 1:')

subplot(2,1,2),imshow(QB2ZigZag);
title('Zig Zag Scanned Quantized DCT Block 2:')


%Decoder:
%(c) Compute the inverse Quantizedimages obtained in Step 
%----------------------------------------------------%

InvQuantizedY = blockproc(QuantizedY, [8 8], @(block_struct) round(block_struct.data.*Luminance_QM));
InvQuantizedCb = blockproc(QuantizedCb, [8 8], @(block_struct) round(block_struct.data.*Chrominance_QM));
InvQuantizedCr = blockproc(QuantizedCr, [8 8], @(block_struct) round(block_struct.data.*Chrominance_QM));

%(d) Reconstruct the image by computing Inverse DCT coefficients.
%----------------------------------------------------%

InvDCTY = blockproc(InvQuantizedY, [8 8], @(block_struct) idct2(block_struct.data));
InvDCTCb = blockproc(InvQuantizedCb, [8 8], @(block_struct) idct2(block_struct.data));
InvDCTCr = blockproc(InvQuantizedCr, [8 8], @(block_struct) idct2(block_struct.data));

InvDCTY=uint8(InvDCTY);

cb_20_rep(608,800) = double(0);
cr_20_rep(608,800) = double(0);

for rows = 1:2:608
    for cols = 1:2:800
        %Loads UpSampledSunViewimg with the Cb and Cr Values 
        cb_20_rep(rows,cols) = InvDCTCb((rows/2)+0.5,(cols/2)+0.5);
        cr_20_rep(rows,cols) = InvDCTCr((rows/2)+0.5,(cols/2)+0.5);      
    end 
end

for cols = 2:2:800
    %Copies the odd columns into the even columns from left to right for
    %the Cb Component
    cb_20_rep(:,cols) = cb_20_rep(:,cols-1);
    
    %Copies the odd columns into the even columns from left to right for
    %the Cr Component
    cr_20_rep(:,cols) = cr_20_rep(:,cols-1);
    
end

for rows = 2:2:600
    %Copies the odd numbered rows into the even rows for the Cb Component
    cb_20_rep(rows,:) = cb_20_rep(rows-1,:);
    
    %Copies the odd numbered rows into the even rows for the Cr Component
    cr_20_rep(rows,:) = cr_20_rep(rows-1,:);   
end

%Removes the extra 8 values on each row
cb_20_rep=cb_20_rep(1:end-8,:);
cr_20_rep=cr_20_rep(1:end-8,:);

%Concatenates Y-Cb-Cr components
UpSampledRowReplicationSunViewimgFinal=cat(3, InvDCTY, cb_20_rep, cr_20_rep);

% Convert to RGB space
RGB_reconstructed = ycbcr2rgb(UpSampledRowReplicationSunViewimgFinal);

figure(5);
imshow(RGB_reconstructed);
title('Reconstructed Image:')


% Show the error image for the Y-component(Luminance)
errorImage = abs(SunViewY - InvDCTY);
figure(6);

%Shows all 0 values as black and all max values as white
imshow(errorImage, [min(errorImage(:)) max(errorImage(:))]);
title('Error Image:');

% Compute the PSNR
MSE_Y = mean(errorImage(:).^2)
PSNR_Y = 10 * log10(255^2/MSE_Y)

%The MSE was calculated to be: 
%   = 3.4578
%The PSNR was calculated to be:
%   = 42.7428


