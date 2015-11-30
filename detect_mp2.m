% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detect_mp2(vidObj,nFrames,alpha)
% Moving average detection algorithm

% size of frames
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
% moving pixels
MP = false(vidHeight,vidWidth,nFrames-1);

% use first frame as initial background
CB = fetchFrame(vidObj,1);
CB = mat2gray(CB);
% get moving pixels and update background
for idx = 2:nFrames
    fprintf('Starting frame %d, t=%f\n',idx,toc)
    curFrame = fetchFrame(vidObj,idx);
    CB = stabalize(CB,curFrame);
    dif = abs(CB - curFrame);
    thresh = graythresh(dif);
    MP(:,:,idx-1) = dif(:,:,1) > thresh;
    CB = (1-alpha)*CB + alpha*curFrame;
end