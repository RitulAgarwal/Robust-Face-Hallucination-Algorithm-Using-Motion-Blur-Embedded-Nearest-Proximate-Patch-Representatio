
function [len,theta] = motion_blur_estimation(X_MB_L)
  disp('estimating len and theta')
  mean_training_face_link = 'mean_LR_face.jpg';
  mean_training_face    = double(imread(mean_training_face_link));
  ssim_ind = [0,0,0];
  for len = 1:20
    for theta = 0:30
      Y_blur_mean = apply_motion_blur(mean_training_face, len, theta);
      [mssim_val,_] = ssim(X_MB_L,Y_blur_mean);
      if mssim_val > ssim_ind(1)
        ssim_ind = [mssim_val,len,theta];
      end 
    end 
  end
  len = ssim_ind(2)
  theta = ssim_ind(3)
end