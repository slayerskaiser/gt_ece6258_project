% DETECTFISH Detects fish in video through feature matching
%   [framePoints,fishPoints] = DETECTFISH(vidObj,nFrames,fish) detects
%   matching keypoints on each video frame framePoints and the fish image
%   fishPoints. Input is video object vidObj, number of frames to read
%   nFrames, and an image of a single fish.
%   [...] = DETECTFISH(...,realtime) where realtime is a logical input
%   specifies whether to display results in real time
%
% Uses the following methods:
% * perform frame stabalization on previous "constant background" estimate
% and current frame (uses FAST keypoint method and SURF descriptors,
% matches based on minimum SSD with rejection of those with ratio of best
% to second best > 0.6, performs projective transformation on background)
% * generate mask using difference of stabalized background and frame
% * generate second mask using transmission map estimate of current frame
% (use top 1% brightest pixels as threshold)
% * use a combination of both masks (with exclusion of small areas followed
% by dilation) to mask the keypoint detection
% * detect single species of fish using FAST keypoint method and SURF
% descriptors (matches based on minimum SSD with threshold of 5% best)
%
% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [fishPointsFrame,fishPoints] = ...
    detectfish(vidObj,nFrames,fish,realtime)

fprintf('=== Fish detection ===\n')
count = 0;

% input parsing
if ~exist('realtime','var') || isempty(realtime)
    realtime = false;
end

% convert fish image to double and grayscale
fish = im2double(fish);
fishGray = rgb2gray(fish);
% load detection parameters
loadDetectionParameters
% cell array for holding detected fish feature locations
fishPointsFrame = cell(nFrames,1);
% cell array for holding corresponding locations on fish
fishPoints = cell(nFrames,1);

% find SURF descriptors for fish image
ptsFish = detectFASTFeatures(fishGray,'MinContrast',0.04);
[featFish,ptsFish] = extractFeatures(fishGray,[ptsFish.Location], ...
    'Method','SURF');

% set first frame as background
CB = fetchFrameColor(vidObj,1);

for idx = 1:nFrames
    % display progress
    count = fprintf([repmat('\b',1,count) 'Starting frame %d, t=%f'], ...
        idx,toc) - count;
    
    % read in frame
    frame = fetchFrameColor(vidObj,idx);
    frameGray = rgb2gray(frame); % convert to grayscale
    
    % stabalize background based on frame
    CB_aug = cat(3,rgb2gray(CB),CB); % aug. matrix of grayscale and RGB
    CB_aug = stabalize(CB_aug,frameGray); % stabalize aug. matrix
    CB = CB_aug(:,:,2:end); % extract RGB channels
    
    % detect based on difference between current frame and background
    dif = abs(CB_aug(:,:,1) - frameGray); % difference of grayscale
    thresh = graythresh(dif); % Otsu's method threshold
    frameMaskDiff = dif > max(thresh,t0); % threshold with min. of t0
    
    % detect based on transmission map
    %
    % t is transmission map without Levin's softening
    % tThresh returns top 1% brightest
    [~,t,tThresh] = removeHaze(frame);
    % refine transmission based on difference
    tRefine = (1-Beta)*t + Beta*imclearborder(frameMaskDiff);
    frameMask = tRefine > tThresh;
    % remove small regions in mask (based on mean and max areas of regions)
    stats = regionprops(t > tThresh);
    areas = [stats.Area];
    minArea = round(min(rMean*mean(areas), rMax*max(areas)));
    frameMask = bwareaopen(frameMask,minArea);
    % dilate mask
    frameMask = imdilate(frameMask,se);
        
    % use mask to find fish feature locations
    [fishPointsFrame{idx},fishPoints{idx}] = ...
        findFish_ModifiedSURF(frameGray,frameMask,ptsFish,featFish);
    
    % update results in real time if applicable
    if realtime
        if ~isempty(fishPointsFrame)
            showMatchedFeatures(fish,frame,fishPoints{idx}, ...
                fishPointsFrame{idx},'montage')
            title(['Frame ' num2str(idx)])
            snapnow
        end
    end
    
    % update color background
    CB = (1-Alpha)*CB + Alpha*frame;
end

fprintf('\n')