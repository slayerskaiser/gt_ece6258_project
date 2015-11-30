vidObj = VideoReader('videos\GOPR0073.MP4');

a = fetchFrame(vidObj,1);
b = fetchFrame(vidObj,2);
aa = stabalize(a,b);