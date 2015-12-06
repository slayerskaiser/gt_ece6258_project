% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

clear
close all
tic

%% Parameters
filename = '../videos/GOPR0059.MP4';
fprintf('Processing: %s\n',filename);
% for movement detection
alpha = 0.8;
% for refining of mask of movement pixels
nDilate = 20;
nErode = 30;

%% Read frames in file
vidObj = VideoReader(filename);
% frames to compute
% nFrames = vidObj.NumberOfFrames;
nFrames = 10;
fprintf('Frames = %d\n',nFrames)
% load fish image and mask for image
[fish,fishmask] = genFish('fish_cropped.jpg',[vidObj.Height vidObj.Width]);

%% Moving pixel detection
% Moving average detection algorithm
%   - uses frame stabalization based on SURF feature matching with FAST
%     detection of keypoints
MP = detectMP(vidObj,nFrames,alpha);

%% Use detected movement to create mask and detect fish
% [fishPointsFrame,fishPoints] = ...
%     detectFish(vidObj,nFrames,MP,rgb2gray(fish),fishmask,nDilate,nErode);