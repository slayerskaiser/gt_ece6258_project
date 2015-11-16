% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function out = colorcorrect_uw(in)

in = im2double(in);
[N,M,C] = size(in);
in = reshape(in,[],C);

T_RGB_XYZ = [0.5141 0.3239 0.1604;
             0.2651 0.6702 0.0641;
             0.0241 0.1228 0.8444];
         
         
T_XYZ_LMS = [0.3897 0.6890 0.0787;
            -0.2298 1.1834 0.0464;
             0.0000 0.0000 1.0000];
         
T_logLMS_lab = diag([1/sqrt(3),1/sqrt(6),1/sqrt(2)]) ...
    * [1 1 1; 1 1 -2; 1 -1 0];

% in = T_XYZ_LMS * T_RGB_XYZ * in;
% in = T_logLMS_lab * log(in+eps);
% in = T_logLMS_lab*exp(in);
% in = exp(T_logLMS_lab*log(in));

in = in*T_RGB_XYZ.'*T_XYZ_LMS.';
in = exp(log(in)*T_logLMS_lab.');

% in = im2uint8(in);

% out = im2uint8(T_RGB_XYZ*in).';
% out = reshape(out,N,M,C);

out = reshape(im2uint8(mat2gray(in(:,1))),N,M);
% out = reshape(im2uint8(mat2gray(in(:,3))),N,M);


% l = out(:,:,1);
% a = out(:,:,2);
% b = out(:,:,3);
% l = im2uint8(mat2gray(l));
% a = im2uint8(mat2gray(a));
% b = im2uint8(mat2gray(b));