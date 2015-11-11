% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detect_ap(frames,alpha)
% Adaptive Gaussian Mixture Model

[N,M,nFrames] = size(frames);
% moving pixels
AP = false(N,M,nFrames-1);
% use first frame as initial background

% get moving pixels and update background
for n = 2:nFrames

end