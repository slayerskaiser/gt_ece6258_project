% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [ptsFrame,ptsFish] = ...
    findFish_ModifiedSURF(frame,frameMask,ptsFish,featFish,keypointMethod)
% detect fish features using FAST keypoints and SURF descriptors

% input parsing
if ~exist('keypointMethod','var') || isempty(keypointMethod)
    keypointMethod = 'FAST';
end

% common detection parameters
matchMethod = 'Threshold';
matchThresh = 5;

% for testing effect of keypoint method; default to FAST
if strcmpi(keypointMethod,'FAST')
    minContrast = 0.04;
    % find FAST keypoints in masked frame
    ptsFrame = detectFASTFeatures(frame.*frameMask,'MinContrast',minContrast);
    % extract SURF descriptors
    [featFrame,ptsFrame] = extractFeatures(frame,[ptsFrame.Location],'Method','SURF');
elseif strcmpi(keypointMethod,'SURF')
    numOctaves = 4;
    numScales = 6;
    thresh = 500;
    % find SURF keypoints in masked frame
    ptsFrame = detectSURFFeatures(frame.*frameMask,'NumOctaves',numOctaves,...
        'NumScaleLevels',numScales,'MetricThreshold',thresh);
    % extract SURF descriptors
    [featFrame,ptsFrame] = extractFeatures(frame,ptsFrame,'Method','SURF');
else
    error('Unknown method')
end

% find matching descriptors to SURF descriptors of fish using thresholding
indexPairs = matchFeatures(featFrame, featFish, ...
    'Method', matchMethod, 'MatchThreshold', matchThresh);
ptsFrame = ptsFrame(indexPairs(:,1),:);
ptsFish = ptsFish(indexPairs(:,2),:);