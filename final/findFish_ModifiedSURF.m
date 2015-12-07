% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [ptsFrame,ptsFish] = findFish_ModifiedSURF(frame,frameMask,ptsFish,featFish)
% detect fish features using FAST keypoints and SURF descriptors

% detection parameters
minContrast = 0.04;
matchMethod = 'Threshold';
matchThresh = 5;

ptsFrame = detectFASTFeatures(frame.*frameMask,'MinContrast',minContrast);
[featFrame,ptsFrame] = extractFeatures(frame,ptsFrame,'Method','SURF');
indexPairs = matchFeatures(featFrame, featFish, ...
    'Method', matchMethod, 'MatchThreshold', matchThresh);
ptsFrame = ptsFrame(indexPairs(:,1),:);
ptsFish = ptsFish(indexPairs(:,2),:);