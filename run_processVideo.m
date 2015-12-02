% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function out = run_processVideo(filename)

vidObj = VideoReader(filename);
nFrames = vidObj.NumberOfFrames;
height = vidObj.Height;
width = vidObj.Width;
