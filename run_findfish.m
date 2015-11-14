% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

clear
close all

%% Read frames in file
vidObj = VideoReader('GOPR0073.avi');
% nFrames = vidObj.NumberOfFrames;
nFrames = 10;
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
    'colormap',[]);
for k = 1:nFrames
    s(k).cdata = rgb2gray(read(vidObj,k));
%     s(k).cdata = read(vidObj,k);
end

%% Moving pixel detection
% Moving average detection algorithm
MP = detect_mp(cat(3,s(:).cdata),0.5);
% Non-adaptive Gaussian mixture model
AP = detect_ap(cat(3,s(:).cdata),4,0.05);

%% Find features
%  pts = detectSURFFeatures(s(1).cdata);

%% Play video
% hf = figure;
% set(hf, 'position', [150 150 vidWidth vidHeight])
% movie(hf, s, 1, vidObj.FrameRate);