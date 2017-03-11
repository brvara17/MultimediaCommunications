%Compe565 Homework 1
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
%Project 1 COMPE 565                                                  %
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


%Part 1:
%----------------------------------------------------%
%Read image into 3 dimensional arrray rgbImageSunView.
%----------------------------------------------------%
rgbImageSunView = imread('SunView.jpg','jpg');

%Display JPG image SunView 
imshow(rgbImageSunView); %Figure1
title('Original Image:');


%Part2:
%----------------------------------------------------%
%Display each band (Red, Green and Blue) of the image.
%----------------------------------------------------%
%Store and Display Red Band of Image File
SunViewRed(600,800,3) = uint8(0);
SunViewRed(:,:,1) = rgbImageSunView(:,:,1);
figure(2), subplot(3,1,1), imshow(SunViewRed); %Figure2
title('RGB: Red Band');

%Store and Display Green Band of Image File
SunViewGreen(600,800,3) = uint8(0);
SunViewGreen(:,:,2) = rgbImageSunView(:,:,2);
figure(2), subplot(3,1,2), imshow(SunViewGreen); %Figure2
title('RGB: Green Band');

%Store and Display Blue Band of Image File
SunViewBlue(600,800,3) = uint8(0);
SunViewBlue(:,:,3) = rgbImageSunView(:,:,3);
figure(2), subplot(3,1,3), imshow(SunViewBlue); %Figure2
title('RGB: Blue Band');


%Part 3:
%----------------------------------------------------%
%Convert the image into YCbCr color space
%----------------------------------------------------%
SunViewYCbCr = rgb2ycbcr(rgbImageSunView);
figure(3),imshow(SunViewYCbCr);
title('RGB Image to YCbCr Format:');


%Part 4:
%----------------------------------------------------%
%Display each band separately (Y, Cb and Cr bands)
%----------------------------------------------------%

%Store and Display Y Band of Image File
SunViewY = SunViewYCbCr(:,:,1);
figure(4),subplot(3,1,1),imshow(SunViewY); %Figure4
title('YCbCr Image: Y Band');

%Store and Display Cb Band of Image File
SunViewCb = SunViewYCbCr(:,:,2);
figure(4),subplot(3,1,2),imshow(SunViewCb); %Figure4
title('YCbCr Image: Cb Band');

%Store and Display Cr Band of Image File
SunViewCr = SunViewYCbCr(:,:,3);
figure(4),subplot(3,1,3),imshow(SunViewCr); %Figure4
title('YCbCr Image: Cr Band');


%Part 5:
%----------------------------------------------------%
%Subsample Cb and Cr bands using 4:2:0 and display both bands
%----------------------------------------------------%

%Subsampling Cb using 4:2:0
CbSubSample420=SunViewCb(1:2:end, 1:2:end);

%Display Cb subsampled using 4:2:0
figure(5),subplot(2,1,1),imshow(CbSubSample420); %Figure5
title('4:2:0 Subsampled Cb Component:');

%Subsampling Cr using 4:2:0
CrSubSample420=SunViewCr(1:2:end, 1:2:end);

%Display Cr subsampled using 4:2:0
figure(5),subplot(2,1,2),imshow(CrSubSample420); %Figure5
title('4:2:0 Subsampled Cr Component:');

%Part 6:
%----------------------------------------------------%
%Upsample and display the Cb and Cr bands using:
%6.1 Linear interpolation. 
%6.2 Simple row or column replication.
%----------------------------------------------------%

%6.1. Linear interpolation 
%----------------------------------------------------%

%Creates a temperary 600x800x3 dimensional array with all zeroes
UpSampledInterpolationSunViewimg(600,800,3) = uint16(0);

for rows = 1:2:600
    for cols = 1:2:800
        %Loads UpSampledSunViewimg with the downsampled Cb and Cr Values 
        UpSampledInterpolationSunViewimg(rows,cols,2) = CbSubSample420((rows/2)+0.5,(cols/2)+0.5);
        UpSampledInterpolationSunViewimg(rows,cols,3) = CrSubSample420((rows/2)+0.5,(cols/2)+0.5);      
    end 
end


for rows = 1:2:600
    for cols = 3:2:800
        %Loads UpSampledSunViewimg with the Cb Values Using Linear
        %Interpolation
        UpSampledInterpolationSunViewimg(rows,cols-1,2) = (UpSampledInterpolationSunViewimg(rows,cols,2) + UpSampledInterpolationSunViewimg(rows,cols-2,2))/2;
        
        %Loads UpSampledSunViewimg with the Cr Values Using Linear
        %Interpolation
        UpSampledInterpolationSunViewimg(rows,cols-1,3) = (UpSampledInterpolationSunViewimg(rows,cols,3) + UpSampledInterpolationSunViewimg(rows,cols-2,3))/2;     
    end 
end

for rows = 3:2:600
    for cols = 1:800
        %Loads UpSampledSunViewimg with the Cb Values Using Linear
        %Interpolation
        UpSampledInterpolationSunViewimg(rows-1,cols,2) = (UpSampledInterpolationSunViewimg(rows,cols,2) + UpSampledInterpolationSunViewimg(rows-2,cols,2))/2;
        
        %Loads UpSampledSunViewimg with the Cr Values Using Linear
        %Interpolation
        UpSampledInterpolationSunViewimg(rows-1,cols,3) = (UpSampledInterpolationSunViewimg(rows,cols,3) + UpSampledInterpolationSunViewimg(rows-2,cols,3))/2;     
    end 
end

%Reconstructing the Y band of the image
UpSampledInterpolationSunViewimg = uint8(UpSampledInterpolationSunViewimg);
UpSampledInterpolationSunViewimg(:,:,1) = SunViewY;
imshow(UpSampledInterpolationSunViewimg);

%6.2. Simple row or column replication.
%----------------------------------------------------%

%Creates a temperary 600x800x3 dimensional array with all zeroes
UpSampledRowReplicationSunViewimg(600,800,3) = uint16(0);

for rows = 1:2:600
    for cols = 1:2:800
        %Loads UpSampledSunViewimg with the Cb and Cr Values 
        UpSampledRowReplicationSunViewimg(rows,cols,2) = CbSubSample420((rows/2)+0.5,(cols/2)+0.5);
        UpSampledRowReplicationSunViewimg(rows,cols,3) = CrSubSample420((rows/2)+0.5,(cols/2)+0.5);      
    end 
end

for cols = 2:2:800
    %Copies the odd columns into the even columns from left to right for
    %the Cb Component
    UpSampledRowReplicationSunViewimg(:,cols,2) = UpSampledRowReplicationSunViewimg(:,cols-1,2);
    
    %Copies the odd columns into the even columns from left to right for
    %the Cr Component
    UpSampledRowReplicationSunViewimg(:,cols,3) = UpSampledRowReplicationSunViewimg(:,cols-1,3);
    
end

for rows = 2:2:600
    %Copies the odd numbered rows into the even rows for the Cb Component
    UpSampledRowReplicationSunViewimg(rows,:,2) = UpSampledRowReplicationSunViewimg(rows-1,:,2);
    
    %Copies the odd numbered rows into the even rows for the Cr Component
    UpSampledRowReplicationSunViewimg(rows,:,3) = UpSampledRowReplicationSunViewimg(rows-1,:,3);   
end

%Reconstructing the Y Band for Row Replication
UpSampledRowReplicationSunViewimg = uint8(UpSampledRowReplicationSunViewimg);
UpSampledRowReplicationSunViewimg(:,:,1) = SunViewY;

%Part 7: 
%----------------------------------------------------%
%Convert the image into RGB format. 
%----------------------------------------------------%

%Converting the image upsampled using linear interpolation from YCbCr
%format to RGB
UpSampledInterpolationSunViewimgRGB = ycbcr2rgb(UpSampledInterpolationSunViewimg);

%Converting the image upsampled using Row Replication from YCbCr
%format to RGB
UpSampledRowReplicationSunViewimgRGB = ycbcr2rgb(UpSampledRowReplicationSunViewimg);


%Part 8
%----------------------------------------------------%
%Display Images in RGB format
%----------------------------------------------------%

%Original Image
figure(6),subplot(1,3,1),imshow(rgbImageSunView);
title('Original Image:');

%Linear Interpolation
figure(6),subplot(1,3,2),imshow(UpSampledInterpolationSunViewimgRGB);
title('Linear Interpolation Upsampled RGB Image');

%RowColumnReplication
figure(6),subplot(1,3,3),imshow(UpSampledRowReplicationSunViewimgRGB);
title('Row Replication Upsampled RGB Image');


%Part 9:
%----------------------------------------------------%
%Comment on the visual quality of the reconstructed image for 
%both the upsampling  cases. See rsults section in 
%word document for analysis:
%----------------------------------------------------%


%Part 10:
%----------------------------------------------------%
%Measure MSE between the original and reconstructed 
%images (obtained using linear interpolation only).
%See results section in word document for analysis:
%----------------------------------------------------%

ForiginalR = double(rgbImageSunView(:,:,1));
ForiginalG = double(rgbImageSunView(:,:,2));
ForiginalB = double(rgbImageSunView(:,:,3));

FprimeR = double(UpSampledInterpolationSunViewimgRGB(:,:,1)); 
FprimeG = double(UpSampledInterpolationSunViewimgRGB(:,:,2)); 
FprimeB = double(UpSampledInterpolationSunViewimgRGB(:,:,3)); 

MSE_R = double(0);
MSE_G = double(0);
MSE_B = double(0);
for rows = 1:600
    for cols = 1:800
        
        MSE_R = MSE_R + (ForiginalR(rows,cols) - FprimeR(rows,cols)).^2;
        MSE_G = MSE_G + (ForiginalG(rows,cols) - FprimeG(rows,cols)).^2;
        MSE_B = MSE_B + (ForiginalB(rows,cols) - FprimeB(rows,cols)).^2;
        
    end
end

MSE_R = (1/(600*800))*MSE_R;
MSE_G = (1/(600*800))*MSE_G;
MSE_B = (1/(600*800))*MSE_B;

MSE = (MSE_R + MSE_G + MSE_B)/3;


%MSE value calculated to be 53.1908

%Part 11:
%----------------------------------------------------%
%Comment on the compression ratio achieved by subsampling 
%Cb and Cr components for 4:2:0 approach. Please note that 
%you do not send the pixels which are made zero in the row 
%and columns during subsampling. 
%See results section in word document for analysis:
%----------------------------------------------------%

before =  600*800*3;
after = (size(SunViewY,1) * size(SunViewY,2)) + (size(CbSubSample420,1) * size(CbSubSample420,2)) + (size(CrSubSample420,1) * size(CrSubSample420,2));
Compression_Ratio = before / after;

%Compression Ratio calculated to be 2


