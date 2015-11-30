% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function out = lens_correct(in)
% Lens correction based on GoPro Hero 4 data:
%
% Focal Length:    fc = [1135.62996   1130.02170] & [3.85972   3.83678]
% Principal point: cc = [651.91387   349.40056] & [5.01779   4.55735]
% Skew:       alpha_c = [0.00000] & [0.00000] 
%                       => angle of pixel axes = 90.00000 0.00000 degrees
% Distortion:      kc = [-0.34735   0.19807   -0.00027   0.00007  0.00000] 
%                       => [0.01369   0.06904   0.00103   0.00055  0.00000]
% Pixel error:    err = [0.16702   0.32813]

in = colorcorrect_uw_full(in);
IntrinsicMatrix = [1135.63 0 0;
    0 1130.02 0;
    651.91 349.40 1];
radialDistortion = [-0.34735 0.19807];
cameraParams = cameraParameters('IntrinsicMatrix', IntrinsicMatrix, ...
         'RadialDistortion', radialDistortion);
out = undistortImage(in,cameraParams);