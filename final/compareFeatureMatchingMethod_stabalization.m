% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du
%
% Compare effect of keypoint method on stabalization

clear
close all

%% Read current and previous frame

filename = 'videos/GOPR0059.MP4';
vidObj = VideoReader(filename);

% use 3rd frame as current
idx = 3;

frame = fetchFrameColor(vidObj,idx);
frameGray = rgb2gray(frame);
prevFrame = fetchFrameColor(vidObj,idx-1);

%% Stabalize using SURF keypoints and SURF descriptors
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray,'SURF');
prevFrame_SURF = prevFrame_aug(:,:,1);

%% Stabalize using FAST keypoints and SURF descriptors
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray,'FAST');
prevFrame_FASTSURF = prevFrame_aug(:,:,1);

%% Stabalize using FAST keypoints and FREAK descriptors
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray,'FASTFREAK');
prevFrame_FASTFREAK = prevFrame_aug(:,:,1);

%% Stabalize using MSER keypoints and SURF descriptors
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray,'MSER');
prevFrame_MSER = prevFrame_aug(:,:,1);

%% Stabalize using Min. Eigenvalue keypoints and FREAK descriptors
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray,'ME');
prevFrame_ME = prevFrame_aug(:,:,1);

%% Stabalize using BRISK keypoints and BRISK descriptors
prevFrame_aug = cat(3,rgb2gray(prevFrame),prevFrame);
prevFrame_aug = stabalize(prevFrame_aug,frameGray,'BRISK');
prevFrame_BRISK = prevFrame_aug(:,:,1);

%% Show comparisons of stabalization using different keypoint methods
% record norm error to text file
filename2 = 'images/featureMatchingMethodErrors.txt';
fileID = fopen(filename2,'w');
% SURF
figure(1)
imshowpair(prevFrame_SURF,frameGray,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_SURF.png')
fprintf(fileID,'Norm error between frames, SURF =\n\t%f\n', ...
    norm(prevFrame_SURF-frameGray,'fro'));
% FAST with SURF
figure(2)
imshowpair(prevFrame_FASTSURF,frameGray,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_FASTSURF.png')
fprintf(fileID,'Norm error between frames, FAST SURF =\n\t%f\n', ...
    norm(prevFrame_FASTSURF-frameGray,'fro'));
% FAST
figure(3)
imshowpair(prevFrame_FASTFREAK,frameGray,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_FASTFREAK.png')
fprintf(fileID,'Norm error between frames, FAST FREAK =\n\t%f\n', ...
    norm(prevFrame_FASTFREAK-frameGray,'fro'));
% MSER with SURF
figure(4)
imshowpair(prevFrame_MSER,frameGray,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_MSERSURF.png')
fprintf(fileID,'Norm error between frames, MSER SURF =\n\t%f\n', ...
    norm(prevFrame_MSER-frameGray,'fro'));
% Min. Eigen
figure(5)
imshowpair(prevFrame_ME,frameGray,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_MinEigenFREAK.png')
fprintf(fileID,'Norm error between frames, MinEigen FREAK =\n\t%f\n', ...
    norm(prevFrame_ME-frameGray,'fro'));
% BRISK
figure(5)
imshowpair(prevFrame_BRISK,frameGray,'ColorChannels','red-cyan')
saveas(gcf,'images/stabalization_BRISK.png')
fprintf(fileID,'Norm error between frames, BRISK =\n\t%f\n', ...
    norm(prevFrame_BRISK-frameGray,'fro'));
% display norm errors
fclose(fileID);
type(filename2)