% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

clear
close all
tic

% turn off warning for imshow()
warning('off','images:initSize:adjustingMag');

%% Parameters
% filename
filename = '../videos/GOPR0059.MP4';
vidObj = VideoReader(filename);

% frames to compute
% nFrames = vidObj.NumberOfFrames;
nFrames = 30;

fprintf('Processing: %s\n',filename);
fprintf('Frames = %d\n',nFrames)

%% load fish image and mask for image
[fish,fishmask] = genFish('fish_cropped.jpg',[vidObj.Height vidObj.Width]/2);

%% Fish detection
% Detect fish based on masking using transmission map
figure(1)
[fishPointsFrame,fishPoints] = detectFish(vidObj,nFrames,fish,true);

%% Display matches
% figure(1)
% showFish(vidObj,fishPointsFrame,fish,fishPoints)