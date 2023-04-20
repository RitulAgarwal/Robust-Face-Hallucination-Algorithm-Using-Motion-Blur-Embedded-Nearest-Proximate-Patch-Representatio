function [im_l_patch XF X BlockSize BlockSizeS]= extract_LPP(im_l,YH,YL,i,j,nTraining,patch_size,overlap,upscale,c,stepsize,K)
[imrow, imcol, _] = size(YH);
BlockSize  =  GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j);    

if size(YL,1) == size(YH,1)
    BlockSizeS =  GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j);  
else
    BlockSizeS =  GetCurrentBlockSize(size(YL,1),size(YL,2),patch_size/upscale,overlap/upscale,i,j);  % obtain the current patch position
end

% obtain the current patch feature
im_l_patch =  im_l(BlockSizeS(1):BlockSizeS(2),BlockSizeS(3):BlockSizeS(4));%SIZE___(12,12)          % extract the patch at position（i,j）of the input LR face     
im_l_patch =  im_l_patch(:);  %SIZE___(144,1)
im_l_patch = im_l_patch-mean(im_l_patch); %SIZE___(144,1)
im_l_patch = [im_l_patch;0;0]; %SIZE___(146,1)    (0,0) is the spatial information of current LR patch
size(im_l_patch);
%SIZE OF X_MB_L PATCH IS (146,1) now
XF = Reshape3D_20Connection(YH,BlockSize,stepsize);% SIZE ---- (144,5760)---HRPATCHES 
X  = Reshape3D_20Connection_Spatial(YL,BlockSizeS,stepsize,c);  % SIZE --- (146,5760)---- LR PATCHES
X(1:end-2,:) = X(1:end-2,:)-repmat(mean(X(1:end-2,:)),size(X(1:end-2,:),1),1);   
  
