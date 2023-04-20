
function J = apply_motion_blur(I, len, theta)
% I: input image matrix
% len: length of the PSF
% theta: angle of motion blur (in degrees)

% Set seed for reproducibility
rand("seed", 0);

% Check that input image is a matrix
if ~ismatrix(I)
    error('Input image must be a matrix');
end

% Check that len is an odd integer
%if mod(len, 2) == 0
%    error('Length of PSF must be an odd integer');
%end

% Check that theta is a scalar
if ~isscalar(theta)
    error('Angle of motion blur must be a scalar value');
end

% Create motion blur PSF
H = psf_motion(len, theta);

% Apply motion blur to input image using imfilter
J = imfilter(I, H, 'conv', 'circular');
% Check that output image is the same size as input image
if any(size(I) != size(J))
    error('Output image size does not match input image size');
end
end

