% ECE 6258 Project
% Klaus Okkelberg and Mengmeng Du

function DArg = computeDArg(I)
% Computes D-Arg isotropic operator

angles = 0:90:270;
aArg = zeros([size(I) length(angles)]);
for k = 1:length(angles)
    aArg(:,:,k) = imrotate(computeYArg(imrotate(I,angles(k))), -angles(k));
end
DArg = sum(aArg,3);

end

function YArg = computeYArg(I)
[~,GAng] = imgradient(I,'prewitt');
[~,YArg] = imgradientxy(-GAng,'prewitt');
end