ECE 6258 Project: Fish detection in underwater GoPro video
by Klaus Okkelberg and Mengmeng Du

Video files for testing can be found at:
https://drive.google.com/folderview?id=0B3U6GI2mB6_HOVJKQ2J1bzVGR0U&usp=sharing

The results in the paper were generated using GOPR0059.MP4 in the main folder. Additional testing was done on GOPR0073.MP4 to tune the parameters, but those results are not shown.

The minimal example of how to use the provided code can be found in run_findfish.m. The main function is detectfish.m. There are extensive comments in that file about the methods. The files are:
  - compareFeatureMatchingMethod_stabalization.m - Compare how keypoint and descriptor methods affect stabalization error
  - compareKeypointMethod_fishDetection.m - Compare how keypoint method (with SURF descriptor) affects fish detection (number of matching keypoints and speed)
  - compareLensCorrection_stabalization.m - Compare how lens correction affects stabalization error
  - compareMasking_fishDetection.m - Compare how masking of keypoints affects fish detection
  - compareMasking_transmissionMapRefining.m - Compare how refining the transmission map from dark channel prior using Levin's matting Laplacian affects accuracy of masking (NOTE THAT THIS FUNCTION NEEDS AT LEAST 8 GB OF FREE MEMORY TO RUN AND IS VERY SLOW)
  - detectfish.m - Main function (see comments within)
  - fetchFrameColor.m - Reads frame from video file and performs stabalization
  - findFish_ModifiedSURF.m - Detects fish features using FAST keypoints and SURF descriptors. Uses thresholding of 5% for matching
  - findMatch_ModifiedSURF.m - Detects features for frame stabalization using FAST keypoints and SURF descriptors. Uses default ratio rejection of 0.6 (max ratio between best and second best match).
  - fish_cropped.jpg - Cropped image of an Indo-Pacific Sergeant (from http://www.whatsthatfish.com/image/view/3828) on black background
  - genFish.m - Reads in fish image and creates mask (legacy reasons)
  - lens_correct.m - Performs lens correction based on GoPro Hero 4 data (tweaked from unknown origin; lost reference when hard drive died)
  - loadDetectionParameters.m - Loads various parameters for consistency between main detectfish.m file and auxillary comparison files
  - mattingLaplacian.m - Generates Levin's matting Laplacian matrix
  - removeHaze.m - Removes "haze" from being underwater using dark channel prior method (source in file); if specified, softens the estimated transmission map by solving Levin's matting Laplacian using conjugate gradient method, preconditioned using the modified incomplete Cholesky factorization with thresholding dropping.
  - run_findfish.m - Minimal working example.
  - showFish.m - Displays matching features found using detectfish.m
  - stabalize.m - Stabalizes two frames by matching SURF descriptors, estimating a projective transformation, and transforms the previous frame if the transformation matrix is not singular

Video files were kept in the video folder. Image folder holds results from running comparison scripts. Results folder contains results shown in paper (results can change due to RANSAC during feature matching and geometric transformation estimation).

Files in results folder are:
  - featureMatchingMethodErrors.txt - Frobenius norm between stabalized frames for various keypoint and descriptor methods
  - fishDetection_FASTSURF.png - Matching keypoints using FAST keypoints and SURF descriptors (should be same as fishDetection_mask.png)
  - fishDetection_mask.png - Mask using transmission map and background refining, without softening of transmission map
  - fishDetection_mask_refine.png - Mask using softened transmission map and background refining
  - fishDetection_masking.png - Matching keypoints with masking
  - fishDetection_masking_keypointLocations.png - Only the keypoints on the frame (for clarity) using masking
  - fishDetection_nomasking.png - Matching keypoints without masking
  - fishDetection_SURF.png - Matching keypoints using SURF keypoints and descriptors
  - fishDetectionStats.txt - Statistics about number of matched keypoints and time spent
  - lensCorrectionErrors.txt - Frobenius norm between stabalized frames, with and without lens correction on both frames
  - stabalization_BRISK.png - Stabalization results using BRISK keypoints and descriptors
  - stabalization_FASTFREAK.png - Stabalization results using FAST keypoints and FREAK descriptors
  - stabalization_FASTSURF.png - Stabalization results using FAST keypoints and SURF descriptors
  - stabalization_lensCorrection.png - Stabalization results with lens correction (should be same as stabalization_FASTSURF.png)
  - stabalization_MinEigenFREAK.png - Stabalization results using Min. Eigenvalue keypoints and FREAK descriptors
  - stabalization_MSERSURF.png - Stabalization results using MSER keypoints and SURF descriptors
  - stabalization_noLensCorrection.png - Stabalization results without lens correction
  - stabalization_SURF.png - Stabalization results using SURF keypoints and SURF descriptors

The code was developed using Matlab 2014a (with all toolboxes) on Ubuntu Precise. The processor was an Intel Core i5 5200U at 2.2 GHz, and there was 4 GB of RAM. The FFMPEG 0.8.17 and GStreamer 0.10 libraries were used to read the video files.
