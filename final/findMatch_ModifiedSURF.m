% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [pts1,pts2] = findMatch_ModifiedSURF(frame1,frame2,keypointMethod,mask1,mask2)
% detect features for frame stabalization using given keypoints and SURF
% descriptors; default to FAST keypoints

if ~exist('keypointMethod','var') || isempty(keypointMethod)
    keypointMethod = 'FAST';
end
if ~exist('mask1','var') || isempty(mask1)
    mask1 = ones(size(frame1),'uint8');
end
if ~exist('mask2','var') || isempty(mask2)
    mask2 = ones(size(frame2),'uint8');
end

if strcmpi(keypointMethod,'FAST')
    minContrast = 0.04;
    matchMethod = 'NearestNeighborRatio';
    pts1 = detectFASTFeatures(frame1.*mask1,'MinContrast',minContrast);
    pts2 = detectFASTFeatures(frame2.*mask2,'MinContrast',minContrast);
% elseif strcmpi(keypointMethod,'SIFT')
% %     minContrast = 0.04;
%     matchMethod = 'NearestNeighborSymmetric';
%     pts1 = vl_sift(single(frame1.*mask1));
%     pts2 = vl_sift(single(frame2.*mask2));
% elseif strcmpi(keypointMethod,'SURF')
%     numOctaves = 4;
%     numScales = 6;
% %     matchMethod = 'NearestNeighborSymmetric';
%     matchMethod = 'Threshold';
%     pts1 = detectSURFFeatures(frame1.*mask1,'NumOctaves',numOctaves,'NumScaleLevels',numScales);
%     pts2 = detectSURFFeatures(frame2.*mask2,'NumOctaves',numOctaves,'NumScaleLevels',numScales);
%     
%     pts1 = detectMSERFeatures(frame1.*mask1,'ThresholdDelta',0.8);
%     pts2 = detectMSERFeatures(frame2.*mask2,'ThresholdDelta',0.8);
else
    error('Unknown method')
end

[feat1,pts1] = extractFeatures(frame1,pts1,'Method','SURF');
[feat2,pts2] = extractFeatures(frame2,pts2,'Method','SURF');
indexPairs = matchFeatures(feat1, feat2, 'Prenormalized', true, ...
    'Method', matchMethod);
pts1 = pts1(indexPairs(:,1),:);
pts2 = pts2(indexPairs(:,2),:);