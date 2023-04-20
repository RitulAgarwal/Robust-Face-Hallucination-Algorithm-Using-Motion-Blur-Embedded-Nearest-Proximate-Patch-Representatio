function Y = Reshape3D_20Connection_Spatial(X,B,stepsize,c)

patch_size = B(2)+1-B(1);
% stepsize = 2;
Y = [];
for i = -6:stepsize:6
    for j = -6:stepsize:6
        if i==0&&j==0
            temp = reshape(X(B(1):B(2),B(3):B(4),:),patch_size*patch_size,size(X,3));% SIZE IS (144,360)
            
            temp = [temp;repmat(c*[abs(j) abs(i)]',1,size(X,3))];% sombine the spatial feature  (146,360)
            
        elseif B(1)+i>0 && B(1)+i+patch_size-1<=size(X,1)&&B(3)+j>0 && B(3)+j+patch_size-1<=size(X,2)
            tB = [B(1)+i B(1)+i+patch_size-1 B(3)+j B(3)+j+patch_size-1];
    
            tX = X(tB(1):tB(2),tB(3):tB(4),:); % sIZE (12,12,360)
         
            tX = reshape(tX,patch_size*patch_size,size(X,3)); % SIZE(144,360)
          
            tX = [tX;repmat(c*[abs(j) abs(i)]',1,size(X,3))]; % sombine the spatial feature----(146,360)
         
            Y = [Y tX];%SIZE IS (146,360) and then adding till 146,5400
           
        end
    end
end

Y = [temp Y];%___SIZE IS (146,5760) or (146,17640) or (146,10080) depending upon patch postooin 
disp('fina;')
size(Y)