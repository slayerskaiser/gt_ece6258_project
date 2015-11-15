% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function oldFrame_stabalized = stabalize(oldFrame,curFrame)
% given current and and old frames, returns old frame that has been
% transformed so its background matches that of the current

% allocate stabalized frame
[N,M] = size(oldFrame);
% oldFrame_stabalized = oldFrame;

% Using Matlab built-ins
% Need to redo
ptsOld = detectSURFFeatures(oldFrame);
ptsCur = detectSURFFeatures(curFrame);
[featOld,ptsOld] = extractFeatures(oldFrame,ptsOld);
[featCur,ptsCur] = extractFeatures(curFrame,ptsCur);
indexPairs = matchFeatures(featOld,featCur);
ptsOld = ptsOld(indexPairs(:,1),:);
ptsCur = ptsCur(indexPairs(:,2),:);
tform = estimateGeometricTransform(ptsOld,ptsCur,'affine');
oldFrame_stabalized = imwarp(oldFrame,tform,'OutputView',imref2d([N M]));