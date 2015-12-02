vidObj = VideoReader('videos/GOPR0059.MP4');
% vidObj = VideoReader('videos/GOPR0073.MP4');

a = fetchFrame(vidObj,2);
b = fetchFrame(vidObj,3);

%%
[aa,i1,i2,t1] = stabalize(a,b);