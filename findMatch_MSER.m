function [ptsOld,ptsCur] = findMatch_MSER(oldFrame,curFrame)

ptsOld = detectMSERFeatures(oldFrame);
ptsCur = detectMSERFeatures(curFrame);
[featOld,ptsOld] = extractFeatures(oldFrame,ptsOld);
[featCur,ptsCur] = extractFeatures(curFrame,ptsCur);
indexPairs = matchFeatures(featOld, featCur, ...
    'Method', 'NearestNeighborRatio');
ptsOld = ptsOld(indexPairs(:,1),:);
ptsCur = ptsCur(indexPairs(:,2),:);