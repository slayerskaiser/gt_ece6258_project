% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Compare effect of refining of transmission map on masking
% NOTE THIS NEEDS AT LEAST 8 GB OF FREE MEMORY

clear
close all

%% Read current and previous frame; generate mask

filename = 'videos/GOPR0059.MP4';
vidObj = VideoReader(filename);

% use 3rd frame as current
idx = 3;
% load detection parameters
loadDetectionParameters

% load fish image
fish = genFish('fish_cropped.jpg',[vidObj.Height vidObj.Width]/2);
fishGray = rgb2gray(im2double(fish));
% find SURF descriptors for fish image
ptsFish = detectFASTFeatures(fishGray,'MinContrast',0.04);
[featFish,ptsFish] = extractFeatures(fishGray,[ptsFish.Location],'Method','SURF');

% get current and previous frames
frame = fetchFrameColor(vidObj,idx);
frameGray = rgb2gray(frame);
prevFrame = fetchFrameColor(vidObj,idx-1);

% stabalize background (previous frame) based on frame
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray);
prevFrame = prevFrame_aug(:,:,2:end);

% detect based on difference between current frame and background
dif = abs(prevFrame_aug(:,:,1) - frameGray);
thresh = graythresh(dif);
frameMaskDiff = dif > max(thresh,t0);

%% Mask with no refining of transmission map
% detect based on transmission map
[~,t,tThresh] = removeHaze(frame);
% refine transmission based on difference
tRefine = (1-beta)*t + beta*imclearborder(frameMaskDiff);
frameMask = tRefine > tThresh;
% remove small regions in mask
stats = regionprops(t > tThresh);
areas = [stats.Area];
minArea = round(min(rMean*mean(areas), rMax*max(areas)));
frameMask = bwareaopen(frameMask,minArea);
% dilate mask
frameMask = imdilate(frameMask,se);

%% Mask with refining of transmission map
% detect based on transmission map
[~,t,tThresh] = removeHaze(frame,true);
% refine transmission based on difference
tRefine = (1-beta)*t + beta*imclearborder(frameMaskDiff);
frameMaskRefine = tRefine > tThresh;
% remove small regions in mask
stats = regionprops(t > tThresh);
areas = [stats.Area];
minArea = round(min(rMean*mean(areas), rMax*max(areas)));
frameMaskRefine = bwareaopen(frameMaskRefine,minArea);
% dilate mask
frameMaskRefine = imdilate(frameMaskRefine,se);

%% Show comparisons of no refining vs refining
figure(1)
imshowpair(frameMask,frame,'ColorChannels','red-cyan')
saveas(gcf,'images/fishDetection_mask.png')
figure(2)
imshowpair(frameMaskRefine,frame,'ColorChannels','red-cyan')
saveas(gcf,'images/fishDetection_mask_refine.png')