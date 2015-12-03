function [ptsFrame,ptsFish] = findFish_ModifiedSURF(frame,frameMask,fish,fishMask)

% detector = cv.FeatureDetector('FastFeatureDetector');
detector = cv.FeatureDetector('SIFT');
% detector = cv.FeatureDetector('SURF');
ptsFish = detector.detect(fish,'Mask',fishMask);
ptsFrame = detector.detect(frame,'Mask',frameMask);
detector.delete
clear detector
ptsFrame = reshape([ptsFrame.pt]+1,2,[]).';
ptsFish = reshape([ptsFish.pt]+1,2,[]).';

[featFrame,ptsFrame] = extractFeatures(frame,ptsFrame,'Method','Block');
[featFish,ptsFish] = extractFeatures(fish,ptsFish,'Method','Block');
indexPairs = matchFeatures(featFrame, featFish, 'Prenormalized', false, ...
    'Method', 'NearestNeighborSymmetric');
ptsFrame = ptsFrame(indexPairs(:,1),:);
ptsFish = ptsFish(indexPairs(:,2),:);