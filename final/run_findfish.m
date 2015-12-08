% Minimal example of how to use provided code
%
% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

clear
close all
tic
figure(1)

% turn off warning for imshow()
warning('off','images:initSize:adjustingMag');

%% Parameters
% filename
filename = 'videos/GOPR0059.MP4';
vidObj = VideoReader(filename);

% frames to compute
nFrames = 10;
% nFrames = vidObj.NumberOfFrames;

fprintf('Processing: %s\n',filename);
fprintf('Frames to process = %d\n',nFrames)

%% load fish image and mask for image
[fish,fishmask] = genFish('fish_cropped.jpg',[vidObj.Height vidObj.Width]/2);

%% Fish detection
% Detect fish based on masking using transmission map
[fishPointsFrame,fishPoints] = detectfish(vidObj,nFrames,fish);

%% Display matches
fprintf('Displaying detection results\n')
showFish(vidObj,fishPointsFrame,fish,fishPoints)