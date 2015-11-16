% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detect_mp(frames,alpha)
% Moving average detection algorithm

% size of frames
[N,M,nFrames] = size(frames);
% moving pixels
MP = false(N,M,nFrames-1);

% use first frame as initial background
CB = im2double(frames(:,:,1));
% get moving pixels and update background
for n = 2:nFrames
    fprintf('Starting frame %d, t=%f\n',n,toc)
    curFrame = im2double(frames(:,:,n));
    CB = stabalize(CB,curFrame);
    dif = abs(CB - curFrame);
    MP(:,:,n-1) = ( dif > graythresh(dif) );
    CB = (1-alpha)*CB + alpha*curFrame;
end