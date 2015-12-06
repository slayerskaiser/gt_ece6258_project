% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

clear
close all
tic

%% Parameters
filename = '../videos/GOPR0059.MP4';
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
% load fish image and mask for image
load fishdata
fish = imresize(fish,[vidObj.Height vidObj.Width]);
z = ~(rgb2gray(fish)==0);
fishmask = bwareaopen(z,1e4);
% fishmask = imresize(fishmask,[vidObj.Height vidObj.Width]);

fprintf('Frames = %d\n',nFrames)

%% Moving pixel detection
% Moving average detection algorithm
%   - uses frame stabalization based on SURF feature matching with FAST
%     detection of keypoints
MP = detectMP(vidObj,nFrames,alpha);

%% Use detected movement to create mask and detect fish
[fishPointsFrame,fishPoints] = ...
    detectFish(vidObj,nFrames,MP,rgb2gray(fish),fishmask,nDilate,nErode);
