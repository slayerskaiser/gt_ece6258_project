% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [oldFrame_stabalized,ptsOld,ptsCur,transOld] = ...
    stabalize(oldFrame_aug,curFrame_aug,varargin)
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
oldFrame = im2uint8(oldFrame);
curFrame = im2uint8(curFrame);

% [ptsOld,ptsCur] = findMatch_ORB(oldFrame,curFrame);
% [ptsOld,ptsCur] = findMatch_MSER(oldFrame,curFrame);
% [ptsOld,ptsCur] = findMatch_SIFT(oldFrame,curFrame);

% [ptsOld,ptsCur] = findMatch_SURF(oldFrame,curFrame);
[ptsOld,ptsCur] = findMatch_ModifiedSURF(oldFrame,curFrame);

[tform,inlierOld,inlierCur] = estimateGeometricTransform(ptsOld,ptsCur,'projective');
oldFrame_stabalized = ...
    imwarp(oldFrame_aug,tform,'OutputView',imref2d([N M]));

if isfloat(ptsOld)
    transOld = transformPointsForward(tform,ptsOld);
else
    transOld = transformPointsForward(tform,ptsOld.Location);
end