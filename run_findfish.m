% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

clear
close all
tic

%% Read frames in file
%%% look into: vision.VideoFileReader
vidObj = VideoReader('videos\GOPR0073.MP4');
% nFrames = vidObj.NumberOfFrames;
nFrames = 20;

%% Moving pixel detection
% Moving average detection algorithm
MP = detect_mp2(vidObj,nFrames,0.8);