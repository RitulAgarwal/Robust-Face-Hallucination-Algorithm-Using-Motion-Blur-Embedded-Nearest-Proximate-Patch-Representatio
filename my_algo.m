clc;close all;clear all;
addpath('./utilities');

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

[YH YL] = Training_LH(upscale,nTraining);
test_face = 'perfect.jpg';
X_MB_L = first(test_face,upscale);
imwrite(uint8(X_MB_L),'X_MB_L.jpg');  

[len,theta] = motion_blur_estimation(X_MB_L);
[YH_blurred,YL_blurred] = blurred_training(len,theta,nTraining);
final_im = reconstruct_patch(X_MB_L,YH_blurred,YL_blurred,upscale,patch_size,overlap,stepsize,window,tau,K,c);
final_im = final_im + X_MB_L;
imwrite(uint8(final_im),'result.jpg');  

[mssim2,_] = ssim(final_im,double(imread(test_face)));
mssim2

psnr = psnr(final_im,double(imread(test_face)));
psnr