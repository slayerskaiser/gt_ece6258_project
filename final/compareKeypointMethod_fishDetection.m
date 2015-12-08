% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Compare effect of keypoint method on stabalization

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

%% Find fish using SURF and FAST keypoints with SURF descriptors
% SURF keypoints
tic
[ptsFrameSURF,ptsFishSURF] = ...
    findFish_ModifiedSURF(frameGray,frameMask,ptsFish,featFish,'SURF');
tSURF = toc;
% FAST keypoints
tic
[ptsFrameFAST,ptsFishFAST] = ...
    findFish_ModifiedSURF(frameGray,frameMask,ptsFish,featFish,'FAST');
tFAST = toc;

%% Show comparisons of fish detection using different keypoint methods
figure(1)
showMatchedFeatures(fish,frame,ptsFishSURF,ptsFrameSURF,'montage')
saveas(gcf,'images/fishDetection_SURF.png')
figure(2)
showMatchedFeatures(fish,frame,ptsFishFAST,ptsFrameFAST,'montage')
saveas(gcf,'images/fishDetection_FASTSURF.png')
% record number of keypoints matched and time spent
filename2 = 'images/fishDetectionStats.txt';
fileID = fopen(filename2,'w');
fprintf(fileID,'Number of matched SURF keypoints = %d, time spent = %f\n', ...
    length(ptsFrameSURF),tSURF);
fprintf(fileID,'Number of matched FAST keypoints = %d, time spent = %f\n', ...
    length(ptsFrameFAST),tFAST);
fclose(fileID);
type(filename2)