% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [fishPointsFrame,fishPoints] = ...
    detectFish(vidObj,nFrames,fish,fishMask)

fprintf('=== Fish detection ===\n')
count = 0;

% convert fish image to double
fish = im2double(fish);
% size of frames
height = vidObj.Height;
width = vidObj.Width;
% motion average parameter
alpha = 0.8;
% minimum threshold
t0 = 0.1;
% cell array for holding detected fish feature locations
fishPointsFrame = cell(nFrames,1);
% cell array for holding corresponding locations on fish
fishPoints = cell(nFrames,1);

% set first frame as background
CB = fetchFrameColor(vidObj,1);

for idx = 1:nFrames
    count = fprintf([repmat('\b',1,count) 'Starting frame %d, t=%f'], ...
        idx,toc) - count;
    % read in frame
    frame = fetchFrameColor(vidObj,idx);
    % stabalize background based on frame
    CB_aug = cat(3,rgb2gray(CB),CB);
    CB_aug = stabalize(CB_aug,rgb2gray(frame));
    CB = CB_aug(:,:,2:end);
    
    % detect based on difference between current frame and background
    dif = abs(removeHaze(CB_aug(:,:,1)) - removeHaze(rgb2gray(frame)));
    thresh = graythresh(dif);
    frameMaskDiff = dif > max(thresh,t0);
    
    % detect based on transmission map
    [frameDehaze,t,tMask] = removeHaze(frame);
    % dilation radius
    R = min(ceil(sqrt(nnz(tMask))),2000);
    frameMaskMap = imdilate(tMask,strel('disk',R));
    
    % combine the masks
    frameMask = frameMaskDiff & frameMaskMap;
    
    % use mask to find fish feature locations
    [fishPointsFrame{idx},fishPoints{idx}] = ...
        findMatch_ModifiedSURF(rgb2gray(frame),rgb2gray(fish),'SURF', ...
        double(frameMask),uint8(fishMask));
%     fishPoints{idx} = t;
%     fishPointsFrame{idx} = CB;
    
    % update background
    CB = (1-alpha)*CB + alpha*frame;
end

fprintf('\n')