
%%
%this part generates the data set

%
% first generate our test figure in 3D
%
X = generate_hemisphere(2,[0;0;10],1000);

%
% set intrinsic parameters shared by both camers
%

%focal length
camL.f = 1;
camR.f = 1;

%pixel magnification factor
camL.m = [100;100];
camR.m = [100;100];

%location of camera center
camL.c = [50;50];
camR.c = [50;50];

camL.K = generateIntrinsic(camL);
camR.K = generateIntrinsic(camR);

%
% extrinsic params for left camera
%
camL.t= [-0.2;0;0];
thy = atan2(camL.t(1),10); 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
camL.R = Ry;

%
%extrinsic params for right camera
%
camR.t= [0.2;0;0];
thy = atan2(camR.t(1),10); 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
camR.R = Ry;

%
% now compute the two projections
%
xL= project(X,camL);
xR = project(X,camR);

camL.Ext = generateExtrinsic(camL);
camR.Ext = generateExtrinsic(camR);

camL.C = camL.K*camL.Ext;
camL.C = camL.C./camL.C(3,4);
camR.C = camR.K*camR.Ext;
camR.C = camR.C./camR.C(3,4);

%%

%this runs the calibration function
camLtest = calibrate(X,xL);
camRtest = calibrate(X,xR);

%verifies the calibration matrix
calibDiffL = sum(sum(abs(camLtest.C-camL.C)));
calibDiffR = sum(sum(abs(camRtest.C-camR.C)));

%verify m and c
mDiffL = sum(abs(camL.m-camLtest.m));
cDiffL = sum(abs(camL.c-camLtest.c));
mDiffR = sum(abs(camR.m-camRtest.m));
cDiffR = sum(abs(camR.c-camRtest.c));

%verify R
RdiffL = sum(sum(abs(camL.R-camLtest.R)));
RdiffR = sum(sum(abs(camR.R-camRtest.R)));

%verify t
tDiffL = sum(abs(camL.t-camLtest.t));
tDiffR = sum(abs(camR.t-camRtest.t));

%%

xLnoisy1 = xL + 0.01*randn(size(xL)); 
xRnoisy1 = xR + 0.01*randn(size(xR));

camLtest1 = calibrate(X,xLnoisy1);
camRtest1 = calibrate(X,xRnoisy1);

xLnoisy2 = xL + 0.02*randn(size(xL)); 
xRnoisy2 = xR + 0.02*randn(size(xR));

camLtest2 = calibrate(X,xLnoisy2);
camRtest2 = calibrate(X,xRnoisy2);

xLnoisy3 = xL + 0.1*randn(size(xL)); 
xRnoisy3 = xR + 0.1*randn(size(xR));

camLtest3 = calibrate(X,xLnoisy3);
camRtest3 = calibrate(X,xRnoisy3);



