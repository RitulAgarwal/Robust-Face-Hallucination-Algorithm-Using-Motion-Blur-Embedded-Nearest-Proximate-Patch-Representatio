function [XH XL] = Training_LH(upscale,nTraining)
%%% construct the HR and LR training pairs from the FEI face database
disp('Constructing the HR-LR training set...');
psf = fspecial('average', [4 4]); 
mean_Training_face = 0 ;
for i = 41:nTraining+40
    %%% read the HR face images
    strh = strcat('./train1/',num2str(i),'_h.jpg');    
    HI = double(imread(strh)); 
    LI    = imresize(HI,1/upscale,'bicubic'); 
    LI = imresize(LI,size(HI));
    mean_Training_face += LI ;
    
    XL(:,:,i) = LI; 
    XH(:,:,i) = (HI-LI);

end
mean_LR_TRANING_FACE = mean_Training_face/nTraining;
imwrite(uint8(mean_LR_TRANING_FACE),'mean_LR_face.jpg'); 
