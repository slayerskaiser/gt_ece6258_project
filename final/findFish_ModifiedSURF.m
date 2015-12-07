% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [ptsFrame,ptsFish,fishBoxes] = ...
    findFish_ModifiedSURF(frame,frameMask,ptsFish,featFish,fishPolygon)
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

% refine matches by finding an affine transformation for each "fish"
%
% transformed boxes
ind = 0;
fishBoxes = {};
while true
    % estimate affine transform
    [tform,inliersFrame,~,status] =  ...
        estimateGeometricTransform(ptsFrame,ptsFish,'projective');
    % record transformed bounding box for fish
    if status == 0
        ind = ind + 1;
        % affine transformation of fish bounding box
        fishBoxes{ind} = transformPointsForward(tform,fishPolygon);
        % remove inliers in frame (to find additional fish)
        [~,idx] = setdiff(ptsFrame.Location,inliersFrame.Location,'rows');
        ptsFish = ptsFish(idx);
    else
        break
    end
end