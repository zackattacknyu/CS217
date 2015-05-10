% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 1661.869788486886800 ; 1661.878228311368000 ];

%-- Principal point:
cc = [ 836.558147655548620 ; 607.339755380394990 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.152851157271211 ; 0.040115865599085 ; -0.001672473806558 ; 0.000577430369953 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 18.229037131590118 ; 16.840654207939618 ];

%-- Principal point uncertainty:
cc_error = [ 8.131937608965991 ; 16.927476497367440 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.019024705629905 ; 0.139835783665703 ; 0.001644401471963 ; 0.001105320337305 ; 0.000000000000000 ];

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
omc_1 = [ 2.196725e+000 ; 1.499061e+000 ; -3.046371e-001 ];
Tc_1  = [ -1.145363e+002 ; -5.093071e+001 ; 4.837819e+002 ];
omc_error_1 = [ 6.815955e-003 ; 4.912199e-003 ; 7.863811e-003 ];
Tc_error_1  = [ 2.380217e+000 ; 4.871397e+000 ; 5.429914e+000 ];

%-- Image #2:
omc_2 = [ 2.359714e+000 ; 1.250769e+000 ; -2.481789e-001 ];
Tc_2  = [ -1.337696e+002 ; -4.984360e+001 ; 5.346482e+002 ];
omc_error_2 = [ 7.280519e-003 ; 4.279513e-003 ; 7.450925e-003 ];
Tc_error_2  = [ 2.628532e+000 ; 5.393197e+000 ; 5.999063e+000 ];

%-- Image #3:
omc_3 = [ 2.431292e+000 ; 1.198780e+000 ; -1.920132e-001 ];
Tc_3  = [ -1.435055e+002 ; -2.739275e+001 ; 4.720042e+002 ];
omc_error_3 = [ 7.145682e-003 ; 4.025734e-003 ; 7.418878e-003 ];
Tc_error_3  = [ 2.321762e+000 ; 4.783939e+000 ; 5.264066e+000 ];

%-- Image #4:
omc_4 = [ 2.674102e+000 ; -3.089614e-001 ; 2.041899e-001 ];
Tc_4  = [ -3.527055e+001 ; 8.123221e+001 ; 4.088113e+002 ];
omc_error_4 = [ 7.959951e-003 ; 2.324576e-003 ; 7.041525e-003 ];
Tc_error_4  = [ 2.011434e+000 ; 4.260944e+000 ; 4.389379e+000 ];

%-- Image #5:
omc_5 = [ 3.050426e+000 ; -4.038726e-002 ; -1.381145e-002 ];
Tc_5  = [ -7.132581e+001 ; 1.175540e+002 ; 5.407745e+002 ];
omc_error_5 = [ 5.950944e-003 ; 7.593055e-004 ; 1.011790e-002 ];
Tc_error_5  = [ 2.677448e+000 ; 5.606331e+000 ; 5.880848e+000 ];

%-- Image #6:
omc_6 = [ 2.391451e+000 ; -1.590570e-002 ; -7.665738e-003 ];
Tc_6  = [ -7.989928e+001 ; 2.876476e+001 ; 3.318411e+002 ];
omc_error_6 = [ 9.410269e-003 ; 2.578609e-003 ; 6.033405e-003 ];
Tc_error_6  = [ 1.621604e+000 ; 3.415237e+000 ; 3.716358e+000 ];

%-- Image #7:
omc_7 = [ 2.393507e+000 ; -9.375720e-002 ; 2.745802e-002 ];
Tc_7  = [ -9.967156e+001 ; 1.134791e+001 ; 2.891540e+002 ];
omc_error_7 = [ 9.430183e-003 ; 2.645550e-003 ; 6.068142e-003 ];
Tc_error_7  = [ 1.412448e+000 ; 2.964857e+000 ; 3.236161e+000 ];

