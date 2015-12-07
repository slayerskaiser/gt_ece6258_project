% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function showFish(vidObj,fishPointsFrame,fish,fishPoints,delay)
% dispay detected fish features

if ~exist('delay','var') || isempty(delay)
    delay = 1;
end

for idx = 1:length(fishPointsFrame)
    frame = read(vidObj,idx+1);
    if ~isempty(fishPointsFrame{idx})
        showMatchedFeatures(fish,frame,fishPoints{idx},fishPointsFrame{idx},'montage')
    else
        imshowpair(fish,frame,'montage')
    end
    title(['Frame ' num2str(idx)])
    snapnow
    pause(delay)
end