clc;close all;clear all;
addpath('./utilities');
addpath('./NMF-master');

nTraining   = 360;        % number of training sample
nTesting    = 40;         % number of ptest sample
upscale     = 4;          % upscaling factor 
patch_size  = 12;         % image patch size
overlap     = 4;          % the overlap between neighborhood patches
stepsize    = 2;          % step size

% parameter settings
window      = 20;         % contextal patch,12, 16, 20, 24, 28, ... (12 means us no contextal information)
K           = 500;        % thresholding parameter
tau         = 0.04;       % locality constraint parameter
layer       = 5;          % the iteration value in reproducing learning
c           = 10;         % the weight of the spatial feature
%[YH YL] = Training_LH(upscale,nTraining);

for TestImgIndex = 1:nTesting
    fprintf('\nProcessing  %d_test.jpg\n', TestImgIndex);
    % read ground truth of one test face 
    strh    = strcat('./test/',num2str(TestImgIndex),'_h.jpg');
    test = double(imread(strh));
    X_MB_L = first(test,upscale);
    tic;
    [len,theta] = motion_blur_estimation(X_MB_L,nTraining);
    [YH_blurred,YL_blurred] = blurred_training(len,theta,nTraining);
    
    final_im = reconstruct_patch(X_MB_L,YH_blurred,YL_blurred,upscale,patch_size,overlap,stepsize,window,tau,K,c);
    final_im = final_im + X_MB_L;
    
    cputime(TestImgIndex) = toc;
    imwrite(uint8(final_im),'final.jpg');
    % compute PSNR and SSIM for Bicubi,c and TLcR method
    blur_psnr(TestImgIndex) = psnr(final_im,test)
    blur(TestImgIndex) = ssim(final_im,test)
end


fprintf('===============================================\n');
fprintf('Average PSNR for blur:  %f dB\n', sum(blur_psnr)/nTesting);
fprintf('Average SSIM for blur:  %f dB\n', sum(blur)/nTesting);
fprintf('===============================================\n');
