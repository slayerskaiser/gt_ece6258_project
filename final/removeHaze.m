% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [J,t,tMask] = removeHaze(frame,soften)
% remove "haze" due to water absorption and scattering from frame, using:
% Single Image Haze Removal using Dark Channel Prior, by Kaiming He, Jian Sun, and Xiaoou Tang, in CVPR 2009

% default to not softening matting due to time and memory constraints
if ~exist('soften','var') || isempty(soften)
    soften = false;
end

% size of frame
[height,width,nColors] = size(frame);
% lower bound on transmission
t0 = 0.1;

% estimate transmission
blockSize = 15; % size of sliding patch
omega = 0.95; % parameter to adjust haze based on distance
t = zeros([height width nColors]);
for idx = 1:nColors
    minRow = colfilt(frame(:,:,idx),'indexed',[1 blockSize],'sliding',@min);
    t(:,:,idx) = 1 - omega*colfilt(minRow,'indexed',[blockSize 1],'sliding',@min);
end
t = min(t,[],3);

% soft matting using Levin's matting Laplacian matrix
if soften
    window = [3 3];
    lambda = 1e-4;
    mask = abs(rgb2gray(frame) - t);
    mask = mask < graythresh(mask);
    L = mattingLaplacian(frame,window,mask);
    L = L + lambda*speye(height*width);
    M = ichol(L,struct('type','ict','droptol',1e-3,'diagcomp',max(diag(L)),'michol','on'));
    [t,~] = pcg(L,lambda*t(:),1e-3,height*width,M,M');
    t = reshape(t,height,width);
end

% estimate atmospheric light
%
% get 0.01% brightest in transmission map
tSort = sort(t(:),1,'descend');
Nt = ceil(0.001*numel(t));
tMask = t > tSort(Nt);
% get average of unmasked values
A = zeros(nColors,1);
for idx = 1:nColors
    A(idx) = mean(frame(tMask));
end

% scene radiance
J = zeros([height width nColors]);
for idx = 1:nColors
    J(:,:,idx) = (frame(:,:,idx) - A(idx))./max(t,t0) + A(idx);
end