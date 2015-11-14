% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detect_nap(frames,Kmax,std_0)
% Non-adaptive Gaussian Mixture Model (GMM)

% size of frames
[N,M,nFrames] = size(frames);
% moving pixels
MP = false(N*M,nFrames-1);

% parameters
% alpha = 1/(N*M); % weight so sum(pi_m) = 1
alpha = 1;
pi_ks = zeros(N*M,Kmax);
mu_ks = zeros(N*M,Kmax);
var_ks = zeros(N*M,Kmax);
% var_0 = (0.05)^2; % 5% change
var_0 = std_0^2;

% initialize parameters using first frame (first component)
K = ones(N*M,1); % number of current GMM components
pi_ks(:,1) = alpha;
mu_ks(:,1) = im2double(reshape(frames(:,:,1),[],1));
var_ks(:,1) = var_0;
% owner is first component
o_ks = ones(N*M,1);
o_mat = zeros(N*M,Kmax); % matrix form
% set initial background as first frame
CB = mu_ks(:,1);

tic
% get moving pixels while updating GMM
for n = 2:nFrames
    fprintf('Starting frame %d, t=%f\n',n,toc)
    % current frame
    curFrame = im2double(reshape(frames(:,:,n),[],1));
    
    % moving pixels
    dif = abs(CB - curFrame);
    MP(:,n-1) = dif > graythresh(dif);
    
    % get squared distance normalized by variance and check closeness
    delta_ks = bsxfun(@minus,curFrame,mu_ks);
    dist2 = delta_ks.^2;
    % close if normalized variance less than 3^2
    isClose = dist2./var_ks < 9;
    
    % for close components, owner is one with largest pi_k
    anyClose = any(isClose,2);
    pi_masked = pi_ks.*isClose;
    [~,o_ks(anyClose)] = max(pi_masked(anyClose,:),[],2);
    % for far components, add new component
    indNotMax = ~anyClose & K~=Kmax;
    K(indNotMax) = K(indNotMax) + 1;
    o_ks(indNotMax) = K(indNotMax);
    indAtMax = ~anyClose & K==Kmax;
    [~,idxs] = min(pi_ks(indAtMax,:),[],2);
    indsNewComp = sub2ind([N*M Kmax],find(indAtMax),idxs);
    o_ks(indAtMax) = idxs;
    pi_ks(indsNewComp) = alpha;
    mu_ks(indsNewComp) = curFrame(indAtMax);
    var_ks(indsNewComp) = var_0;
    % create ownership matrix
    o_mat(:) = 0;
    indOwn = sub2ind([N*M Kmax],(1:N*M).',o_ks);
    o_mat(indOwn) = 1;
    
    % update model parameters using ownership
    pi_ks = (1-alpha)*pi_ks + alpha*o_mat;
    mu_ks = mu_ks + o_mat .* (alpha./pi_ks) .* delta_ks;
    mu_ks(isnan(mu_ks)) = 0;
    var_ks = var_ks + o_mat .* (alpha./pi_ks) .* (dist2-var_ks);
    
    % determine background
    % (not sure if equivalent to commented out part)
    CB = sum(pi_ks.*mu_ks,2);
%     pi_sum = cumsum(pi_ks,2);
%     for k = 1:N*M
%         % number of clusters in background
%         idx = find(pi_sum(k,:)>1-cf,1);
%         % create background
%         CB(k) = pi_ks(k,1:idx) * mu_ks(k,1:idx).';
%     end
end

MP = reshape(MP,N,M,nFrames-1);