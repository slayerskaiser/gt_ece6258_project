function [ptsOld,ptsCur] = findMatch_ORB(oldFrame,curFrame)

% extract ORB features of frames
orb = cv.ORB;
[ptsOld,featOld] = orb.detectAndCompute(oldFrame);
[ptsCur,featCur] = orb.detectAndCompute(curFrame);
featOld = binaryFeatures(featOld);
featCur = binaryFeatures(featCur);
indexPairs = matchFeatures(featOld,featCur);

ptsOld = reshape([ptsOld(indexPairs(:,1)).pt],2,[]).';
ptsCur = reshape([ptsCur(indexPairs(:,2)).pt],2,[]).';