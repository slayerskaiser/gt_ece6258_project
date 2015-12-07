% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function showMask(mask,delay)
% dispay masks

if ~exist('delay','var') || isempty(delay)
    delay = 1;
end

figure
for idx = 1:length(mask)
    imshow(mask{idx})
    snapnow
    pause(delay)
end