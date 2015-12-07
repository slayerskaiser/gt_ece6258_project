% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function frame = fetchFrame_color(vidObj,idx)
% Fetch frame idx from vidObj

frame = im2double(read(vidObj,idx));
% frame = colorcorrect_uw_full(frame);
frame = lens_correct(frame);
% frame = lens_correct2(frame);
% frame = frame(:,:,1);
% frame = frame(:,:,[1]);
% frame = rgb2gray(frame);