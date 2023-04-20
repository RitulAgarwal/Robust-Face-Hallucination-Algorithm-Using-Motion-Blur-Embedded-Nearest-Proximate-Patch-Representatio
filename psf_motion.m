
function H = psf_motion(len, theta)
% len: length of the PSF
% theta: angle of motion blur (in degrees)

% Set seed for reproducibility
rand("seed", 0);

% Convert angle to radians
theta = deg2rad(theta);

% Create grid of coordinates
[x, y] = meshgrid(-floor(len/2):floor(len/2));

% Compute PSF
d = x * cos(theta) + y * sin(theta);
H = sinc(d) .* (abs(d) <= (len-1)/2);
sum = sum(H(:));
% Normalize PSF
if sum == 0
  sum = eps;
end 

H = H / sum;

end