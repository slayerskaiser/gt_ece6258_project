function [ptsOld,ptsCur] = findMatch_HessianAffine(oldFrame,curFrame)

oldFrame = single(oldFrame);
curFrame = single(curFrame);

[ptsOld,featOld] = vl_covdet(oldFrame, 'Method', 'Hessian', ...
    'EstimateAffineShape', true, 'descriptor', 'patch');
[ptsCur,featCur] = vl_covdet(curFrame, 'Method', 'Hessian', ...
    'EstimateAffineShape', true, 'descriptor', 'patch');

indexPairs = matchFeatures(featOld.', featCur.', ...
    'Method', 'NearestNeighborRatio');
ptsOld = ptsOld(1:2,indexPairs(:,1)).';
ptsCur = ptsCur(1:2,indexPairs(:,2)).';