% Demo for BOOST denoising and PLOF quantification
% Please cite this article if the code is useful in your research:
% Boosting quantification accuracy of chemical exchange saturation transfer
% MRI with a spatial-spectral redundancy based denoising method
% Code arthor: Xinran Chen (chenxinran@stu.xmu.edu.cn), Lin Chen
%              (chenlin21@xmu.edu.cn)
%==========================================================================
% BOOST denoising
% PLOF curve fitting
% PLOF mapping
%==========================================================================
clc;
clear;
close all;
addpath(genpath('tensor_lib'));
addpath(genpath('PLOF'))
addpath(genpath('evaluate'))
addpath ./ColorMap
addpath ./data_CEST
addpath ./RiceOptVST
addpath ./BOOST_algorithm
dataRoad = ['data_CEST/'];
ROI_number = 2; % ROIs for PLOF curve fitting
addpath ./assess_fold
% define colormap for drawing ROIs
color_all = [112, 48, 160; 255, 192, 0; ...
    91, 155, 213; 146, 208, 80; ...
    192, 0, 0; 255, 230, 153; 214, 143, 233; ...
    63, 67, 229] / 255;

%% load data (noisy & original)

%----------------------------------------------load image---------------------------------------------------------

load('Noisy_Cr_Data.mat'); % load noisy CEST images (noise level: 1%)
load('Cr_Data.mat'); % load original CEST images
load('Freq_list.mat') % load frequency offset list

%% BOOST denoising part
% %--------------------------------------------data normalize-----------------------------------------------------
CEST_image_noisy = normalized(CEST_image_noisy); % Normalize the data into the range of 0~1
Original_CEST_image = normalized(Original_CEST_image);
% %----------------------------------------------denoising-----------------------------------------------------
% If a gold standard (noise-free CEST image) is absent here, you can
% replace the Original_CEST_image as CEST_image_noisy
% Two main parameters for great denoising performance:the noise level and
% subspace dimension. You can modify these two parameters if you're not
% satisfied with the outcome.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% noise level nSig: higher value means stronger spatial constraint
% subspace dimension k_subspace: higher value means weaker spectral
%                                constraint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[output_image, CEST_image_noisy] = BOOST_denoising_main(CEST_image_noisy, Original_CEST_image, Freq);

%% imshow
imshow3dimage(abs(output_image - CEST_image_noisy));
title('Difference map');
imshow3dimage(abs(Original_CEST_image));
title('Original CEST images');
imshow3dimage(abs(CEST_image_noisy));
title('Noisy CEST images');
imshow3dimage(abs(output_image));
title('Denoised CEST images');

%% PLOF curve fitting part
output_image = double(output_image);
FitParam.paramdir = [cd, filesep, 'FittingResult']; % save directory
FitParam.satpwr = 2;
FitParam.tsat = 1; %s
FitParam.Magfield = 42.58 * 11.7;
FitParam.ifshowimage = 1;
FitParam.R1 = 1 / 1.9;
FitParam.PeakOffset = 2; % Cr
FitParam.WholeRange = [-1, 1] + FitParam.PeakOffset;
FitParam.PeakRange = [-0.4, 0.4] + FitParam.PeakOffset;

M0image = mean(abs(Original_CEST_image(:, :, Freq > 100)), 3);
Mask = ChooseMask_multi_ROI(M0image, [dataRoad, filesep, 'different ROI for Z spectra'], 'ROI for Z spectra', 'Choose ROI', ROI_number, color_all);

FitParam.name = ['Original ROI '];
Flag = FitParam.name;
for xx = 1:ROI_number
    PLOFCruveFitting_3(Original_CEST_image, Freq, Flag, FitParam, Mask(:, :, xx)); title([Flag, ' ', num2str(xx)])
end

FitParam.name = ['Noisy ROI '];
Flag = FitParam.name;
for xx = 1:ROI_number
    PLOFCruveFitting_3(CEST_image_noisy, Freq, Flag, FitParam, Mask(:, :, xx)); title([Flag, ' ', num2str(xx)])
end

FitParam.name = ['BOOST for ROI '];
Flag = FitParam.name;
for xx = 1:ROI_number
    PLOFCruveFitting_3(abs(output_image), Freq, Flag, FitParam, Mask(:, :, xx)); title([Flag, ' ', num2str(xx)])
end

%% PLOF mapping part
load(['data_CEST', filesep, 'T1Map.mat'])
Mask_2 = zeros(size(T1map, 1), size(T1map, 2));
Mask_2(T1map(:, :) > 0) = 1;

FitParam.name = ['Original'];
[original_DeltaZmap, original_Rmap] = PLOFMapFitting(abs(Original_CEST_image), Freq, FitParam, Mask_2, T1map);

FitParam.name = ['Noisy'];
[noisy_DeltaZmap, noisy_Rmap] = PLOFMapFitting(abs(CEST_image_noisy), Freq, FitParam, Mask_2, T1map);

FitParam.name = ['BOOST'];
[mine_DeltaZmap, BOOST_Rmap] = PLOFMapFitting(abs(output_image), Freq, FitParam, Mask_2, T1map);
figure;
subplot(2, 2, 1);
imshow(original_Rmap, [], 'InitialMagnification', 'fit');
mycolorbar;
colormap(magma);
caxis([0, 0.18]);
title('Original Rmap')
subplot(2, 2, 3);
imshow(BOOST_Rmap, [], 'InitialMagnification', 'fit');
mycolorbar;
colormap(magma);
caxis([0, 0.18]);
title('BOOST Rmap')
subplot(2, 2, 2);
imshow(noisy_Rmap, [], 'InitialMagnification', 'fit');
mycolorbar;
colormap(magma);
caxis([0, 0.18]);
title('Noisy Rmap')
