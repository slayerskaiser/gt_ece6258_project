% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Compare effect of masking on fish detection
% (slightly difference since background estimate is not used)

clear
close all

%% Read current and previous frame; generate mask

filename = '../videos/GOPR0059.MP4';
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

%% Find fish using no mask and mask
% use no mask to find fish
[ptsFrameNoMask,ptsFishNoMask] = ...
    findFish_ModifiedSURF(frameGray,true(size(frameMask)),ptsFish,featFish);
% use mask to find fish
[ptsFrameMask,ptsFishMask] = ...
    findFish_ModifiedSURF(frameGray,frameMask,ptsFish,featFish);

%% Show comparisons of no masking vs masking
figure(1)
showMatchedFeatures(fish,frame,ptsFishNoMask,ptsFrameNoMask,'montage')
saveas(gcf,'images/fishDetection_nomasking.png')
figure(2)
showMatchedFeatures(fish,frame,ptsFishMask,ptsFrameMask,'montage')
saveas(gcf,'images/fishDetection_masking.png')
figure(3)
imshow(frame); hold on
plot(ptsFrameMask)
saveas(gcf,'images/fishDetection_masking_keypointLocations.png')