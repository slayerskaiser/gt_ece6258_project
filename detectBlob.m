% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function blobs = detectBlob(binFrames)
% find blobs in binary images

frames = single(binFrames);

N = size(frames,3);
for idx = 1:N
    frame = frames(:,:,idx);
    regions = detectMSERFeatures(frame);
    figure; imshow(frame); hold on;
    plot(regions, 'showPixelList', true, 'showEllipses', false);
end