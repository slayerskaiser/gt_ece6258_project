# gt_ece6258_project
GT ECE 6258 Project: Fish detection and tracking in underwater GoPro video
==================
by Klaus Okkelberg and Mengmeng Du
------------------

This project deals with processing underwater GoPro videos to detect, track, and recognize fish. The implementation is in Matlab.

The main steps for implementing this project are
  - Correction of spatial and color distortion
  - Detection of moving fish
  - Detection of non-moving fish and tracking
  - Recognition of fish

The following videos are being considered for this project:
  - GOPR0073
  - GOPR0062
  - GOPR0063
  - GOPR0059
  
The main steps are:
  - Image stabalization using FAST keypoint detection and SURF descriptors.
  - Motion detection between moving average of previous stabalized frames and current frame.
  - Additional masking based on estimated transmission map using dark channel prior method
  - Fish recognition using SURF and affine transformation matching to remove outliers.
