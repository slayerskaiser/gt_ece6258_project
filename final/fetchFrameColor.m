% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function frame = fetchFrameColor(vidObj,idx)
% Fetch frame idx from vidObj and perform lens correction

frame = im2double(read(vidObj,idx));
frame = lens_correct(frame);