function [output_image, CEST_image_noisy] = BOOST_denoising_main(CEST_image_noisy, Original_CEST_image, Freq)
% Please cite this article if the code is useful in your research:
% Boosting quantification accuracy of chemical exchange saturation transfer
% MRI with a spatial-spectral redundancy based denoising method
%==========================================================================
% Step 1: Noise level estimination
% Step 2: VST transform: inorder to transfer the Rician noise distributed
% data into Gaussian noise distributed data
% Step 3: BOOST denoising
% Step 4: inverse VST transform
%==========================================================================
[M, N, p] = size(CEST_image_noisy);

%% Step 1: Rician noise estimation (estimate the noise level of the noisy CEST image)
disp('---------------------------------------------------------------');
disp(' * Estimating noise level sigma   [ model  z ~ Rice(nu,sigma) ]');
estimate_noise_printout = 1; %% print-out estimation
sigma_hat = riceVST_sigmaEst(CEST_image_noisy, estimate_noise_printout);
disp(' --------------------------------------------------------------');
disp([' sigma_hat = ', num2str(sigma_hat)]);
disp('---------------------------------------------------------------');

%% Step 2: VST transform
VST_ABC_denoising = 'A'; %% VST pair to be used before and after denoising (for forward and inverse transformations)
disp(' * Applying variance-stabilizing transformation')
disp('---------------------------------------------------------------');
disp(' * Denoising with Gaussian my method ...  (may take a while)')
fz = riceVST(CEST_image_noisy, sigma_hat, VST_ABC_denoising); %%  apply variance-stabilizing transformation
% apply affine transformation to scale the data to a range well within [0,1]
maxfz = max(fz(:)); %% first put data into [0,1] ...
minfz = min(fz(:));
fz = (fz - minfz) / (maxfz - minfz);
sigmafz = sigma_hat; % (scale standard-deviation accordingly)

%% Step 3: BOOST denoising part
addpath('BOOST_algorithm');
tic
% Pay attention: the noiselevel (Par.nSig) and the subspace dimension
% (Par.k_subspace) play significant roles in BOOST denoising. You can
% modify the two parameters by yourself if you're not satified with the
% automatical outcome.
Par = ParSet_BOOST(sigmafz, fz);
Par.maxfz = maxfz;
Par.minfz = minfz;
[D] = BOOST_DeNoising_AM(fz, Original_CEST_image, Par, Freq');
BOOST_time = toc;

%% Step 4: inverse VST transform
D = D * (maxfz - minfz) + minfz;
% Inverse VST transform
output_image = riceVST_EUI(D, sigma_hat, VST_ABC_denoising);
disp('---------------------------------------------------------------');
disp(' BOOST denoising finished');
disp('---------------------------------------------------------------');
[BOOST_PSNR, BOOST_SSIM, BOOST_SAM] = evaluate(Original_CEST_image, output_image, M, N);
disp(['Method Name:BOOST    ', ', MPSNR=', num2str(mean(BOOST_PSNR), '%5.2f'), ...
    ',MSSIM = ', num2str(mean(BOOST_SSIM), '%5.4f'), ',SAM=', num2str(BOOST_SAM, '%5.2f'), ...
    ',Time=', num2str(mean(BOOST_time), '%5.2f')]);
end