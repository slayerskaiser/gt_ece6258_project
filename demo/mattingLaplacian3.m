% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function L = mattingLaplacian3(frame,window,mask)
% generate Levin's NxN matting Laplacian

% convert to single for memory usage
frame = single(frame);

% regularizing parameter
epsilon = 1e-6;
% elements in window
nWindow = prod(window);
% assume window is odd, with w = 2*r+1
r = (window-1)/2;
% frame size
[height,width,nColors] = size(frame);
N = height*width;
% replicate frame edges
frame = padarray(frame,r,'replicate');
% nColors x nColors identity
U = eye(nColors);

% erode mask
mask = imerode(mask,ones(window));
% maximum nonzero elements of sparse L
LnzMax = sum(sum(~mask(1+r(1):height-r(1),1+r(2):width-r(2))))*nWindow^2;
% construct vectors for holding values and locations of nonzero elements
rowInds = zeros(LnzMax,1,'uint32');
colInds = zeros(LnzMax,1,'uint32');
values = zeros(LnzMax,1,'single');

% loop over window centers
% (note that previous padding shifts indices by r)
lenVals = 0; % number of stored values
for row = 1:height-2*r(1)
    for col = 1:width-2*r(2)
        % skip based on mask
        if mask(row,col)
            continue
        end
        
        % row and column indices
        rowInd = row:row+2*r(1); colInd = col:col+2*r(2);
        % linear indices
        rowIndMat = repmat(rowInd.',1,length(colInd));
        colIndMat = repmat(colInd,length(rowInd),1);
        k = rowIndMat(:) + (colIndMat(:) - 1)*height;
        kMat = repmat(k,1,nWindow);
        % extract window
        w_k = reshape(frame(rowInd,colInd,:),[],nColors).';
        % mean vector and covariance matrix
        mu_k = mean(w_k,2);
        % pixels within window, normalized so average color is 0
        I = bsxfun(@minus, w_k, mu_k);
        % regularized covariance matrix
        % (note that I*I.' is covariance since mean was removed)
        covReg = (I*I.' + epsilon*U)/nWindow;
        
        % L(i,j) values (ignoring delta_ij)
        % (will account for diagonal values at end)
        tmpVal = - (1 + I.'/covReg*I)/nWindow;
        
        % store indices and values
        rowInds(lenVals+(1:nWindow^2)) = kMat;
        colInds(lenVals+(1:nWindow^2)) = kMat.';
        values(lenVals+(1:nWindow^2)) = tmpVal;
        % advance shift
        lenVals = lenVals + nWindow^2;
    end
end
% truncate vectors
rowInds = double(rowInds(1:lenVals));
colInds = double(colInds(1:lenVals));
values = double(values(1:lenVals));

% construct L from indices and values
% (note that values at duplicate indices are added together)
L = sparse(rowInds,colInds,values,N,N);

% change diagaonal of L so sum of rows are 0
L = spdiags(-sum(L,2),0,N,N) + L;