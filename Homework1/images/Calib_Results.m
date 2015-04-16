% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 1602.728199544142200 ; 1627.132891974834400 ];

%-- Principal point:
cc = [ 830.782186100948930 ; 563.592745345227400 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.617291747184404 ; -2.117739689180014 ; -0.010648977654825 ; 0.022417101519764 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 75.454007119448818 ; 76.764843109731018 ];

%-- Principal point uncertainty:
cc_error = [ 41.546806534555117 ; 54.404518557484508 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.203113231827649 ; 1.401053912077304 ; 0.019759053238929 ; 0.017786120451214 ; 0.000000000000000 ];

%-- Image size:
nx = 1632;
ny = 1224;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 9;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -2.875151e+000 ; -1.127675e+000 ; -1.364095e-001 ];
Tc_1  = [ -1.204829e+002 ; 1.027400e+002 ; 7.883810e+002 ];
omc_error_1 = [ 4.472150e-002 ; 2.356276e-002 ; 7.281315e-002 ];
Tc_error_1  = [ 2.056321e+001 ; 2.622939e+001 ; 3.756761e+001 ];

%-- Image #2:
omc_2 = [ 2.296942e+000 ; 2.157110e-001 ; -8.301041e-002 ];
Tc_2  = [ -1.370354e+002 ; 9.924528e+001 ; 7.877825e+002 ];
omc_error_2 = [ 3.495123e-002 ; 1.463462e-002 ; 3.506433e-002 ];
Tc_error_2  = [ 2.043305e+001 ; 2.682036e+001 ; 3.989475e+001 ];

%-- Image #3:
omc_3 = [ 2.533777e+000 ; -6.259156e-001 ; 1.717914e-001 ];
Tc_3  = [ -2.443914e+001 ; 1.714384e+002 ; 8.418377e+002 ];
omc_error_3 = [ 3.949761e-002 ; 1.618828e-002 ; 4.521306e-002 ];
Tc_error_3  = [ 2.197549e+001 ; 2.869135e+001 ; 4.284432e+001 ];

%-- Image #4:
omc_4 = [ 2.723025e+000 ; 9.472174e-001 ; -5.816714e-001 ];
Tc_4  = [ -1.483732e+002 ; 4.174847e+001 ; 5.337408e+002 ];
omc_error_4 = [ 3.178855e-002 ; 1.889154e-002 ; 4.736127e-002 ];
Tc_error_4  = [ 1.380270e+001 ; 1.781523e+001 ; 2.375142e+001 ];

%-- Image #5:
omc_5 = [ 2.115017e+000 ; 5.746409e-001 ; -2.974200e-001 ];
Tc_5  = [ -1.758468e+002 ; -4.346085e+000 ; 5.436961e+002 ];
omc_error_5 = [ 3.146058e-002 ; 1.903295e-002 ; 2.957024e-002 ];
Tc_error_5  = [ 1.402617e+001 ; 1.844842e+001 ; 2.719939e+001 ];

%-- Image #6:
omc_6 = [ 2.512329e+000 ; 9.168000e-001 ; -2.048408e-001 ];
Tc_6  = [ -1.606362e+002 ; 1.241118e+001 ; 4.040352e+002 ];
omc_error_6 = [ 3.071940e-002 ; 1.596030e-002 ; 3.837807e-002 ];
Tc_error_6  = [ 1.050551e+001 ; 1.376337e+001 ; 2.018835e+001 ];

%-- Image #7:
omc_7 = [ 2.615818e+000 ; -9.284691e-001 ; 7.242020e-001 ];
Tc_7  = [ 2.359158e+000 ; 1.792489e+001 ; 5.902776e+001 ];
omc_error_7 = [ 3.937893e-002 ; 2.646301e-002 ; 5.265642e-002 ];
Tc_error_7  = [ 1.590586e+000 ; 2.074310e+000 ; 3.028207e+000 ];

%-- Image #8:
omc_8 = [ 2.381960e+000 ; -4.524361e-001 ; 9.633156e-002 ];
Tc_8  = [ -7.360199e+000 ; 1.641022e+001 ; 6.609658e+001 ];
omc_error_8 = [ 4.348819e-002 ; 2.055555e-002 ; 5.202681e-002 ];
Tc_error_8  = [ 1.779856e+000 ; 2.327974e+000 ; 3.628339e+000 ];

%-- Image #9:
omc_9 = [ 2.269530e+000 ; 5.934121e-001 ; -2.807244e-001 ];
Tc_9  = [ -1.395255e+002 ; 8.579604e+000 ; 6.429907e+002 ];
omc_error_9 = [ 3.226313e-002 ; 1.684389e-002 ; 3.274634e-002 ];
Tc_error_9  = [ 1.657421e+001 ; 2.169780e+001 ; 3.085638e+001 ];

