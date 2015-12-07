% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Compare effect of lens correction on stabalization

clear
close all

%% Read current and previous frame

filename = '../videos/GOPR0059.MP4';
vidObj = VideoReader(filename);

% use 3rd frame as current
idx = 3;

%% Stabalize using no lens correction
% get current and previous frames
frame = im2double(read(vidObj,idx));
frameGray_noLC = rgb2gray(frame);
prevFrame = im2double(read(vidObj,idx-1));
% stabalize background (previous frame) based on frame
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray_noLC);
prevFrame_noLC = prevFrame_aug(:,:,1);

%% Stabalize using lens correction
% get current and previous frames
frame = fetchFrameColor(vidObj,idx);
frameGray_LC = rgb2gray(frame);
prevFrame = fetchFrameColor(vidObj,idx-1);
% stabalize background (previous frame) based on frame
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray_LC);
prevFrame_LC = prevFrame_aug(:,:,1);

%% Show comparisons of stabalization using lens correction
% record norm error to text file
filename2 = 'images/lensCorrectionErrors.txt';
fileID = fopen(filename2,'w');
% no lens correction
figure(1)
imshowpair(prevFrame_noLC,frameGray_noLC,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_noLensCorrection.png')
fprintf(fileID,'Norm error between frames, no lens correction =\n\t%f\n', ...
    norm(prevFrame_noLC-frameGray_noLC,'fro'));
% lens correction
figure(2)
imshowpair(prevFrame_LC,frameGray_LC,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_lensCorrection.png')
fprintf(fileID,'Norm error between frames, with lens correction =\n\t%f\n', ...
    norm(prevFrame_LC-frameGray_LC,'fro'));
% display norm errors
fclose(fileID);
type(filename2)