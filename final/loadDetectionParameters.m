% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Common detection parameters

% motion average parameter
alpha = 0.8;
Alpha = alpha; % to fix calling of alpha.m
% frame difference and transmission map combination parameter
beta = 0.02;
Beta = beta; % to fix calling of beta.m
% minimum threshold for movement detection
t0 = 0.1;
% ratios of max and mean pixels to keep in mask
rMean = 2;
rMax = 0.9;
% dilation structure
se = strel('disk',10);