% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Common detection parameters

% motion average parameter
alpha = 0.8;
% frame difference and transmission map combination parameter
beta = 0.02;
% minimum threshold for movement detection
t0 = 0.1;
% ratios of max and mean pixels to keep in mask
rMean = 2;
rMax = 0.9;
% dilation structure
se = strel('disk',10);