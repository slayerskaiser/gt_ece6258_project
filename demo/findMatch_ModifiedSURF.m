% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [ptsOld,ptsCur] = findMatch_ModifiedSURF(oldFrame,curFrame,keypointMethod)
% detect features for frame stabalization using given keypoints and SURF
% descriptors; default to FASt keypoints

if ~exist('keypointMethod','var') || isempty(keypointMethod)
    keypointMethod = 'FAST';
end

if strcmpi(keypointMethod,'FAST')
    minContrast = 0.04;
    matchMethod = 'NearestNeighborRatio';
    ptsOld = detectFASTFeatures(oldFrame,'MinContrast',minContrast);
    ptsCur = detectFASTFeatures(curFrame,'MinContrast',minContrast);
elseif strcmpi(keypointMethod,'FASTFish')
    minContrast = 0.04;
    matchMethod = 'NearestNeighborSymmetric';
    ptsOld = detectFASTFeatures(oldFrame,'MinContrast',minContrast);
    ptsCur = detectFASTFeatures(curFrame,'MinContrast',minContrast);
else
    error('Unknown method')
end

[featOld,ptsOld] = extractFeatures(oldFrame,ptsOld,'Method','SURF');
[featCur,ptsCur] = extractFeatures(curFrame,ptsCur,'Method','SURF');
indexPairs = matchFeatures(featOld, featCur, 'Prenormalized', true, ...
    'Method', matchMethod);
ptsOld = ptsOld(indexPairs(:,1),:);
ptsCur = ptsCur(indexPairs(:,2),:);