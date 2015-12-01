% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [oldFrame_stabalized,inlierOld,inlierCur] = stabalize(oldFrame_aug,curFrame_aug,varargin)
% given current and and old frames, returns old frame that has been
% transformed so its background matches that of the current

% remove augmentation from input frames
oldFrame = oldFrame_aug(:,:,1);
curFrame = curFrame_aug(:,:,1);
% reshape frames if necessary
if isempty(varargin)
    [N,M] = size(oldFrame);
else
    if length(varargin) == 1
        [N,M] = deal(varargin{1});
    elseif length(varargin) == 2
        N = varargin{1};
        M = varargin{2};
    else
        error('Wrong number of inputs')
    end
    oldFrame = reshape(oldFrame,N,M);
    curFrame = reshape(curFrame,N,M);
end

% Using Matlab built-ins
% Need to redo
ptsOld = detectSURFFeatures(oldFrame);
ptsCur = detectSURFFeatures(curFrame);
% ptsOld = detectMSERFeatures(oldFrame);
% ptsCur = detectMSERFeatures(curFrame);
[featOld,ptsOld] = extractFeatures(oldFrame,ptsOld);
[featCur,ptsCur] = extractFeatures(curFrame,ptsCur);
indexPairs = matchFeatures(featOld,featCur);
ptsOld = ptsOld(indexPairs(:,1),:);
ptsCur = ptsCur(indexPairs(:,2),:);
% tform = estimateGeometricTransform(ptsOld,ptsCur,'projective');
[tform,inlierOld,inlierCur] = estimateGeometricTransform(ptsOld,ptsCur,'affine');
oldFrame_stabalized = ...
    imwarp(oldFrame_aug,tform,'OutputView',imref2d([N M]));