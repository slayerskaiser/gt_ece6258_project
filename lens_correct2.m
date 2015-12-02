% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function out = lens_correct2(in)

% ftype=3 and k=-0.32

out = lensdistort(in,-0.05, 'ftype', 3);