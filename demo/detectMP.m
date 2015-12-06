% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detectMP(vidObj,nFrames,alpha)
% Moving average detection algorithm

fprintf('=== Movement detection ===\n')
count = 0;

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
    count = fprintf([repmat('\b',1,count) 'Starting frame %d, t=%f'],idx,toc) - count;
    curFrame = fetchFrame(vidObj,idx);
    % skip if background and frame are the same
    if isequal(CB,curFrame)
        continue
    end
    CB = stabalize(CB,curFrame);
    dif = abs(CB - curFrame);
    thresh = graythresh(dif);
    MP(:,:,idx-1) = dif(:,:,1) > thresh;
    CB = (1-alpha)*CB + alpha*curFrame;
end

fprintf('\n')