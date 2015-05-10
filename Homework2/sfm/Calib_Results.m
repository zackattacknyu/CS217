% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 2033.515125127354200 ; 2139.673262175737800 ];

%-- Principal point:
cc = [ 893.782235806979320 ; 509.929381552262100 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.245246226989314 ; 0.249818786196874 ; 0.008163796948895 ; -0.003173062519062 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 350.450243582578480 ; 306.969183046328850 ];

%-- Principal point uncertainty:
cc_error = [ 38.712847079798401 ; 447.920786500197950 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.115441218463164 ; 1.151865393351281 ; 0.050469940349752 ; 0.004623840462331 ; 0.000000000000000 ];

%-- Image size:
nx = 1600;
ny = 1200;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 7;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 2.097889e+00 ; 1.419880e+00 ; -3.690701e-01 ];
Tc_1  = [ -1.313870e+02 ; -2.149268e+01 ; 5.922803e+02 ];
omc_error_1 = [ 1.109682e-01 ; 6.307770e-02 ; 6.270271e-02 ];
Tc_error_1  = [ 1.141836e+01 ; 1.223236e+02 ; 1.033361e+02 ];

%-- Image #2:
omc_2 = [ 2.247519e+00 ; 1.180193e+00 ; -2.957418e-01 ];
Tc_2  = [ -1.522908e+02 ; -1.766092e+01 ; 6.539376e+02 ];
omc_error_2 = [ 1.146126e-01 ; 5.278948e-02 ; 4.844548e-02 ];
Tc_error_2  = [ 1.255221e+01 ; 1.354670e+02 ; 1.141223e+02 ];

%-- Image #3:
omc_3 = [ NaN ; NaN ; NaN ];
Tc_3  = [ NaN ; NaN ; NaN ];
omc_error_3 = [ NaN ; NaN ; NaN ];
Tc_error_3  = [ NaN ; NaN ; NaN ];

%-- Image #4:
omc_4 = [ NaN ; NaN ; NaN ];
Tc_4  = [ NaN ; NaN ; NaN ];
omc_error_4 = [ NaN ; NaN ; NaN ];
Tc_error_4  = [ NaN ; NaN ; NaN ];

%-- Image #5:
omc_5 = [ NaN ; NaN ; NaN ];
Tc_5  = [ NaN ; NaN ; NaN ];
omc_error_5 = [ NaN ; NaN ; NaN ];
Tc_error_5  = [ NaN ; NaN ; NaN ];

%-- Image #6:
omc_6 = [ NaN ; NaN ; NaN ];
Tc_6  = [ NaN ; NaN ; NaN ];
omc_error_6 = [ NaN ; NaN ; NaN ];
Tc_error_6  = [ NaN ; NaN ; NaN ];

%-- Image #7:
omc_7 = [ NaN ; NaN ; NaN ];
Tc_7  = [ NaN ; NaN ; NaN ];
omc_error_7 = [ NaN ; NaN ; NaN ];
Tc_error_7  = [ NaN ; NaN ; NaN ];

