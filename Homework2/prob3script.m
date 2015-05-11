%{
Calibration results
from running the calibration toolbox
%}
%-- Focal length:
fc = [ 1661.869788486886800 ; 1661.878228311368000 ];
%-- Principal point:
cc = [ 836.558147655548620 ; 607.339755380394990 ];
%-- Image size:
nx = 1600;
ny = 1200;

%generates instrinsic matrix from these results
K = [nx*fc(1) 0 cc(1);0 ny*fc(2) cc(2); 0 0 1];

