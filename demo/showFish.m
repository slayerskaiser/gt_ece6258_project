% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function showFish(vidObj,fishPointsFrame,fish,fishPoints)
% dispay detected fish features

figure(1)
for idx = 1:length(fishPointsFrame)
    frame = read(vidObj,idx+1);
    if isempty(fishPointsFrame{idx})
        imshowpair(fish,frame,'montage')
    else
        showMatchedFeatures(fish,frame,fishPoints{idx},fishPointsFrame{idx},'montage')
    end
    snapnow
    pause(1)
end