% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function L = mattingLaplacian2(frame,window)
% generate Levin's NxN matting Laplacian with given window
% (assume window is odd)

% regularizing parameter
epsilon = 1e-8;
% elements in window
nWindow = prod(window);
% frame size
[height,width,nColors] = size(frame);
N = height*width;
% nColors x nColors identity
U = eye(nColors);
% possible neighbors
neighboringRows = -window(1)+1:window(1)-1;
neighboringCols = -window(2)+1:window(2)-1;
% possible window shifts containing center
rowShifts = -(window(1)-1)/2:(window(1)-1)/2;
colShifts = -(window(2)-1)/2:(window(2)-1)/2;

% padded frame
framePad = padarray(frame,(window-1)/2,'replicate');
% indices shift due to padding
padShiftRows = (window(1)-1)/2;
padShiftCols = (window(2)-1)/2;
% window means and  inverse of regularized covariances
mu_k = zeros([nColors height width]);
covRegInv_k = zeros([nColors nColors height width]);
for row = 1:height
    for col = 1:width
        w = reshape(framePad(row + padShiftRows + rowShifts, ...
            col + padShiftCols + colShifts,:), [], nColors);
        mu_k(:,row,col) = mean(w,1);
        covRegInv_k(:,:,row,col) = (cov(w) + epsilon/nWindow*U) \ U;
    end
end

% vectorize frame (un-padded)
frame = reshape(frame,[],nColors).';

% calculate matting Laplacian matrix
%
% number of neighboring pixels within window
nNeighbors = length(neighboringRows) * length(neighboringCols);
L = spalloc(N,N,nNeighbors);
% loop over columns of L
for j = 1:N
    % find corresponding image indices
    jRow = mod(j-1,height) + 1;
    jCol = (j-jRow)/height + 1;
    % find all neighbors within window
    iRows = jRow + neighboringRows;
    iCols = jCol + neighboringCols;
    % remove out-of-range indices
    iRows(iRows < 1) = []; iRows(iRows > height) = [];
    iCols(iCols < 1) = []; iCols(iCols > height) = [];
    % indices of L for neighboring i
    iRows = repmat(iRows.',1,length(iCols));
    iCols = repmat(iCols,size(iRows,1),1);
    i = iRows(:) + (iCols(:)-1)*height;
    
    % get pixel at j
    Ij = frame(:,j);
    
    % calculate L for each (i,j)
    tmpCol = zeros(length(i),1);
    for idx = 1:length(i)
        % pixel at i
        Ii = frame(:,i(idx));
        % Kronecker delta
        delta = (i(idx)==j);
        
        % number of shifts along rows and columns for window, starting from
        % window centered on pixel j
        rowDiff = iRows(idx) - jRow; colDiff = iCols(idx) - jCol;
        % shifts of window along rows
        kRowShift = rowShifts + rowDiff;
        kRowShift(kRowShift < min(rowShifts) ...
            | kRowShift > max(rowShifts)) = [];
        % shifts of window along columns
        kColShift = colShifts + colDiff;
        kColShift(kColShift < min(colShifts) ...
            | kColShift > max(colShifts)) = [];
        % sum over possible windows k
        for idxRow = 1:length(kRowShift)
            % row index of padded frame for window
            wRow = jRow + kRowShift(idxRow) + 1;
            if wRow < 1 || wRow > height
                continue
            end
            for idxCol = 1:length(kColShift)
                % column index of padded frame for window
                wCol = jCol + kColShift(idxCol) + 1;
                if wCol < 1 || wCol > width
                    continue
                end
                % calculate (i,j) element of L for w_k
                tmpCol(idx) = tmpCol(idx) + delta ...
                    - (1 + (Ii-mu_k(:,wRow,wCol)).' ...
                    * covRegInv_k(:,:,wRow,wCol) ...
                    * (Ij-mu_k(:,wRow,wCol)))/nWindow;
            end
        end
    end
    L(i,j) = tmpCol;
end