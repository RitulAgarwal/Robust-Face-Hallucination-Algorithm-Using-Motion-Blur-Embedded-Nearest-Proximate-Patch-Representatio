function [im_SR] = reconstruct_patch(im_l,YH,YL,upscale,patch_size,overlap,stepsize,window,tau,K,c)
[imrow, imcol, nTraining] = size(YH);

U = ceil((imrow-overlap)/(patch_size-overlap));  %15
V = ceil((imcol-overlap)/(patch_size-overlap));  %12

Img_SUM      = zeros(imrow,imcol);
overlap_FLAG = zeros(imrow,imcol);
for i = 1:U
  for j = 1:V 
    [im_l_patch XF X BlockSize BlockSizeS] = extract_LPP(im_l,YH,YL,i,j,nTraining,patch_size,overlap,upscale,c,stepsize,K);
    %XF%  size  146,17640 146,10080  146,5760 
    
    nframe = size(im_l_patch',1);
    nbase = size(X',1);%kitne no of patches hai 5760/10080/17640
      % A then XX = sum(A.*A,2) means muliptlication of A array ement by elemtn and then rowwise sum of elements to produce a vector 
      %sum(A,2) operates on successive elements in the rows of A and returns a column vector of the sums of each row.
      %sum(A,1) operates on successive elements in the columns of A and returns a row vector of the sums of each column.
    XX = sum(im_l_patch'.*im_l_patch',2);    
    SX = sum(X'.*X',2); % SZUE US (5760,1)
    D = repmat(XX,1,nbase)-2*im_l_patch'*X+repmat(SX',nframe,1);%SIZE IS (1,5760)
    
    
    [val,index]=sort(D);        
    Xk  = X(:,index(1:K));   %146,500     
    XFk = XF(:,index(1:K));      %144,500
    Dk = D(index(1:K));
    % Compute the optimal weight vector  for the input LR image patch  with the LR training image patches at position（i,j）
    z   =  Xk' - repmat(im_l_patch', K, 1);         
    C   =  z*z';                                                
    C   =  C + tau*diag(Dk)+eye(K,K)*(1e-6)*trace(C);   
    w   =  C\ones(K,1);  
    w   =  w/sum(w);    
    % obtain the HR patch with the same weight vector w
    Img  =  XFk*w; %---144,1
    % integrate all the LR patch        
    Img  =  reshape(Img,patch_size,patch_size);%____SIZE IS (12,12)
    Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))      = Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+Img;%___SIZE IS (120,100)
    overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4)) = overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+1;%___SIZE IS (120,100)
   
  end
end
%  averaging pixel values in the overlapping regions
im_SR = Img_SUM./overlap_FLAG;%__SIZE IS (120,100)
fprintf('\n');