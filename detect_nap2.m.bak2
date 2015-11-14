% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function MP = detect_nap2(frames,Kmax,std_0)
% Non-adaptive Gaussian Mixture Model (GMM)
% uses cells for easy conversion to adaptive GMM

% size of frames
[N,M,nFrames] = size(frames);
% moving pixels
MP = false(N*M,nFrames-1);

% parameters
alpha = 1;
var_0 = std_0^2;
% params (per pixel) are [pi_k;mu_k;var_k]
params = mat2cell( ...
    [alpha*ones(1,N*M);im2double(reshape(frames(:,:,1),1,[]));var_0*ones(1,N*M)], ...
    3, ones(N*M,1)).';
% owner is first component
o_ks = ones(N*M,1);
% set initial background as first frame
CB = im2double(reshape(frames(:,:,1),[],1));

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
    delta_ks = cellfun( ...
        @(p,f) bsxfun(@minus, f, p(1,:)), ...
        params, num2cell(curFrame), 'uni', 0);
    dist2 = cellfun(@(delta) delta.^2, delta_ks, 'uni', 0);
    % close if normalized variance less than 3^2
    isClose = cellfun(@(d2,p) d2./p(3,:) < 9, dist2, params, 'uni', 0);
    
    % for close components, owner is one with largest pi_k
    anyClose = cellfun(@(x) any(x), isClose);
    [~,o_ks(anyClose)] = cellfun(@(p) max(p(1,:)), params(anyClose));
    % for far components, add new component
    K = cellfun(@(p) size(p,2), params);
    indAtMax = ~anyClose & K==Kmax;
    params(indAtMax) = cellfun(@removeMinComp, params(indAtMax), 'uni', 0);
    % new component added to end
    params(~anyClose) = cellfun(@(p,mu) [p [alpha;mu;var_0]], ...
        params(~anyClose), num2cell(curFrame(~anyClose)), 'uni', 0);
    K(~anyClose & K~=Kmax) = K(~anyClose & K~=Kmax) + 1;
    o_ks(~anyClose) = K(~anyClose & K~=Kmax);
    % create ownership matrix
    o_mat = arrayfun(@(o,Nk) sparse(1,o,1,1,Nk), o_ks, K, 'uni', 0);
    
    % update model parameters using ownership
%     pi_ks = (1-alpha)*pi_ks + alpha*o_mat;
%     mu_ks = mu_ks + o_mat .* (alpha./pi_ks) .* delta_ks;
%     mu_ks(isnan(mu_ks)) = 0;
%     var_ks = var_ks + o_mat .* (alpha./pi_ks) .* (dist2-var_ks);
    
    % determine background
%     CB = sum(pi_ks.*mu_ks,2);
end

MP = reshape(MP,N,M,nFrames-1);

function p = removeMinComp(p)
% given 3xK matrix of K components, returns 3x(K-1) matrix with component
% with smallest pi_k removed
[~,idx] = min(p(1,:));
p(:,idx) = [];