% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function points = detectORBFeatures(I,varargin)
% points = detectORBFeatures(I,N,scaleFactor)
%   Implements Oriented BRIEF (ORB) detection, described in Ethan Rublee,
%   Vincent Rabaud, Kurt Konolige, Gary R. Bradski: ORB: An efficient
%   alternative to SIFT or SURF. ICCV 2011: 2564-2571.
%
%   Detects ORB features of image I. Outputs at most N features and uses
%   a factor of scaleFactor in the pyramid approach. Defaults are N=500
%   and scales=1.2

% default parameters (N, scales)
def_param = {500;1.2};
blockSize = 31; % block size for feature extraction
% check arguments to override default parameter values
for idx = 1:length(varargin)
    % check whether empty
    if isempty(varargin{idx})
        continue
    else % assign value
        def_param{idx} = varargin{idx};
    end
end
[N,scaleFactor] = def_param{:};

% use FAST to find keypoints
points = detectFASTFeatures(I);
% extract features
[features, valid_points] = extractFeatures(I, points, ...
    'Method', 'Block', 'BlockSize', blockSize);
% get Harris metric of FAST points
C = cornermetric(I);
pts = valid_points.Location;
idx = pts(:,2) + (pts(:,1)-1)*size(I,1);
R = C(idx);
% check that no more than the valid number of points are extracted
if N > length(valid_points)
    N = length(valid_points);
end
% sort points by Harris metric and keep N best
[~,idx] = sort(R, 'descend');
points = valid_points(idx(1:N));
features = features(idx(1:N),:);

% orient using intensity centroid
orientation = zeros(N,1); % orientation in radians
r = (blockSize-1)/2; % max magnitude radius of centroid
for idx = 1:N
    block = reshape(features(idx,:),blockSize,blockSize);
    centroidX = sum(block*(-r:r).');
    centroidY = sum((-r:r)*block);
    orientation(idx) = atan2(centroidY,centroidX);
end