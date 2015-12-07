% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [fishPointsFrame,fishPoints] = ...
    detectFish(vidObj,nFrames,fish,realtime)

fprintf('=== Fish detection ===\n')
count = 0;

% convert fish image to double and grayscale
fish = im2double(fish);
fish = rgb2gray(fish);
% motion average parameter
alpha = 0.8;
% frame difference and transmission map combination parameter
beta = 0.02;
% minimum threshold for transmission map
t0 = 0.1;
% ratios of max and mean pixels to keep in mask
rMean = 2;
rMax = 0.9;
% dilation structure
se = strel('disk',10);
% cell array for holding detected fish feature locations
fishPointsFrame = cell(nFrames,1);
% cell array for holding corresponding locations on fish
fishPoints = cell(nFrames,1);

% find SURF descriptors for fish image
ptsFish = detectFASTFeatures(fish,'MinContrast',0.04);
[featFish,ptsFish] = extractFeatures(fish,[ptsFish.Location],'Method','SURF');

% set first frame as background
CB = fetchFrameColor(vidObj,1);

for idx = 1:nFrames
    count = fprintf([repmat('\b',1,count) 'Starting frame %d, t=%f'], ...
        idx,toc) - count;
    % read in frame
    frame = fetchFrameColor(vidObj,idx);
    frameGray = rgb2gray(frame);
    % stabalize background based on frame
    CB_aug = cat(3,rgb2gray(CB),CB);
    CB_aug = stabalize(CB_aug,frameGray);
    CB = CB_aug(:,:,2:end);
    
    % detect based on difference between current frame and background
    dif = abs(CB_aug(:,:,1) - frameGray);
    thresh = graythresh(dif);
    frameMaskDiff = dif > max(thresh,t0);
    
    % detect based on transmission map
    [~,t,tThresh] = removeHaze(frame);
    % refine transmission based on difference
    tRefine = (1-beta)*t + beta*imclearborder(frameMaskDiff);
    frameMask = tRefine > tThresh;
    % dilation
    stats = regionprops(t > tThresh);
    areas = [stats.Area];
    minArea = round(min(rMean*mean(areas), rMax*max(areas)));
    frameMask = bwareaopen(frameMask,minArea);
    frameMask = imdilate(frameMask,se);
        
    % use mask to find fish feature locations
    [fishPointsFrame{idx},fishPoints{idx}] = ...
        findFish_ModifiedSURF(frameGray,frameMask,ptsFish,featFish);
    
    if realtime
        if ~isempty(fishPointsFrame)
            showMatchedFeatures(fish,frame,fishPoints{idx},fishPointsFrame{idx},'montage')
            title(['Frame ' num2str(idx)])
            snapnow
        end
    end
    
    % update background
    CB = (1-alpha)*CB + alpha*frame;
end

fprintf('\n')