% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detect_mp2(vidObj,nFrames,alpha)
% Moving average detection algorithm

% size of frames
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
% moving pixels
MP = false(vidHeight,vidWidth,nFrames-1);

% use second frame as initial background
% (sometimes first and second frame are same)
CB = fetchFrame(vidObj,2);
CB = mat2gray(CB);
% get moving pixels and update background
for idx = 3:nFrames
    fprintf('Starting frame %d, t=%f\n',idx,toc)
    curFrame = fetchFrame(vidObj,idx);
%     CB = stabalize(CB,curFrame);
    dif = abs(CB - curFrame);
    thresh = graythresh(dif);
    MP(:,:,idx-1) = dif(:,:,1) > thresh;
    CB = (1-alpha)*CB + alpha*curFrame;
end