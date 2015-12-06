% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [fish,fishmask] = genFish(filename,NM)
% given image file with fish on blackbackground, resize image to match
% scene and generate mask for fish

% get fish image and resize
fish = imread(filename);
fish = imresize(fish,NM);

% generate mask
fishmask = ~(rgb2gray(fish) == 0);
% estimate of number of pixels in fish
N = round(0.9*numel(find(fishmask)));
% remove small clusters
fishmask = bwareaopen(fishmask,N);
% erode based on min. cluster size of 8
fishmask = imerode(fishmask,ones(8));
% repeat removal of small clusters
fishmask = bwareaopen(fishmask,N);