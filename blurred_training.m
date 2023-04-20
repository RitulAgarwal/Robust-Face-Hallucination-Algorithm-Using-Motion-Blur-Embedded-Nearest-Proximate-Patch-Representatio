function [YH_blurred,YL_blurred] = blurred_training(len,theta,nTraining);
upscale = 4;
disp('blurring thetrainign set')
directory = '/home/avpl/Downloads/TLCR-RL_ORIGINNAL/blurred_training';
mkdir(directory);
for i=1:nTraining
    strh = strcat('./trainingFaces/',num2str(i),'_h.jpg');    
    HI = double(imread(strh)); 
    psf     = fspecial('average', [4 4]); 
    %LI   = imfilter(HI,psf);----result drop
    %%% obtain the LR images
    LI    = imresize(HI,1/upscale,'bicubic'); 
    LI = imresize(LI,size(HI));
    BI = apply_motion_blur(LI,len,theta);
    imwrite(uint8(BI),strcat('./blurred_training/',num2str(i),'_blur.jpg'));  
    YL_blurred(:,:,i) = BI;
    YH_blurred(:,:,i) = HI-BI;
   
end
end