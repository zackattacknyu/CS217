%
% This script tests the project and triangulate functions.
% You may want to modify it to try other tests and/or cut
% and paste bits into your interactive MATLAB session as 
% you are debugging.
%


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

%
% now try to recover the 3D locations from the 2D views
% add some noise to make the process more realistic.
%
xLnoisy = xL + 0.01*randn(size(xL)); 
xRnoisy = xR + 0.01*randn(size(xR));
Xrecov = triangulate(xLnoisy,xRnoisy,camL,camR);

%
% display results as a cloud of points
%
figure(3); clf;
plot3(X(1,:),X(2,:),X(3,:),'.');
hold on;
plot3(Xrecov(1,:),Xrecov(2,:),Xrecov(3,:),'ro');
axis image;
axis vis3d;
grid on;
legend('original points','recovered points')

%
%display results as a surface
%
figure(4);
subplot(2,1,1);
tri = delaunay(X(1,:),X(2,:));
trisurf(tri,X(1,:),X(2,:),X(3,:));
axis equal; axis vis3d; grid on;
title('original shape');
subplot(2,1,2);
tri = delaunay(Xrecov(1,:),Xrecov(2,:));
trisurf(tri,Xrecov(1,:),Xrecov(2,:),Xrecov(3,:));
axis equal; axis vis3d; grid on;
title('recovered shape');

