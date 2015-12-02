function [ptsOld,ptsCur] = findMatch_SIFT(oldFrame,curFrame)

oldFrame = single(oldFrame);
curFrame = single(curFrame);

[ptsOld,featOld] = vl_sift(oldFrame);
[ptsCur,featCur] = vl_sift(curFrame);
% [matches,scores] = vl_ubcmatch(featOld,featCur);

indexPairs = matchFeatures(featOld.', featCur.', ...
    'Method', 'NearestNeighborRatio');
ptsOld = ptsOld(1:2,indexPairs(:,1)).';
ptsCur = ptsCur(1:2,indexPairs(:,2)).';