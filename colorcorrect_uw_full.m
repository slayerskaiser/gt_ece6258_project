% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function out = colorcorrect_uw_full(in)

out = in; % output has same size and type as input
in = im2double(in);
[N,M,C] = size(in);
in = reshape(in,[],C);

% transform matrices
T_RGB2XYZ = [0.5141 0.3239 0.1604;
             0.2651 0.6702 0.0641;
             0.0241 0.1228 0.8444];
T_XYZ2LMS = [0.3897 0.6890 0.0787;
            -0.2298 1.1834 0.0464;
             0.0000 0.0000 1.0000];
T_logLMS2lab = diag([1/sqrt(3),1/sqrt(6),1/sqrt(2)]) ...
    * [1 1 1; 1 1 -2; 1 -1 0];

in = in*T_RGB2XYZ.'*T_XYZ2LMS.';
in = exp(log(in)*T_logLMS2lab.');

for k = 1:C
%     out(:,:,k) = reshape(im2uint8(mat2gray(in(:,k))),N,M);
    out(:,:,k) = reshape(mat2gray(in(:,k)),N,M);
end