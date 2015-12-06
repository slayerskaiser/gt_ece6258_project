% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function L = mattingLaplacian(frame,window)
% generate Levin's NxN matting Laplacian

% regularizing parameter
epsilon = 1e-8;
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

% row and column indices for window
iRowInd = mod((1:nWindow).'-1,window(1)) + 1;
iColInd = ((1:nWindow).'-iRowInd)/window(1) + 1;

% calculate matting Laplacian matrix
L = sparse(N,N);
% loop over window centers
% (note that previous padding shifts indices by r
for row = 1:height-2*r(1)
    for col = 1:width-2*r(2)
        % extract window
        rowInd = row:row+2*r(1); colInd = col:col+2*r(2);
        w_k = reshape(frame(rowInd,colInd,:),[],nColors).';
        % mean vector and covariance matrix
        mu_k = mean(w_k,2);
        Sigma_k = cov(w_k.');
        % inverse of regularized covariance
        covRegInv = (Sigma_k + epsilon/nWindow*U)\U;
        
        % loop over pixels in window
        tmpLcol = zeros(nWindow,1);
        for j = 1:nWindow
            % find indices for L
            %   * columns
            jRowInd = mod(j-1,window(1)) + 1;
            jColInd = (j-jRowInd)/window(1) + 1;
            jL = rowInd(jRowInd) + (colInd(jColInd)-1)*height;
            %   * rows
            iL = rowInd(iRowInd) + (colInd(iColInd)-1)*height;
            for i = 1:nWindow
                % calculate (i,j) element of L for w_k
                tmpLcol(i) = (iL(i)==jL) - (1 + (w_k(:,i)-mu_k).'  ...
                    * covRegInv * (w_k(:,j)-mu_k))/nWindow;
            end
            % sum over k for windows w_k
            L(iL,jL) = L(iL,jL) + tmpLcol;
        end
    end
end