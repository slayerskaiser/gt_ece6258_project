% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function [fishPointsFrame,fishPoints] = ...
    detectFish(vidObj,nFrames,MP,fish,fishMask,nDilate,nErode)

fprintf('=== Fish detection ===\n')
count = 0;

% offset for frame index
frameOffset = 2;

% create morphological structuring elements for dilation and erosion of
% detected movement pixels
seDilate = strel('square',nDilate);
seErode = strel('square',nErode);

% cell array for holding detected fish feature locations
fishPointsFrame = cell(nFrames-frameOffset-1,1);
% cell array for holding corresponding locations on fish
fishPoints = cell(nFrames-frameOffset-1,1);

for idx = 1:size(MP,3)-frameOffset+1
    count = fprintf([repmat('\b',1,count) 'Starting frame %d, t=%f'], ...
        idx+frameOffset,toc) - count;
        
    % read in frame
    frame = im2uint8(fetchFrame(vidObj,idx+frameOffset));
    
    % create mask for frame from detected motion pixels
    frameMask = MP(:,:,idx+frameOffset-1);
    
    % dilate and erode mask to find large regions only
    frameMask = imdilate( imerode( ...
        imclearborder(imdilate(frameMask,seDilate)), seErode), seDilate);
    
    % skip to next frame if no movement is detected
    if all(frameMask(:) == 0), continue, end
    
    % use mask to find fish feature locations
    [fishPointsFrame{idx},fishPoints{idx}] = ...
        findFish_ModifiedSURF(frame,frameMask,fish,fishMask);
end

fprintf('\n')