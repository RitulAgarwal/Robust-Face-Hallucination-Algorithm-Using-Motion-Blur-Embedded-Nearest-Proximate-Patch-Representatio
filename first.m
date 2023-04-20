function [output] = first(input,upscale)
  %input = double(imread(im_link));
  len = 21;
  theta = 30;
  if len == 0 
    len = 1 
  end
  input = apply_motion_blur(input,len,theta);
  %input = imresize(input,[120,100]);
  input    = imresize(input,1/upscale,'bicubic');
  input = imresize(input,upscale,'bicubic');
  imwrite(uint8(input),'X_Mb_L.jpg');
  output = input ;

end