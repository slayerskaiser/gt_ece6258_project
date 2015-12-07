% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Compare effect of keypoint method on stabalization

clear
close all

%% Read current and previous frame

filename = '../videos/GOPR0059.MP4';
vidObj = VideoReader(filename);

% use 3rd frame as current
idx = 3;

%% Stabalize using SURF keypoints and descriptors
% get current and previous frames
frame = fetchFrameColor(vidObj,idx);
frameGray_SURF = rgb2gray(frame);
prevFrame = fetchFrameColor(vidObj,idx-1);
% stabalize background (previous frame) based on frame
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray_SURF,'SURF');
prevFrame_SURF = prevFrame_aug(:,:,1);

%% Stabalize using FAST keypoints and SURF descriptors
% get current and previous frames
frame = fetchFrameColor(vidObj,idx);
frameGray_FAST = rgb2gray(frame);
prevFrame = fetchFrameColor(vidObj,idx-1);
% stabalize background (previous frame) based on frame
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray_FAST,'FAST');
prevFrame_FAST = prevFrame_aug(:,:,1);

%% Show comparisons of stabalization using different keypoint methods
% record norm error to text file
filename2 = 'images/keypointMethodErrors.txt';
fileID = fopen(filename2,'w');
% no lens correction
figure(1)
imshowpair(prevFrame_SURF,frameGray_SURF,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_noLensCorrection.png')
fprintf(fileID,'Norm error between frames, SURF keypoints =\n\t%f\n', ...
    norm(prevFrame_SURF-frameGray_SURF,'fro'));
% lens correction
figure(2)
imshowpair(prevFrame_FAST,frameGray_FAST,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_lensCorrection.png')
fprintf(fileID,'Norm error between frames, FAST keypoints =\n\t%f\n', ...
    norm(prevFrame_FAST-frameGray_FAST,'fro'));
% display norm errors
fclose(fileID);
type(filename2)