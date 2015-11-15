% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function out = colorcorrect_uw(in)

in = im2double(in);
[N,M,C] = size(in);
in = reshape(in,[],C).';

T_RGB_XYZ = [0.5141 0.3239 0.1604;
             0.2651 0.6702 0.0641;
             0.0241 0.1228 0.8444];
         
         
T_XYZ_LMS = [0.3897 0.6890 0.0787;
            -0.2298 1.1834 0.0464;
             0.0000 0.0000 1.0000];
         
T_logLMS_lab = diag([1/sqrt(3),1/sqrt(6),1/sqrt(2)]) ...
    * [1 1 1; 1 1 -2; 1 -1 0];

in = T_XYZ_LMS * T_RGB_XYZ * in;
% in = T_logLMS_lab * log(in+eps);
% in = T_logLMS_lab*exp(in);
in = exp(T_logLMS_lab*log(in));

% in = im2uint8(in);

out = reshape(in.',N,M,C);