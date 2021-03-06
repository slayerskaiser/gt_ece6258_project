function [ptsOld,ptsCur] = findMatch_ModifiedSURF(oldFrame,curFrame)

detector = cv.FeatureDetector('FastFeatureDetector');
% detector = cv.FeatureDetector('SIFT');
% detector = cv.FeatureDetector('SURF');
ptsOld = detector.detect(oldFrame);
ptsCur = detector.detect(curFrame);
detector.delete
clear detector
ptsOld = reshape([ptsOld.pt]+1,2,[]).';
ptsCur = reshape([ptsCur.pt]+1,2,[]).';

[featOld,ptsOld] = extractFeatures(oldFrame,ptsOld,'Method','SURF');
[featCur,ptsCur] = extractFeatures(curFrame,ptsCur,'Method','SURF');
indexPairs = matchFeatures(featOld, featCur, 'Prenormalized', true, ...
    'Method', 'NearestNeighborRatio');
ptsOld = ptsOld(indexPairs(:,1),:);
ptsCur = ptsCur(indexPairs(:,2),:);