function [ptsOld,ptsCur] = findMatch_SURF(oldFrame,curFrame)

ptsOld = detectSURFFeatures(oldFrame);
ptsCur = detectSURFFeatures(curFrame);
[featOld,ptsOld] = extractFeatures(oldFrame,ptsOld);
[featCur,ptsCur] = extractFeatures(curFrame,ptsCur);
indexPairs = matchFeatures(featOld, featCur, 'Prenormalized', true, ...
    'Method', 'NearestNeighborRatio');
ptsOld = ptsOld(indexPairs(:,1),:);
ptsCur = ptsCur(indexPairs(:,2),:);