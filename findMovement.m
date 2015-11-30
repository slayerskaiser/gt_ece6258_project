% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MV = findMovement(oldFrame,curFrame,blockSize,searchSize)
% search for movement vectors of blockSize from oldFrame to curFrame in
% area of searchSize

% set sizes for macroblock and search area
if length(blockSize) == 1
    blockSize = [blockSize blockSize];
end
if length(searchSize) == 1
    searchSize = [searchSize searchSize];
end
% get frame size
[height,width] = size(curFrame);
% pad with 0s with necessary to be a multiple of blockSize
padHeight = mod(-height,blockSize(1));
padWidth = mod(-width,blockSize(2));
curFrame = padarray(curFrame,[padHeight,padWidth],0,'post');
oldFrame = padarray(oldFrame,[padHeight,padWidth],0,'post');

% find movement vectors using MAD
MV = zeros([height+padHeight width+padWidth]./blockSize);
MAD = zeros(2*searchSize+1);
% vectors of shifts indices
py = -searchSize(1):searchSize(1);
px = -searchSize(2):searchSize(2);
[pxMeshFull,pyMeshFull] = meshgrid(1:2*searchSize(1)+1, ...
    1:2*searchSize(2)+1);
% vectors of macroblock indices
[widthMeshFull,heightMeshFull] = meshgrid(1:blockSize(2),1:blockSize(1));
% loop over macroblocks
for heightIdx = 1:size(MV,1);
    for widthIdx = 1:size(MV,2)
        heightStart = (heightIdx-1)*blockSize(1) + 1;
        heightEnd = heightIdx*blockSize(1);
        widthStart = (widthIdx-1)*blockSize(2) + 1;
        widthEnd = widthIdx*blockSize(2);
        % macroblock
        MB = curFrame(heightStart:heightEnd,widthStart:widthEnd);
        % reset MAD values
        MAD(:) = inf;
        % valid shifts
        pyInds = find(heightStart+py >= 1,1):find( ...
            heightEnd+py <= height+padHeight,1,'last');
        pxInds = find(widthStart+px >= 1,1):find( ...
            widthEnd+px <= width+padWidth,1,'last');
        
        % mesh grid of valid shifts indices and macroblock indices
        pxMesh = pxMeshFull(pyInds,pxInds);
        pyMesh = pyMeshFull(pyInds,pxInds);
        heightMesh = heightMeshFull(:) + (heightIdx-1)*blockSize(1);
        widthMesh = widthMeshFull(:) + (widthIdx-1)*blockSize(2);
        
        frameIdx = bsxfun(@plus, ...
            heightMesh+(widthMesh-1)*(height+padHeight), ...
            py(pyMesh(:)) + px(pxMesh(:))*(height+padHeight));
        madIdx = pyMesh + (pxMesh-1)*(2*searchSize(1)+1);
        % calculate MAD for valid shifts
        MAD(madIdx) = mean(abs( repmat(MB(:),1,numel(madIdx)) ...
            - oldFrame(frameIdx) ));
        
        % find movement using minimum MAD
        [~,MADind] = min(MAD(:));
        subY = mod(MADind-1,2*searchSize(1)+1) + 1;
        subX = (MADind-subY)/(2*searchSize(1)+1) + 1;
        MV(heightIdx,widthIdx) = px(subX) + 1j*py(subY);
    end
end