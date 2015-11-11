% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detect_mp(frames,alpha)
% Moving average detection algorithm

[N,M,nFrames] = size(frames);
% moving pixels
MP = false(N,M,nFrames-1);
% use first frame as initial background
CB = frames(:,:,1);
% get moving pixels and update background
for n = 2:nFrames
    dif = abs(CB - frames(:,:,n));
    MP(:,:,n-1) = ( dif > 255*graythresh(dif) );
    CB = (1-alpha)*CB + alpha*frames(:,:,n);
end