% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function compFrame = motionComp(prevFrame,MV,blockSize)
% compute motion-compensated frame from previous frame and motion vectors

% set sizes for macroblock
if length(blockSize) == 1
    blockSize = [blockSize blockSize];
end
% get frame size
[height,width] = size(prevFrame);
% pad with 0s with necessary to be a multiple of blockSize
padHeight = mod(-height,blockSize(1));
padWidth = mod(-width,blockSize(2));
prevFrame = padarray(prevFrame,[padHeight,padWidth],0,'post');

% create motion-compensated frame from previous frame and motion vectors
compFrame = zeros(size(prevFrame));
% loop over macroblocks
for heightIdx = 1:size(MV,1)
    for widthIdx = 1:size(MV,2)
        % macroblock indices
        Yinds = (heightIdx-1)*blockSize(1) + (1:blockSize(1));
        Xinds = (widthIdx-1)*blockSize(2) + (1:blockSize(2));
        compFrame(Yinds,Xinds) = ...
            prevFrame(Yinds + imag(MV(heightIdx,widthIdx)), ...
            Xinds + real(MV(heightIdx,widthIdx)));
    end
end
% remove padding
compFrame = compFrame(1:height,1:width);