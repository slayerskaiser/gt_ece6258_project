% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [pts1,pts2] = findMatch_ModifiedSURF(frame1,frame2,keypointMethod,mask1,mask2)
% detect features for frame stabalization using given keypoint method and
% SURF descriptors; default to FAST keypoints

% input parsing
if ~exist('keypointMethod','var') || isempty(keypointMethod)
    keypointMethod = 'FAST';
end
if ~exist('mask1','var') || isempty(mask1)
    mask1 = ones(size(frame1),'uint8');
end
if ~exist('mask2','var') || isempty(mask2)
    mask2 = ones(size(frame2),'uint8');
end

% common parameters
matchMethod = 'NearestNeighborRatio';

% for testing effect of keypoint method; default to FAST
if strcmpi(keypointMethod,'FAST')
    descriptor = 'SURF'; % descriptor method
    minContrast = 0.04;
    pts1 = detectFASTFeatures(frame1.*mask1,'MinContrast',minContrast);
    pts2 = detectFASTFeatures(frame2.*mask2,'MinContrast',minContrast);
elseif strcmpi(keypointMethod,'SURF')
    descriptor = 'SURF'; % descriptor method
    numOctaves = 4;
    numScales = 6;
    thresh = 500;
    pts1 = detectSURFFeatures(frame1.*mask1,'NumOctaves',numOctaves,...
        'NumScaleLevels',numScales,'MetricThreshold',thresh);
    pts2 = detectSURFFeatures(frame2.*mask2,'NumOctaves',numOctaves,...
        'NumScaleLevels',numScales,'MetricThreshold',thresh);
elseif strcmpi(keypointMethod,'FASTFREAK')
    descriptor = 'FREAK'; % descriptor method
    minContrast = 0.04;
    pts1 = detectFASTFeatures(frame1.*mask1,'MinContrast',minContrast);
    pts2 = detectFASTFeatures(frame2.*mask2,'MinContrast',minContrast);
elseif strcmpi(keypointMethod,'MSER')
    descriptor = 'SURF'; % descriptor method
    pts1 = detectMSERFeatures(frame1.*mask1);
    pts2 = detectMSERFeatures(frame2.*mask2);
elseif strcmpi(keypointMethod,'ME')
    descriptor = 'FREAK'; % descriptor method
    pts1 = detectMinEigenFeatures(frame1.*mask1);
    pts2 = detectMinEigenFeatures(frame2.*mask2);
elseif strcmpi(keypointMethod,'BRISK')
    descriptor = 'BRISK'; % descriptor method
    pts1 = detectMinEigenFeatures(frame1.*mask1);
    pts2 = detectMinEigenFeatures(frame2.*mask2);
else
    error('Unknown method')
end

% extract SURF descriptors and find matches
[feat1,pts1] = extractFeatures(frame1,[pts1.Location],'Method',descriptor);
[feat2,pts2] = extractFeatures(frame2,[pts2.Location],'Method',descriptor);

indexPairs = matchFeatures(feat1, feat2, 'Method', matchMethod);
pts1 = pts1(indexPairs(:,1),:);
pts2 = pts2(indexPairs(:,2),:);