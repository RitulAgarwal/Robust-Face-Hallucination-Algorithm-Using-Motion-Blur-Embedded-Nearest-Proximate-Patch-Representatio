function Y = Reshape3D_20Connection(X,B,stepsize)

patch_size = B(2)+1-B(1); %% expectde 12 % stepsize = 2;
Y = [];
for i = -6:stepsize:6
    for j = -6:stepsize:6
        if i==0&&j==0
            temp = reshape(X(B(1):B(2),B(3):B(4),:),patch_size*patch_size,size(X,3)); % SIZE is (144,360)
        elseif B(1)+i>0 && B(1)+i+patch_size-1<=size(X,1)&&B(3)+j>0 && B(3)+j+patch_size-1<=size(X,2)
            tB = [B(1)+i B(1)+i+patch_size-1 B(3)+j B(3)+j+patch_size-1];
            tX = X(tB(1):tB(2),tB(3):tB(4),:);  % SIZE IS (12,12,360)
            tX = reshape(tX,patch_size*patch_size,size(X,3));% SIZE IS (144,360)
            Y = [Y tX]; % size is (144,360) keeps on adding 360 in every step and adding forms inally (144,5400) 

            end
    end
end

Y = [temp Y];% dinally its 144,5760 after again 360 additipm 

