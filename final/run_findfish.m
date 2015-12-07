% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

clear
close all
tic

%% Parameters
filename = '../videos/GOPR0059.MP4';
fprintf('Processing: %s\n',filename);

%% Read frames in file
vidObj = VideoReader(filename);
% frames to compute
nFrames = vidObj.NumberOfFrames;
% nFrames = 10;
fprintf('Frames = %d\n',nFrames)
% load fish image and mask for image
[fish,fishmask] = genFish('fish_cropped.jpg',[vidObj.Height vidObj.Width]/2);

%% Fish detection
% Detect fish based on masking using transmission map
[fishPointsFrame,fishPoints] = detectFish(vidObj,nFrames,fish);

%% Display matches
showFish(vidObj,fishPointsFrame,fish,fishPoints)