% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [ptsFrame,ptsFish] = findFish_ModifiedSURF(frame,frameMask,fish,fishMask)
% detect fish features using SIFT keypoints and SURF descriptors

detector = cv.FeatureDetector('SIFT');
% detector = cv.FeatureDetector('FastFeatureDetector');

ptsFish = detector.detect(fish,'Mask',fishMask);
ptsFrame = detector.detect(frame,'Mask',frameMask);
detector.delete
clear detector
ptsFrame = reshape([ptsFrame.pt]+1,2,[]).';
ptsFish = reshape([ptsFish.pt]+1,2,[]).';

% ptsFish = detectSURFFeatures(fish.*uint8(fishMask));
% ptsFrame = detectSURFFeatures(frame.*uint8(frameMask));

[featFrame,ptsFrame] = extractFeatures(frame,ptsFrame,'Method','Block');
[featFish,ptsFish] = extractFeatures(fish,ptsFish,'Method','Block');
indexPairs = matchFeatures(featFrame, featFish, ...
    'Method', 'NearestNeighborSymmetric');
%     'Method', 'NearestNeighborSymmetric', 'MatchThreshold', 5);
ptsFrame = ptsFrame(indexPairs(:,1),:);
ptsFish = ptsFish(indexPairs(:,2),:);