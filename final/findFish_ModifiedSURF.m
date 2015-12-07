% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [ptsFrame,ptsFish] = ...
    findFish_ModifiedSURF(frame,frameMask,ptsFish,featFish)
% detect fish features using FAST keypoints and SURF descriptors

% detection parameters
minContrast = 0.04;
matchMethod = 'Threshold';
% matchMethod = 'NearestNeighborSymmetric';
matchThresh = 5;

% find FAST keypoints in masked frame
ptsFrame = detectFASTFeatures(frame.*frameMask,'MinContrast',minContrast);
% extract SURF descriptors
[featFrame,ptsFrame] = extractFeatures(frame,ptsFrame,'Method','SURF');
% find matching descriptors to SURF descriptors of fish using thresholding
indexPairs = matchFeatures(featFrame, featFish, ...
    'Method', matchMethod, 'MatchThreshold', matchThresh);
ptsFrame = ptsFrame(indexPairs(:,1),:);
ptsFish = ptsFish(indexPairs(:,2),:);